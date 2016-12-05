//
//  RXCalendarView.h
//  RXSignIN
//
//  Created by srx on 2016/12/1.
//  Copyright © 2016年 https://github.com/srxboys. All rights reserved.
//

#import <UIKit/UIKit.h>
#define CEll_week_height 30
#define CEll_day_height 59

#define CalendarView_Height CEll_week_height + 6 * CEll_day_height

typedef void(^CalendarSelectedDay)(NSDate * date);

/**
 *  @param isSignIn      今天 是否 签到了
 *  @param signInDay     签到第几天
 *  @param prizeName     5 10 20 30 获得相应奖品
 *  @param needSignInDay 还需要签到几天
 *  @param prizeName     获得的奖励
 */
typedef void(^BackIsSignIsBlock)(BOOL isSignIn, NSInteger signInDay, NSString * prizeName, NSInteger needSignInDay, NSString * needPrizeName);
@interface RXCalendarView : UIView
//----------------------- getting -----------------------
/// 获取 点击某个cell
@property (nonatomic, copy) CalendarSelectedDay selectedDayBlock;
@property (nonatomic, copy) BackIsSignIsBlock isSignIsBlock;

//----------------------- setting -----------------------
//赋值
- (void)signInCalendarSorceDataWithSignList:(NSArray *)signListArr signPrize:(NSDictionary *)signPrizeDic signHistory:(NSDictionary *)signHistoryDic memberDay:(NSArray *)memberDayArr;


@end
