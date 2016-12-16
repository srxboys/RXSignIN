//
//  RXCalendarView.m
//  RXSignIN
//
//  Created by srx on 2016/12/1.
//  Copyright © 2016年 https://github.com/srxboys. All rights reserved.
//

#import "RXCalendarView.h"
#import "RXCharacter.h"
#import "NSDateUtilities.h"

#import "RXCalendarDate.h"
#import "RXCalendarModel.h"
#import "RXCalendarWeekCell.h"
#import "RXCalendarDayCell.h"

#define DATANAME_Array @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"]
#define Prize_Array @[@(5),@(10),@(20),@(30)]
#define Prize_DicForKey @[@"five",@"ten",@"twenty",@"thirty"]


@interface RXCalendarView ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    UICollectionView * _calendarCollection;
    CGFloat   _itemWidth;
    //    CGFloat   _itemWeekHeight; //用于适配iPad时，需要改的
    //    CGFloat   _itemDayHeight; //用于适配iPad时，需要改的
    
    NSInteger _nowDayRow;//日历 今天在数组中下标 //如果今天没有签到，点击后需要改数据源
    NSInteger _currentSelected;
    NSMutableArray * _sourceArray;//日历 数据源
    
    NSInteger _startSign; //签到了几天
    NSInteger _signPrize_row;
}

@end

@implementation RXCalendarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        CGFloat width = ScreenWidth - 20;//左右20
        _itemWidth = floor(width / 7);
        CGFloat collectionWidth = _itemWidth * 7;
        CGFloat insetLeftRight = (ScreenWidth - collectionWidth)/2.0;
        _calendarCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(insetLeftRight, 0, collectionWidth, CalendarView_Height) collectionViewLayout:flowLayout];
        _calendarCollection.backgroundColor = [UIColor whiteColor];
        _calendarCollection.delegate = self;
        _calendarCollection.dataSource = self;
        _calendarCollection.bounces = NO;
//        _calendarCollection.userInteractionEnabled = NO; //日历是否可以点击
        [self addSubview:_calendarCollection];
        
        [_calendarCollection registerClass:[RXCalendarWeekCell class] forCellWithReuseIdentifier:@"week"];
        [_calendarCollection registerClass:[RXCalendarDayCell class] forCellWithReuseIdentifier:@"day"];
        
        _sourceArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)signInCalendarSorceDataWithSignList:(NSArray *)signListArr signPrize:(NSDictionary *)signPrizeDic signHistory:(NSDictionary *)signHistoryDic memberDay:(NSArray *)memberDayArr {
    
    if([_sourceArray arrBOOL]) [_sourceArray removeAllObjects];
    
    NSDate * nowDate = [NSDate date];
    NSInteger daysInThisMonth = [RXCalendarDate totaldaysInThisMonth:nowDate];
    NSInteger daysInLastMonth = [RXCalendarDate totaldaysInThisMonth:[RXCalendarDate lastMonth:nowDate]];
    NSInteger firstWeekday = [RXCalendarDate firstWeekdayInThisMonth:nowDate];
    NSInteger day = 0;
    BOOL isShowNowDay = NO;//今天，是否显示过
    BOOL nowDayIsSignIn = NO;// 今天是否签到过
    
    NSDate * startSignDate = nil;
    _startSign = 0;
    //连续签到的 记录
    if([signHistoryDic dictBOOL]) {
        NSString * timeString = [signHistoryDic objectForKeyNotNull:@"sign_start"];
        _startSign = [[signHistoryDic objectForKeyNotNull:@"sign_duration"] integerValue];
        
        if(_startSign>0 && [timeString strBOOL]) {
            startSignDate = [NSDate dateWithTimeIntervalSince1970:[timeString longLongValue]];
        }
        else {
            startSignDate = nil;
        }
    }
    
    if(startSignDate == nil) {
        startSignDate = nowDate;
    }
    
    NSDate * cellDate = nil;//某个cell 的 时间戳
    NSInteger signList_row = [signListArr arrBOOL] ? signListArr.count - 1 : 0; //倒序查找
    _signPrize_row = 0;//按照 define 字典的key获取
    NSInteger memberDay_row = [memberDayArr arrBOOL] ?memberDayArr.count - 1 : 0;//倒序查找
    
    ///要返回给 topView
    NSInteger needSignDay = 0;
    NSString * needGetPrizeName = @"";
    NSString * needPrizeName = @"";
    NSInteger needSignBOOL = 1;
    
    for (NSInteger i = 0; i < 42; i ++) {
        RXCalendarModel * model = [[RXCalendarModel alloc] init];
        
        model.isSignIn = NO;
        model.isEnable = NO;
        model.isNowDay = NO;
        model.isSelected = NO;
        //cell 某天
        if (i < firstWeekday) {
            day = daysInLastMonth - firstWeekday + 1 + i;
            //前面补 天数（上个月 多出的 后天几天）
            NSDate * currentDate =  [nowDate monthsAgo:nowDate.month - 1];
            if(currentDate.year == nowDate.year - 1) {
                //去年
                cellDate = [NSDate dateWithYear:currentDate.year month:12 day:day];
            }
            else {
                cellDate = [NSDate dateWithYear:nowDate.year month:nowDate.month - 1 day:day];
            }
            
        }else if (i > firstWeekday + daysInThisMonth - 1){
            //后面补 天数 （下个月 多出的 后天几天）
            day = i - firstWeekday - daysInThisMonth + 1;
            NSDate * currentDate =  [nowDate monthsAgo:nowDate.month + 1];
            if(currentDate.year == nowDate.year + 1) {
                //明年
                cellDate = [NSDate dateWithYear:currentDate.year month:1 day:day];
            }
            else {
                cellDate = [NSDate dateWithYear:nowDate.year month:nowDate.month + 1 day:day];
            }
            
        }else{
            //1-30、31 天数
            day = i - firstWeekday + 1;
            model.isEnable = YES;
            model.isNowDay = NO;
            model.isSelected = NO;
            if(!isShowNowDay) {
                if(day == [RXCalendarDate day:nowDate]) {
                    model.isNowDay = YES;
                    model.isSelected = YES;
                    isShowNowDay = YES;
                    _currentSelected = i;
                    _nowDayRow = i;
                }
            }
            cellDate = [NSDate dateWithYear:nowDate.year month:nowDate.month day:day];
        }
        model.day = day;
        model.date = cellDate;
        
        //某天 签到记录
        if([signListArr arrBOOL]) {
            if(signList_row >= 0) {
                NSString * signTime = signListArr[signList_row];
                if([signTime strBOOL]) {
                    
                    NSDate * signDate = [NSDate dateWithTimeIntervalSince1970:[signTime longLongValue]];
                    
                    
                    if(cellDate.year > signDate.year) {
                        //当前 年份 > 签到 年份
                        signList_row--;
                        for (; signList_row >= 0; signList_row--) {
                            signTime = signListArr[signList_row];
                            if(![signTime strBOOL]) continue;
                                
                            signDate = [NSDate dateWithTimeIntervalSince1970:[signTime longLongValue]];
                            if(cellDate.year <= signDate.year) {
                                break;
                            }
                        }
                    }
                    
                    if(cellDate.year == signDate.year && cellDate.month > signDate.month){
                        //当前月份 > 签到月份
                        signList_row --;
                        for (; signList_row >= 0; signList_row--) {
                            signTime = signListArr[signList_row];
                            if(![signTime strBOOL]) continue;
                            
                            signDate = [NSDate dateWithTimeIntervalSince1970:[signTime longLongValue]];
                            if(cellDate.year < signDate.year || (cellDate.year == signDate.year && cellDate.month <= signDate.month)) {
                                break;
                            }
                        }
                    }
                    
                    if(cellDate.year == signDate.year && cellDate.month == signDate.month && cellDate.day > signDate.day){
                        //当前 月中的日 > 签到 月中的日
                        signList_row--;
                        for (; signList_row >= 0; signList_row--) {
                            signTime = signListArr[signList_row];
                            if(![signTime strBOOL]) continue;
                            
                            signDate = [NSDate dateWithTimeIntervalSince1970:[signTime longLongValue]];
                            if((cellDate.year < signDate.year)||(cellDate.year == signDate.year && cellDate.month < signDate.month) ||( cellDate.year == signDate.year && cellDate.month == signDate.month && cellDate.day <= signDate.day)) {
                                
                                break;
                                
                            }
                        }
                    }
                    
                    if([cellDate isEqualToDateIgnoringTime:signDate]) {
                        model.isSignIn = YES;
                        signList_row --;
                        
                        if([signDate isEqualToDateIgnoringTime:nowDate]) {
                            model.isNowDay = YES;
                            nowDayIsSignIn = YES;
                            _currentSelected = i;
                            _nowDayRow = i;
                        }
                    }
                }
            }
        }
        
        
        
        //签到 5 10 20 30 的奖励
        if(startSignDate != nil && [signPrizeDic dictBOOL]) {
            NSInteger totalDay = [[Prize_Array lastObject] integerValue];
            NSInteger prize_Array_count = Prize_Array.count;
            NSInteger dayLater =[Prize_Array[_signPrize_row%prize_Array_count] integerValue];
            NSInteger _signPrize_row_y = _signPrize_row >= Prize_Array.count ? 1 : 0;
            dayLater += totalDay * _signPrize_row_y;
            NSDate * prizeDate = [startSignDate daysLater:dayLater - 1];
            
            if(cellDate.year == prizeDate.year && cellDate.month == prizeDate.month && cellDate.day == prizeDate.day) {
                
                NSDictionary * prizeDict = [signPrizeDic objectForKeyNotNull:Prize_DicForKey[_signPrize_row%prize_Array_count]];
                if([prizeDict dictBOOL]) {
                    NSString * prizeStr = [prizeDict objectForKeyNotNull:@"amount"];
                    NSInteger prizeNum = [prizeStr integerValue];
                    if(prizeNum > 0) {
                        model.prizeName =[NSString stringWithFormat:@"￥%zd", prizeNum];
                        model.score = prizeNum;
                    }
                    
                    NSString * prizeDesc = [prizeDict objectForKeyNotNull:@"describe"];
                    
                    //返回给 prizeView
                    if(_startSign <= dayLater && needSignBOOL) {
                        needSignBOOL = 0;
                        needPrizeName = prizeDesc;
                        needSignDay = dayLater;
                        if(_startSign == dayLater) {
                            needGetPrizeName = prizeDesc;
                            needSignBOOL = 1;
                        }
                    }
                    
                    
                }
                
                _signPrize_row++;
            }
            else if(cellDate.year > prizeDate.year) {
                //当前 年份 > 第一次签到 年份
                _signPrize_row++;
            }
            else if(cellDate.year == prizeDate.year && cellDate.month > prizeDate.month) {
                //当前月份 > 第一次签到 月份
                _signPrize_row++;
            }
            else if(cellDate.year == prizeDate.year && cellDate.month == prizeDate.month && cellDate.day > prizeDate.day){
                //当前月中的日 > 第一次签到 月中的日
                _signPrize_row++;
            }
            
            
        }
        
        
        //会员日
        if([memberDayArr arrBOOL]) {
            if(memberDay_row >= 0) {
                NSDictionary * dictionary = memberDayArr[memberDay_row];
                if([dictionary dictBOOL]) {
                    NSString * timeDateStr = [dictionary objectForKeyNotNull:@"date"];
                    NSDate * memberDate = [NSDate dateWithTimeIntervalSince1970:[timeDateStr longLongValue]];
                    
                    if([cellDate isEqualToDateIgnoringTime:memberDate]) {
                        model.prizeName = [dictionary objectForKeyNotNull:@"message"];
                        memberDay_row --;
                    }
                }
            }
        }
        
        [_sourceArray addObject:model];
    }
    
    [_calendarCollection reloadData];
    
    
    //是否 签到 block返回给controller
    /**
     *  @param isSignIn      今天 是否 签到了
     *  @param signInDay     签到第几天
     *  @param prizeName     5 10 20 30 获得相应奖品
     *  @param needSignInDay 还需要签到几天
     *  @param prizeName     获得的奖励
     */
    _isSignIsBlock(nowDayIsSignIn, _startSign, needGetPrizeName, needSignDay, needPrizeName);
    
    
    //去请求接口
    if([signListArr arrBOOL] || [signPrizeDic dictBOOL] || [signHistoryDic dictBOOL] || [memberDayArr arrBOOL]) {
        if(_selectedDayBlock) {
            _selectedDayBlock(nowDate);
        }
    }
    
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(section == 0) return DATANAME_Array.count;
    return _sourceArray.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    static NSString * identifier = nil;
    if(section == 0) {
        identifier = @"week";
        RXCalendarWeekCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        cell.backgroundColor = GHS_7f1084_COLOR;
        [cell setWeekName:DATANAME_Array[row]];
        return cell;
    }
    else {
        identifier = @"day";
        RXCalendarDayCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        [cell setCalendarModel:_sourceArray[row]];
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        return CGSizeMake(_itemWidth, CEll_week_height);
    }
    return CGSizeMake(_itemWidth, CEll_day_height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if(section == 0) return;
    
    RXCalendarModel * model = _sourceArray[row];
    if(model.isEnable) {
        //交换cell选中状态
        if(_currentSelected != row) {
            model.isSelected = YES;
            RXCalendarModel * outModel = _sourceArray[_currentSelected];
            outModel.isSelected = NO;
            
            NSIndexPath * outIndexPath = [NSIndexPath indexPathForRow:_currentSelected inSection:1];
            [_calendarCollection reloadItemsAtIndexPaths:@[indexPath, outIndexPath]];
            _currentSelected = row;
            
            //去请求接口
            if(_selectedDayBlock) {
                _selectedDayBlock(model.date);
            }
        }
        
    }
    
}



@end
