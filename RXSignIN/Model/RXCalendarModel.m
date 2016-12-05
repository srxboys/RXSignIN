//
//  RXCalendarModel.m
//  RXSignIN
//
//  Created by srx on 2016/12/1.
//  Copyright © 2016年 https://github.com/srxboys. All rights reserved.
//

#import "RXCalendarModel.h"

@implementation NSDictionary (RXNullReplace)

- (id)objectForKeyNotNull:(NSString *)key
{
    id object = [self objectForKey:key];
    if (([object isKindOfClass:[NSString class]] && (![object isEqualToString:@"<null>"])) ||
        [object isKindOfClass:[NSArray class]] ||
        [object isKindOfClass:[NSDictionary class]])  {
        
        return object;
    }
    else if([object isKindOfClass:[NSNumber class]]) {
        NSNumberFormatter * numberFormatter = [[NSNumberFormatter alloc] init];
        return [numberFormatter stringFromNumber:object];
    }
    return nil;
}
@end


@implementation RXCalendarModel

@end
