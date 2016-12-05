//
//  RXSignFootDayActivityView.m
//  RXSignIN
//
//  Created by srx on 2016/12/1.
//  Copyright © 2016年 https://github.com/srxboys. All rights reserved.
//

#import "RXSignFootDayActivityView.h"
#import "RXCalendarModel.h"
#import "RXCharacter.h"

#define left 20
#define leftRight left * 2

#define titleLeft 49


@interface RXSignFootDayActivityView ()
{
    UIImageView * _imgView1;
    UILabel * _title1;
    UILabel * _descLabel1;
    UIView * _lineView;
    UIImageView * _imgView2;
    UILabel * _title2;
    UILabel * _descLabel2;
    
    CGFloat _width;
    
}
@end
@implementation RXSignFootDayActivityView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame), 0)];
    if (self) {
        
        _width = frame.size.width;
        
        _imgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 14, 12)];
        _imgView1.image = [UIImage imageNamed:@"signIn_memberDay"];
        [self addSubview:_imgView1];
        
        _title1 = [[UILabel alloc] init];
        _title1.textColor = GHS_7f1084_COLOR;
        _title1.font = [UIFont systemFontOfSize:14];
        [self addSubview:_title1];
        
        _descLabel1 = [[UILabel alloc] init];
        _descLabel1.textColor = GHS_333_COLOR;
        _descLabel1.font = [UIFont systemFontOfSize:12];
        _descLabel1.numberOfLines = 0;
        [self addSubview:_descLabel1];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, _width - 20, 1)];
        _lineView.backgroundColor = UIColorRGB(236, 236, 236);
        [self addSubview:_lineView];
        
        _imgView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 14, 13)];
        _imgView2.image = [UIImage imageNamed:@"signIn_continuousSignIn"];
        [self addSubview:_imgView2];
        
        _title2 = [[UILabel alloc] init];
        _title2.textColor = GHS_7f1084_COLOR;
        _title2.font = [UIFont systemFontOfSize:14];
        [self addSubview:_title2];
        
        _descLabel2 = [[UILabel alloc] init];
        _descLabel2.textColor = GHS_333_COLOR;
        _descLabel2.font = [UIFont systemFontOfSize:12];
        _descLabel2.numberOfLines = 0;
        [self addSubview:_descLabel2];
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setSubViewsFrame {
    self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), 0);
    
    _imgView1.hidden = YES;
    _imgView2.hidden = YES;
    _lineView.hidden = YES;
    _title1.hidden = YES;
    _title2.hidden = YES;
    _descLabel1.hidden = YES;
    _descLabel2.hidden = YES;
    
    _title1.frame = CGRectMake(titleLeft, 0, CGRectGetWidth(self.frame) - titleLeft, 10);
    _title2.frame = CGRectMake(titleLeft, 0, CGRectGetWidth(self.frame) - titleLeft, 10);
    _descLabel1.frame = CGRectMake(left, 0, CGRectGetWidth(self.frame) - leftRight, 10);
    _descLabel2.frame = CGRectMake(left, 0, CGRectGetWidth(self.frame) - leftRight, 10);
    
    
}

- (CGFloat)setFootViewWithDict:(NSDictionary *)dictionary {
    [self setSubViewsFrame];
    if(![dictionary dictBOOL]) return 0;
    
    NSDictionary * memberDayDic = [dictionary objectForKeyNotNull:@"member_day"];
    
    NSDictionary * signMessageDic = [dictionary objectForKeyNotNull:@"sign_message"];
    
    if(![memberDayDic dictBOOL] && ![signMessageDic dictBOOL]) return 0;
    
    CGFloat top = 10;
    if([memberDayDic dictBOOL]) {
        NSString * data = [memberDayDic objectForKeyNotNull:@"data"];
        NSString * message = [memberDayDic objectForKeyNotNull:@"message"];
        
        _imgView1.frame = CGRectMake(left, top, 14, 12);
        _imgView1.hidden = NO;
        _title1.frame = CGRectMake(titleLeft, 0, CGRectGetWidth(self.frame) - titleLeft, 32);
        _title1.hidden = NO;
        _title1.text = data;
        
        _descLabel1.hidden = NO;
        _descLabel1.text = message;
        [_descLabel1 sizeToFit];
        CGFloat height = _descLabel1.frame.size.height;
        top = 32;
        _descLabel1.frame = CGRectMake(left, top, CGRectGetWidth(self.frame) - leftRight, height);
        top += height + 10;
        
        if([signMessageDic dictBOOL]) {
            _lineView.frame = CGRectMake(10, top, CGRectGetWidth(self.frame) - 20, 0.5);
            _lineView.hidden = NO;
            top += 10.5;
        }
        
    }
    
    if([signMessageDic dictBOOL]) {
        NSString * prize = [signMessageDic objectForKeyNotNull:@"prize"];
        NSString * message = [signMessageDic objectForKeyNotNull:@"message"];
        
        _imgView2.frame = CGRectMake(left, top, 14, 13);
        _imgView2.hidden = NO;
        
        _title2.frame = CGRectMake(titleLeft, top, CGRectGetWidth(self.frame) - titleLeft, 14);
        _title2.text = [NSString stringWithFormat:@"连续签到奖励: %@", prize];
        _title2.hidden = NO;
        
        top += 10 + 14;
        _descLabel2.hidden = NO;
        _descLabel2.text = message;
        [_descLabel2 sizeToFit];
        CGFloat height = _descLabel2.frame.size.height;
        _descLabel2.frame = CGRectMake(left, top, CGRectGetWidth(self.frame) - leftRight, height);
        top+= height + 10;
    }
    
    
    self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), top);
    
    return top;
}

@end
