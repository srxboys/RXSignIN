//
//  RXCalendarDayCell.m
//  RXSignIN
//
//  Created by srx on 2016/12/1.
//  Copyright © 2016年 https://github.com/srxboys. All rights reserved.
//

#import "RXCalendarDayCell.h"

#import "RXCalendarModel.h"

@interface RXCalendarDayCell ()
{
    UILabel * _label;
    UIImageView * _bgImg;
    UIView * _pointView;
    
    UILabel * _descLabel;
}
@end


@implementation RXCalendarDayCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = frame.size.width;
        CGFloat heigth = frame.size.height;
        CGFloat bgH = 28;
        CGFloat top = 5;
        _bgImg = [[UIImageView alloc] initWithFrame:CGRectMake((width - bgH)/2.0, top, bgH, bgH)];
        _bgImg.backgroundColor = [UIColor clearColor];
        _bgImg.layer.cornerRadius = bgH/2.0;
        _bgImg.clipsToBounds = YES;
        [self.contentView addSubview:_bgImg];
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, top, width, bgH)];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:18];
        _label.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_label];
        top += 29;
        _pointView = [[UIView alloc] initWithFrame:CGRectMake((width - 6)/2.0, top, 6, 6)];
        _pointView.backgroundColor = UIColorRGB(216, 216, 216);
        _pointView.layer.cornerRadius = 3;
        _pointView.clipsToBounds = YES;
        _pointView.hidden = YES;
        [self.contentView addSubview:_pointView];
        top += 6 + 3;
        CGFloat descLableH = 13;// 原来写的 height - top== 不准确
        _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, top, width, descLableH)];
        _descLabel.text = @"";
        _descLabel.textAlignment = NSTextAlignmentCenter;
        _descLabel.font = [UIFont systemFontOfSize:12];
        _descLabel.textColor = UIColorRGB(165, 51, 104);
        _descLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_descLabel];
        
        self.contentView.clipsToBounds = YES;
    }
    return self;
}

- (void)setDayName:(NSString *)dayName {
    _label.text = dayName;
}

- (void)setCalendarModel:(RXCalendarModel *)model {
    _label.text = [NSString stringWithFormat:@"%zd", model.day];
    _descLabel.text = model.prizeName;
    if(model.isEnable) {
        _label.textColor = GHS_333_COLOR;
    }
    else {
        _label.textColor = GHS_CCCCCC_COLOR;
    }
    
    if(model.isSelected) {
        _bgImg.backgroundColor = GHS_7f1084_COLOR;
        _label.textColor = [UIColor whiteColor];
    }
    else {
        _bgImg.backgroundColor = [UIColor clearColor];
    }
    
    if(model.isSignIn) {
        _pointView.hidden = NO;
    }
    else {
        _pointView.hidden = YES;
    }
    
}

@end
