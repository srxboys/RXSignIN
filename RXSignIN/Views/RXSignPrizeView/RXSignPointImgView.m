//
//  RXSignPointImgView.m
//  RXSignIN
//
//  Created by srx on 2016/12/1.
//  Copyright © 2016年 https://github.com/srxboys. All rights reserved.
//

#import "RXSignPointImgView.h"

@implementation RXSignPointImgView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorRGB(216, 216, 216);
        self.layer.cornerRadius = CGRectGetWidth(frame)/2.0;
        self.clipsToBounds = YES;
        self.isSelected = NO;
    }
    return self;
}


- (void)setIsSelected:(BOOL)isSelected {
    if(_isSelected != isSelected) {
        _isSelected = isSelected;
        self.backgroundColor = isSelected ? UIColorRGB(233, 110, 243) : UIColorRGB(216, 216, 216);
    }
}

@end
