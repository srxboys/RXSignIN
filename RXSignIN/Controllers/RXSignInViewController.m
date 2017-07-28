//
//  RXSignInViewController.m
//  RXSignIN
//
//  Created by srx on 2016/12/1.
//  Copyright © 2016年 https://github.com/srxboys. All rights reserved.
//

#import "RXSignInViewController.h"
#import "RXRandom.h"
#import "RXCharacter.h"
#import "NSDateUtilities.h"
#import "RXCalendarModel.h"

#import "RXSignTopView.h"
#import "RXSignPrizeView.h"
#import "RXCalendarView.h"
#import "RXSignFootDayActivityView.h"

//签到这些天，去评论APP
#define Prize_Array @[@(5),@(10),@(20),@(30)]
#define APPOpenURL(_url) [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_url]]
#define GOTOAPPSTORECOMMEURL @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&id=appID?" //appID ?

@interface RXSignInViewController ()<UIScrollViewDelegate>
{
    UIScrollView     * _scrollView;
    CGFloat            _scrollViewContenSizeHeight;
    
    CGFloat            _tableContentTop;
    
    RXSignTopView   * _topView; //未签到、已签到
    BOOL              _nowDayIsSignIn;//_topView 是否签到
    RXSignPrizeView * _prizeView;//奖品
    UILabel          * _nowDateLabel;
    NSInteger          _Agent_signDay;
    
    RXCalendarView  * _calendarView; //日历
    
    UIView           * _lineView_middle;
    
    RXSignFootDayActivityView * _footView;
    
    NSString  * _sign_rule_url;//签到规则页面
}

@end

@implementation RXSignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if(![self.title strBOOL]) {
        self.title = @"签到";
    }
    
    [self configUI];
}

- (void)configUI {
    
    _Agent_signDay = 0;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavHeight, ScreenWidth, ScreenHeight - NavHeight)];
    _scrollView.delegate = self;
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollView];
    
    __weak typeof(self)weakSelf = self;
    __weak UIScrollView * bScrollView =  _scrollView;
    CGFloat top = 0;
    _topView = [[RXSignTopView alloc] initWithFrame:CGRectMake(0, top, ScreenWidth, RXSignTopView_height)];
    _topView.backgroundColor = [UIColor whiteColor];
    [_topView addTarget:self action:@selector(setGignIn)];
    _topView.animalComplete = ^() {
        bScrollView.userInteractionEnabled = YES;
        [weakSelf isEnableGotoAppStoreForComments];
    };
    [_scrollView addSubview:_topView];
    
    top += RXSignTopView_height;
    _prizeView = [[RXSignPrizeView alloc] initWithFrame:CGRectMake(0, top, ScreenWidth, 149)];
    _prizeView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_prizeView];
    
    top += 149;
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, top, ScreenWidth,10)];
    view.backgroundColor = GHS_227_227_227_COLOR;
    [_scrollView addSubview:view];
    
    NSDate * nowDate = [NSDate date];
    NSString * nowDateStr = [NSString stringWithFormat:@"今天 %zd-%02zd-%02zd", nowDate.year, nowDate.month, nowDate.day];
    
    top += 10;
    _nowDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, top, ScreenWidth, 34)];
    _nowDateLabel.backgroundColor = [UIColor whiteColor];
    _nowDateLabel.textColor = GHS_666_COLOR;
    _nowDateLabel.font = [UIFont systemFontOfSize:14];
    _nowDateLabel.textAlignment = NSTextAlignmentCenter;
    _nowDateLabel.text = nowDateStr;
    [_scrollView addSubview:_nowDateLabel];
    
    
    top += 36;
    _calendarView = [[RXCalendarView alloc] initWithFrame:CGRectMake(0, top, ScreenWidth, CalendarView_Height)];
    _calendarView.selectedDayBlock = ^(NSDate * date) {
        //点击 日历某个cell
        [weakSelf getNetworkInfoWithDay:date];
    };
    
    __weak RXSignTopView * tempTopView = _topView;
    __weak RXSignPrizeView * tempSignPrizeView = _prizeView;
    _calendarView.isSignIsBlock = ^(BOOL isSignIn, NSInteger signInDay, NSString * prizeName, NSInteger needSignInDay, NSString * needPrizeName) {
        //setSignInWithDay
        //点击 日历返回是否签到
        [tempTopView signIned:isSignIn signInDay:signInDay prizeName:prizeName needSignInDay:needSignInDay needPrizeName:needPrizeName];
        
        //签到了 几天
        [tempSignPrizeView setSignInWithDay:signInDay];
        
    };
    [_scrollView addSubview:_calendarView];
    
    //日历只是界面有数据而已
    [_calendarView signInCalendarSorceDataWithSignList:nil signPrize:nil signHistory:nil memberDay:nil];
    
    top += CalendarView_Height + 10;
    UIView * longLineView = [[UIView alloc] initWithFrame:CGRectMake(0, top, ScreenWidth, 0.5)];
    longLineView.backgroundColor = UIColorRGB(236, 236, 236);
    [_scrollView addSubview:longLineView];
    
    top += 0.5;
    _scrollViewContenSizeHeight = top;
    _scrollView.contentSize = CGSizeMake(ScreenWidth, _scrollViewContenSizeHeight + 10);
    
    _lineView_middle = [[UIView alloc] initWithFrame:CGRectMake(10, top, ScreenWidth - 20, 1)];
    _lineView_middle.backgroundColor = UIColorRGB(236, 236, 236);
    _lineView_middle.hidden = YES;
    [_scrollView addSubview:_lineView_middle];
    
    _footView = [[RXSignFootDayActivityView alloc] initWithFrame:CGRectMake(0, top, ScreenWidth, 0)];
    [_scrollView addSubview:_footView];
    
    [self getNetworkDataWithIsShowHud:YES];
    
}


/// 获取数据
- (void)getNetworkDataWithIsShowHud:(BOOL)isShowHud {
   
//    [RXHttp postReqeustWithParams:@{@"method" : SignInListMethod} successBlock:^(Response *responseObject) {
//
//        if(!responseObject.status) {
//            [weakSelf showToast:responseObject.message];
//            [weakSelf showNullNetworkView];
//            return ;
//        }
//
//        if(![responseObject.returndata arrBOOL]) {
//            [weakSelf showNullNetworkView];
//            return;
//        }
//
//        [weakSelf hiddenNullNetworkView];
//        NSLog(@"\n\n%@\n\n", _falseNetDataDic);

        NSDictionary * dictionary = _falseNetDataDic;
        _nowDayIsSignIn = [[dictionary objectForKeyNotNull:@"is_sign"] boolValue];
        if(_nowDayIsSignIn) {
            _topView.is_sign = YES;
            //            [_topView starAnimation];
        }

        NSArray * sign_list_arr = dictionary[@"sign_list"];

        //某天 是礼金券、积分 或者 会员日等等
        NSDictionary * sign_prize_dic = dictionary[@"sign_prize"];
        //从那天开始签到的，签到了几天
        NSDictionary * sign_history_dic = dictionary[@"sign_history"];
        if([sign_history_dic dictBOOL]) {
            _Agent_signDay = [[sign_history_dic objectForKeyNotNull:@"sign_duration"] integerValue];
            if(_nowDayIsSignIn) {
                _Agent_signDay --;
            }
        }
    
        NSArray * member_day_arr = dictionary[@"member_day"];

        //签到 奖品
        [_prizeView setSignInWithSignPrizeDic:sign_prize_dic];
        if([sign_history_dic dictBOOL]) {
            [_prizeView setSignInWithDay:[[sign_history_dic objectForKeyNotNull:@"sign_duration"] integerValue]];
        }

        //日历
        [_calendarView signInCalendarSorceDataWithSignList:sign_list_arr signPrize:sign_prize_dic signHistory:sign_history_dic memberDay:member_day_arr];



//    } failureBlock:^(NSError *error) {
//        //        RXLog(@"%@", error.description);
//        [weakSelf showNullNetworkView];
//        [self showToast:messageNetNull];
//    } showHUD:isShowHud loadingInView:self.view controllerName:SELF_CLASS_NAME];
}

/// 签到
- (void)setGignIn {

//    RXUser * user  = [GlobalData sharedInstance].user;
//
//    if(user.member_id == 0) {
//        weak(weakSelf);
//        [_loginView showInController:self comple:^(BOOL status) {
//            if (status) {
//                [weakSelf goToGinInToday];
//            }
//        }];
//    }
//    else {
        [self goToGinInToday];
//    }
}

- (void)goToGinInToday {

    _scrollView.userInteractionEnabled = NO;
    
    //下面只是展示动画
     [_topView signButtonClickSucess];
    
    //为了看效果，写了假的网络回传状态
    __weak typeof(self)weakSelf = self;
    if(_falseSignSuccBlock()) {
        _Agent_signDay = 1000;
        [weakSelf getNetworkDataWithIsShowHud:NO];
    }
    //网络请求部分删除了
}

- (void) isEnableGotoAppStoreForComments {
    if(_nowDayIsSignIn) _Agent_signDay ++;
    if([Prize_Array containsObject:@(_Agent_signDay)]) {
        
        APPOpenURL(GOTOAPPSTORECOMMEURL);
    }
}

// 某天是否有活动信息
- (void)getNetworkInfoWithDay:(NSDate *)date {

//    NSTimeInterval  interval = [date timeIntervalSince1970];
    //网络请求部分删除了
    
    
    NSMutableDictionary * returnDict = [[NSMutableDictionary alloc] init];
    
    BOOL isEnable = arc4random() % 2;
    //随机奖励说明 并且每次都不同--假的哦
    if(isEnable) {
        NSDictionary * member_day = @{@"data": [RXRandom randomChinasWithinCount:10], @"message": [RXRandom randomChinasWithinCount:30]};
        NSString * prizeStr = [NSString stringWithFormat:@"%zd亿人民币", arc4random() % 1000];
        NSString * prizeMessage = [NSString stringWithFormat:@"从xx年xx月xx日连续签到至xx月xx日即可获得%@",prizeStr];
        NSDictionary * sign_message = @{@"prize":prizeStr, @"message":prizeMessage};
        
        [returnDict setObject:member_day forKey:@"member_day"];
        [returnDict setObject:sign_message forKey:@"sign_message"];
    }
    [self setFootViewSourceWith:returnDict];
}

- (void)setFootViewSourceWith:(NSDictionary *)dict {
    CGFloat height = [_footView setFootViewWithDict:dict];
    //    RXLog(@"footView height =%f", height);
    if(height > 0) {
        _scrollView.contentSize = CGSizeMake(ScreenWidth, _scrollViewContenSizeHeight + 10 + height);
    }
    else {
        _scrollView.contentSize = CGSizeMake(ScreenWidth, _scrollViewContenSizeHeight + 10);
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    //    RXLog(@"offsety===%f---_tableContentTop=%f", offsetY, _tableContentTop);
    if(offsetY < 0) {
        _topView.frame = CGRectMake(offsetY, offsetY, ScreenWidth - (2 * offsetY), RXSignTopView_height - offsetY);
    }
    else {
        _topView.frame = CGRectMake(0, 0, ScreenWidth, RXSignTopView_height);
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
