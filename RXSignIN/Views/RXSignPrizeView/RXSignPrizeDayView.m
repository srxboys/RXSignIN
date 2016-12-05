//
//  RXSignPrizeDayView.m
//  RXSignIN
//
//  Created by srx on 2016/12/1.
//  Copyright © 2016年 https://github.com/srxboys. All rights reserved.
//

#import "RXSignPrizeDayView.h"

@interface RXSignPrizeDayView ()
{
    UILabel * _dayLabel;
    UIImageView * _checkImgView;
    UIImageView  * _awardImgView;
}
@end

@implementation RXSignPrizeDayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = CGRectGetWidth(frame)/2.0;
        self.layer.borderWidth = 0.5f;
        self.layer.borderColor = GHS_CCCCCC_COLOR.CGColor;
        self.clipsToBounds = YES;
        
        CGFloat viewHW = CGRectGetWidth(frame);
        
        _dayLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _dayLabel.font = [UIFont systemFontOfSize:14];
        _dayLabel.textColor = GHS_666_COLOR;
        _dayLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_dayLabel];
        
        CGFloat top = viewHW - 5 - 11;
        CGFloat left = (viewHW - 11)/2;
        _checkImgView = [[UIImageView alloc] initWithFrame:CGRectMake(left, top, 11, 14)];
        _checkImgView.image = [UIImage imageNamed:@"signIn_alreadySignIn"];
        _checkImgView.backgroundColor = [UIColor clearColor];
        [self addSubview:_checkImgView];
        _checkImgView.hidden = YES;
        _isSelected = NO;
        
    }
    return self;
}

- (void)setNumLabel:(NSInteger)numLabel {
    _numLabel = numLabel;
    _dayLabel.text = [NSString stringWithFormat:@"%zd天", numLabel];
}

- (void)setIsSelected:(BOOL)isSelected {
    if(_isSelected == isSelected) return;
    if(isSelected) {
        _checkImgView.hidden = NO;
        self.backgroundColor = UIColorRGB(233, 110, 243);
        self.layer.borderColor = UIColorRGB(233, 110, 243).CGColor;
        _dayLabel.textColor = [UIColor whiteColor];
    }
    else {
        _checkImgView.hidden = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = GHS_CCCCCC_COLOR.CGColor;
        _dayLabel.textColor = GHS_666_COLOR;
    }
    _isSelected = isSelected;
    
}

@end
