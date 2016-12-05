//
//  RXCalendarWeekCell.m
//  RXSignIN
//
//  Created by srx on 2016/12/1.
//  Copyright © 2016年 https://github.com/srxboys. All rights reserved.
//

#import "RXCalendarWeekCell.h"

@interface RXCalendarWeekCell ()
{
    UILabel * _label;
    UIView  * _nowDayView;
    UIView  * _pointView;
    UILabel * _holidayLabel;
}
@end


@implementation RXCalendarWeekCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;
        
        _nowDayView = [[UIView alloc] initWithFrame:CGRectMake((width - 28)/2, 0, 28, 28)];
        _nowDayView.layer.cornerRadius = 14;
        _nowDayView.layer.borderWidth = 0;
        _nowDayView.clipsToBounds = YES;
        [self.contentView addSubview:_nowDayView];
        
        _label = [[UILabel alloc] initWithFrame:_nowDayView.bounds];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont systemFontOfSize:16];
        [_nowDayView addSubview:_label];
        
        CGFloat top = 1 + 28;
        CGFloat pointWH = 6;
        _pointView = [[UIView alloc] initWithFrame:CGRectMake((width - pointWH)/2, top, pointWH, pointWH)];
        _pointView.layer.cornerRadius = pointWH/2.0;
        _pointView.layer.borderWidth = 0;
        _pointView.backgroundColor = UIColorRGB(216, 216, 216);
        _pointView.clipsToBounds = YES;
        _pointView.hidden = YES;
        [self.contentView addSubview:_pointView];
        
        top += pointWH + 1;
        CGFloat holidayLabelHeight = height - top;
        _holidayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, top, width, holidayLabelHeight)];
        _holidayLabel.backgroundColor = [UIColor clearColor];
        _holidayLabel.textColor = GHS_7f1084_COLOR;
        _holidayLabel.font = [UIFont systemFontOfSize:12];
        _holidayLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_holidayLabel];
        
    }
    return self;
}

- (void)setWeekName:(NSString *)weekName {
    _label.text = weekName;
}
@end
