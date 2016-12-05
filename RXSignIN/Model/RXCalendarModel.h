//
//  RXCalendarModel.h
//  RXSignIN
//
//  Created by srx on 2016/12/1.
//  Copyright © 2016年 https://github.com/srxboys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (RXNullReplace)

- (id)objectForKeyNotNull:(NSString *)key;

@end



@interface RXCalendarModel : NSObject
@property (nonatomic, copy) NSDate * date;//日期
@property (nonatomic, assign) NSInteger day;// 某天
@property (nonatomic, assign) BOOL isNowDay;//是否是今天(1:今天 选中; 0不是今天 不选中)
@property (nonatomic, assign) BOOL isEnable;//是否可以点击(是否是本月)
@property (nonatomic, assign) BOOL isSelected;//是否点击
@property (nonatomic, assign) BOOL isSignIn; //是否签到过
@property (nonatomic, assign) NSInteger score;//日历上边用到的
@property (nonatomic, copy) NSString * prizeName;//cell中//会员日、积分、礼金券
@end
