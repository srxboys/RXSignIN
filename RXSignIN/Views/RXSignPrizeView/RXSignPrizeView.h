//
//  RXSignPrizeView.h
//  RXSignIN
//
//  Created by srx on 2016/12/1.
//  Copyright © 2016年 https://github.com/srxboys. All rights reserved.
//

#import <UIKit/UIKit.h>
#define PriceImgW  ActureHeightV(40)
#define PriceImgH  ActureHeight(65)

#define SIGN_PrizeHeight PriceImgW + 84

@interface RXSignPrizeView : UIView
- (void)setSignInWithDay:(NSInteger)signDay;
- (void)setSignInWithSignPrizeDic:(NSDictionary *)signPrizeDic;
@end
