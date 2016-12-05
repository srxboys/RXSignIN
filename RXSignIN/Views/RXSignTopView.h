//
//  RXSignTopView.h
//  RXSignIN
//
//  Created by srx on 2016/12/1.
//  Copyright © 2016年 https://github.com/srxboys. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RXSignTopView_height 180
typedef void(^AnimalComplete)();

@interface RXSignTopView : UIView

//----------------------- get button click --------------
/// 签到点击
- (void)addTarget:(id)target action:(SEL)action;
@property (nonatomic, copy) AnimalComplete animalComplete;

//第一次进去页面，已签过到
- (void)starAnimation;

/*****************
 今天签到成功
 内部以及实现 - (void)starAnimation;
 */
- (void)signButtonClickSucess;

//----------------------- setting -----------------------
@property (nonatomic, assign) BOOL is_sign;//请求接口告诉我是否签到过了
/**
 *  @param isSignIned    是否签到
 *  @param signInDay     签到了 第几天
 *  @param needSignInDay 还需要签到几天 获得什么奖品
 *  @param prizeName     获得什么奖品
 */
- (void)signIned:(BOOL)isSignIned signInDay:(NSInteger)signInDay prizeName:(NSString*)prizeName needSignInDay:(NSInteger)needSignInDay needPrizeName:(NSString*)needPrizeName;

@end
