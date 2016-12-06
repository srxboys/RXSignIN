//
//  RXSignPrizeView.m
//  RXSignIN
//
//  Created by srx on 2016/12/1.
//  Copyright © 2016年 https://github.com/srxboys. All rights reserved.
//

#import "RXSignPrizeView.h"
#import "RXSignPrizeDayView.h"
#import "RXSignPointImgView.h"

#import "UIImageView+fadeInFadeOut.h"

#import "RXCharacter.h"
#import "RXCalendarModel.h"

#define Prize_Array @[@(5),@(10),@(20),@(30)]
#define Prize_DicForKey @[@"five",@"ten",@"twenty",@"thirty"]

@interface RXSignPrizeView ()
{
    
}
@end

@implementation RXSignPrizeView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        CGFloat width = frame.size.width;
        
        CGFloat leftRight = roundf(width/4/3);//两边的空隙 间距
        
        CGFloat dayWidth = 45; //5 10 20 30的宽高
        CGFloat space = roundf((width - 2*leftRight - 4 * dayWidth)/3);//天与天的 空白区域(4个点全部宽)
        CGFloat dayTop = 12;
        
        CGFloat pointTop = 32;
        CGFloat pointWH = 2; //点 宽高
        CGFloat pointSpace = roundf((space - 4 * pointWH)/5);
        
        CGFloat dayLeft = leftRight;
        CGFloat pointLeft = 0;
        for (NSInteger i = 0; i < 4; i ++) {
            dayLeft += i != 0 ? (space + dayWidth) : 0;
            RXSignPrizeDayView * dayView = [[RXSignPrizeDayView alloc] initWithFrame:CGRectMake(dayLeft, dayTop, dayWidth, dayWidth)];
            dayView.tag = i + 1;//tag== 1 2 3 4
            dayView.numLabel = i == 0 ? 5 : i * 10;// 5 10 20 30
            [self addSubview:dayView];
            pointLeft = dayLeft + dayWidth + pointSpace;
            for (NSInteger j = 0; i < 3 && j < 4  ; j++) {
                pointLeft += j != 0 ?  (pointSpace + pointWH) : 0;
                RXSignPointImgView * pointImg = [[RXSignPointImgView alloc] initWithFrame:CGRectMake(pointLeft, pointTop, pointWH, pointWH)];
                pointImg.tag = j + 10 * (i + 1);
                /* tag == ?
                 10 11 12 13
                 20 21 22 23
                 30...
                 40...
                 */
                if(i == 0) {
                    pointImg.minPoint = 5 + 1 + j;
                    pointImg.maxPoint = 5 + 1 + j;
                    // 5 6 7 8 9 10
                }
                else {
                    pointImg.minPoint = j * 2 + 1 + 10 * i;
                    pointImg.maxPoint = j * 2 + 2 + 10 * i;
                    /*
                     0      1      2      3    4
                     11/12  13/14  15/16  17/18  19
                     21/22  23/24  25/26  27/28  29
                     */
                    //               TTLog(@"\n\nminP=%zd=maxP=%zd\n", pointImg.minPoint, pointImg.maxPoint);
                    
                }
                pointImg.isSelected = NO;
                [self addSubview:pointImg];
            }
            
            UIImageView * prizeImg = [[UIImageView alloc] initWithFrame:CGRectMake(dayLeft, dayTop + dayWidth + 11, PriceImgW, PriceImgH)];
            prizeImg.tag = i + 100;//tag== 100 101 102 103
            prizeImg.contentMode = UIViewContentModeScaleAspectFit;
            prizeImg.backgroundColor = [UIColor clearColor];
            [self addSubview:prizeImg];
            
            self.clipsToBounds = YES;
        }
        
    }
    return self;
}

- (void)setSignInWithSignPrizeDic:(NSDictionary *)signPrizeDic {
    if(![signPrizeDic dictBOOL]) return;
    
    for (NSInteger i = 0; i < 4; i ++) {
        NSDictionary * numDic = [signPrizeDic objectForKeyNotNull:Prize_DicForKey[i]];
        if(![numDic dictBOOL]) continue;
        
        NSString * imageStr = [numDic objectForKeyNotNull:@"image"];
        if(![imageStr urlBOOL]) continue;
        
        NSURL * url = [NSURL URLWithString:imageStr];
        
        RXSignPrizeDayView * dayView = [self viewWithTag:i + 1];
        UIImageView * prizeImg = [self viewWithTag:i + 100];
//        [prizeImg sd_setImageFIFOWithURL:url placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//            //如果图片 是可以配置的，这里设置。不过我这是写死的
//            prizeImg.center = CGPointMake(dayView.center.x, prizeImg.center.y);
//        }];
        [prizeImg sd_setImageWithURL:url placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates  completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            //如果图片 是可以配置的，这里设置。不过我这是写死的
            prizeImg.center = CGPointMake(dayView.center.x, prizeImg.center.y);
        }];
    }
    
}

- (void)setSignInWithDay:(NSInteger)signDay {
    for(NSInteger i = 0; i < 4; i ++) {
        for(NSInteger j = 0; j < 4 && i < 3; j ++) {
            RXSignPointImgView * pointImg = [self viewWithTag:j + 10 * (i + 1)];
            pointImg.isSelected = NO;
        }
        // 签到 5 10 20 天
        RXSignPrizeDayView * dayView = [self viewWithTag:i + 1];
        dayView.isSelected = NO;
    }
    
    if(signDay < 5) {
        return;
    };
    
    NSInteger row = 0;
    for (NSString * dayStr in Prize_Array) {
        NSInteger prizeDays = [dayStr integerValue];
        if(signDay < prizeDays) {
            break;
        }
        RXSignPrizeDayView * dayView = [self viewWithTag:row + 1];
        dayView.isSelected = YES;
        row ++;
        
    }
    
    for(NSInteger i = 0; i < row; i ++) {
        for(NSInteger j = 0; j < 4 && i < 3; j ++) {
            RXSignPointImgView * pointImg = [self viewWithTag:j + 10 * (i + 1)];
            if(pointImg.minPoint<= signDay || pointImg.maxPoint <= signDay) {
                pointImg.isSelected = YES;
            }
        }
        
    }
}




@end
