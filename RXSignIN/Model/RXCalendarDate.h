//
//  RXCalendarDate.h
//  RXSignIN
//
//  Created by srx on 2016/12/1.
//  Copyright © 2016年 https://github.com/srxboys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RXCalendarDate : NSObject
+ (NSInteger)day:(NSDate *)date;
+ (NSInteger)month:(NSDate *)date;
+ (NSInteger)year:(NSDate *)date;
//今天在这个月[周日六五, ~]  的第几个 [1, ~无穷大]
+ (NSInteger)firstWeekdayInThisMonth:(NSDate *)date;
//这个月有多少天
+ (NSInteger)totaldaysInThisMonth:(NSDate *)date;
+ (NSDate *)lastMonth:(NSDate *)date;
+ (NSDate*)nextMonth:(NSDate *)date;
@end
