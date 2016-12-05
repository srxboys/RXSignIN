//
//  RXSignInViewController.h
//  RXSignIN
//
//  Created by srx on 2016/12/1.
//  Copyright © 2016年 https://github.com/srxboys. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef BOOL(^ FalseSignSuccBlock)();


@interface RXSignInViewController : UIViewController
@property (nonatomic, copy) NSDictionary * falseNetDataDic;

//为了，看效果，这个是给上个页面 边下数据模型
@property (nonatomic, copy)FalseSignSuccBlock falseSignSuccBlock;
@end
