//
//  ViewController.m
//  RXSignIN
//
//  Created by srx on 2016/12/1.
//  Copyright © 2016年 https://github.com/srxboys. All rights reserved.
//

#import "ViewController.h"
#import "RXRandom.h"
#import "NSDateUtilities.h"

#import "RXSignInViewController.h"
#define GetImage(_num) [NSString stringWithFormat:@"https://github.com/srxboys/RXSignIN/blob/master/srxboys/%zd.png", _num]

@interface ViewController ()
{
    RXSignInViewController * _signINController;
}
@property (nonatomic, assign) NSInteger currentSignDay;
@property (weak, nonatomic) IBOutlet UISwitch *istodaySignSwitch;
@property (weak, nonatomic) IBOutlet UITextField *signDayTextField;
- (IBAction)goToSignInButtonClick:(id)sender;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
   
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _signINController = nil;
    
    __weak typeof(self)weakSelf =self;
    _signINController = [[RXSignInViewController alloc] init];
    _signINController.falseSignSuccBlock = ^(){
        [weakSelf configUITodayIsSign:YES signDay:weakSelf.currentSignDay];
        return YES;
    };
}

- (void)configUITodayIsSign:(BOOL)isTodaySign signDay:(NSInteger)signDay{
    
    NSDate * nowDate = [NSDate date];
    
    //今天是否签到了
    NSInteger toDay_isSign = isTodaySign ? 1 : 0;
    
    //已经连续签到4天
    
    //最近连续签到日
    NSMutableArray * sign_listArr = [[NSMutableArray alloc] init];
//------11111111---------------
//    for(NSInteger i = 0; i < arc4random()% 10 + 1; i++) {
//        //赋随机值
//        [sign_listArr addObject:[RXRandom randomDateString]];
//    }
//    
//    [sign_listArr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//        //倒序排序
//        return [obj1 longLongValue] < [obj2 longLongValue];
//    }];
//-------222222222222--------------
    NSInteger startSign = isTodaySign? 0 : 1;
    for(NSInteger i = startSign; i <= signDay; i ++) {
        long long time = [[nowDate daysAgo:i] timeIntervalSince1970];
        NSString * timeStr = [NSString stringWithFormat:@"%lld", time];
        [sign_listArr addObject:timeStr];
    }
    //签到今天有什么奖励
    NSDictionary * sign_prizeDic = @{@"five": @{@"type":@"0", @"amount":@"50", @"describe" : @"50人民币", @"image" :GetImage(50)},
                                     @"ten" : @{@"type":@"0", @"amount":@"5", @"describe" : @"5元吃的", @"image" :GetImage(5)},
                                     @"twenty" : @{@"type":@"0", @"amount":@"10", @"describe" : @"10元玩具", @"image" :GetImage(10)},
                                     @"thirty" : @{@"type":@"0", @"amount":@"20", @"describe" : @"20元美女", @"image" :GetImage(20)}};
    
    //最近签到并且不间断的起始日期 几天
    if(isTodaySign) {
        signDay ++;
    }
    NSString * sign_start_Str = [NSString stringWithFormat:@"%.0f", [[nowDate daysAgo:signDay] timeIntervalSince1970]];
    NSDictionary * sign_historyDic = @{@"sign_start": sign_start_Str,@"sign_duration" :@(signDay), @"sign_describe" : @"再连续签到xx天即可获得50人民币"};
    
    //某天是特殊日子 或者 活动
    NSMutableArray * member_dayArr = [[NSMutableArray alloc] init];
    //这个如果是接口，这一天的活动 是不会变。这个假数据，每次调用都会不一样
    for (NSInteger i = 0; i < arc4random() % 10; i ++) {
        NSDate * memberDayDate = [[NSDate date] daysLater:arc4random() % 30];
        NSString * memberDayStr = [NSString stringWithFormat:@"%.0f", [memberDayDate timeIntervalSince1970]];
        NSDictionary * member_dayDicTemp = @{@"date": memberDayStr, @"message" : [RXRandom randomChinasWithinCount:3]};
        [member_dayArr addObject:member_dayDicTemp];
    }
    
   

    NSMutableDictionary  * returnDic = [[NSMutableDictionary alloc] init];
    [returnDic setObject:@(toDay_isSign) forKey:@"is_sign"];
    [returnDic setObject:sign_listArr forKey:@"sign_list"];
    [returnDic setObject:sign_prizeDic forKey:@"sign_prize"];
    [returnDic setObject:sign_historyDic forKey:@"sign_history"];
    [returnDic setObject:member_dayArr forKey:@"member_day"];
    _signINController.falseNetDataDic = returnDic;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)goToSignInButtonClick:(id)sender {
    self.currentSignDay = [[_signDayTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] integerValue];
    
    [self configUITodayIsSign:_istodaySignSwitch.isOn signDay:self.currentSignDay];
    [self.navigationController pushViewController:_signINController animated:YES];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_signDayTextField resignFirstResponder];
}

@end
