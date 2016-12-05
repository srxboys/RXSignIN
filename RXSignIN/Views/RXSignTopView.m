//
//  RXSignTopView.m
//  RXSignIN
//
//  Created by srx on 2016/12/1.
//  Copyright © 2016年 https://github.com/srxboys. All rights reserved.
//

#import "RXSignTopView.h"
#import "RXCharacter.h"

#import <objc/message.h>
#define RXMsgSend(...) ((void (*)(void *, SEL, RXSignTopView *))objc_msgSend)(__VA_ARGS__)
#define RXMsgTarget(target) (__bridge void *)(target)

@interface RXSignTopView ()<UICollisionBehaviorDelegate>
{
    //    UIDynamicAnimator *_animator;
    //    UIGravityBehavior *_gravityBehav;
    //    UICollisionBehavior *_colision;
    //    BOOL _collisionEndBool;
    
    UIImageView * _bgImgView;
    UIView      * _isSignSuccView;
    UIImageView * _isSignSuccImgView;
    UIImageView * _maxSignImgView;
    UIButton    * _signButton;
    UILabel     * _label1;
    UILabel     * _label2;
    //
    BOOL          _showAnimalIng; //是否正在展示动画
    
    UIImageView * _start_img_left_0;
    UIImageView * _start_img_ritht_top_0;
    UIImageView * _start_img_ritht_bottom_0;
    
    UIImageView * _circle_img_left_1;
    UIImageView * _circle_img_right_1;
    
    UIImageView * _cross_img_mid_2;
    UIImageView * _cross_img_left_2;
    UIImageView * _cross_img_right_2;
    UIImageView * _cross_img_bottom_2;
    
    CGFloat _tickL;
    CGFloat _tickT;
    CGFloat _tickW;
    CGFloat _tickH;
}

@property (nonatomic, weak)   id  rxTarget;
@property (nonatomic, assign) SEL rxAction;
@end

@implementation RXSignTopView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        _bgImgView = [[UIImageView alloc] init];
        _bgImgView.image = [UIImage imageNamed:@"signIn_unSignIn_bg"];
        [self addSubview:_bgImgView];
        
        _tickW = 22;
        _tickH = 16;
        _tickL = (50 - _tickW)/2.0;
        _tickT = (46 - _tickH)/2.0 + 5;
        _isSignSuccView = [[UIView alloc] initWithFrame:CGRectMake(_tickL, _tickT, 0, _tickW)];
        _isSignSuccView.clipsToBounds = YES;
        
        UIImageView * tickImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0 , _tickW, _tickH)];
        tickImgView.image = [UIImage imageNamed:@"signIn_success_right"];
        [_isSignSuccView addSubview:tickImgView];
        
        _isSignSuccImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,  0, 50, 46)];
        _isSignSuccImgView.hidden = YES;
        _isSignSuccImgView.image = [UIImage imageNamed:@"signIn_success_calendar"];
        _isSignSuccImgView.backgroundColor = [UIColor clearColor];
        [self addSubview:_isSignSuccImgView];
        [_isSignSuccImgView addSubview:_isSignSuccView];
        
        _maxSignImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 84, 84)];
        _maxSignImgView.image = [UIImage imageNamed:@"signIn_circle_bg"];
        _maxSignImgView.hidden = YES;
        _maxSignImgView.backgroundColor = [UIColor clearColor];
        _maxSignImgView.userInteractionEnabled = YES;
        [self addSubview:_maxSignImgView];
        
        [self createStartImgView];
        
        _signButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _signButton.backgroundColor = [UIColor clearColor];
        _signButton.frame = CGRectMake(0, 0, 68, 68);
        _signButton.layer.cornerRadius = 34;
        _signButton.layer.borderWidth = 0;
        _signButton.clipsToBounds = YES;
        _signButton.hidden = YES;
        _signButton.enabled = NO;
        [_signButton setTitle:@"签到" forState:UIControlStateNormal];
        [_signButton setTitleColor:GHS_7f1084_COLOR forState:UIControlStateNormal];
        _signButton.titleLabel.font = [UIFont systemFontOfSize:22];
        [_signButton addTarget:self action:@selector(signButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_maxSignImgView addSubview:_signButton];
        
        _label1 = [[UILabel alloc] init];
        _label1.textAlignment = NSTextAlignmentCenter;
        _label1.font = [UIFont systemFontOfSize:16];
        _label1.textColor = [UIColor whiteColor];
        _label1.backgroundColor = [UIColor clearColor];
        _label1.text = [self labelWithSignDay:0];
        [self addSubview:_label1];
        
        _label2 = [[UILabel alloc] init];
        _label2.textAlignment = NSTextAlignmentCenter;
        //        _label2.font = [UIFont systemFontOfSize:12];
        //        _label2.textColor = [UIColor whiteColor];
        _label2.backgroundColor = [UIColor clearColor];
        _label2.attributedText = [self labelWithAginSignDay:5 willPrizeName:@""];
        [self addSubview:_label2];
        
        
        [self changeSelfFrame:frame];
        
        _is_sign = NO;
    }
    return self;
}

- (void)createStartImgView {
    _showAnimalIng = NO;
    
    _start_img_left_0 = [self setImgView:_start_img_left_0 frame:CGRectMake(0, 18, 10, 10) imageName:@"signIn_star_star" tag:100];
    _start_img_ritht_top_0 = [self setImgView:_start_img_ritht_top_0 frame:CGRectMake(0, 54, 6, 6) imageName:@"signIn_star_star" tag:101];
    _start_img_ritht_bottom_0 = [self setImgView:_start_img_ritht_bottom_0 frame:CGRectMake(0, 54, 6, 6) imageName:@"signIn_star_star" tag:102];
    
    _circle_img_left_1 = [self setImgView:_circle_img_left_1 frame:CGRectMake(0, 18, 7, 7) imageName:@"signIn_star_circle" tag:103];
    _circle_img_right_1 = [self setImgView:_circle_img_right_1 frame:CGRectMake(0, 112, 9, 9) imageName:@"signIn_star_circle" tag:104];
    
    _cross_img_mid_2 = [self setImgView:_cross_img_mid_2 frame:CGRectMake(0, 0, 6, 6) imageName:@"signIn_star_cross" tag:105];
    _cross_img_left_2 = [self setImgView:_cross_img_left_2 frame:CGRectMake(0, 0, 9, 9) imageName:@"signIn_star_cross" tag:106];
    _cross_img_right_2 = [self setImgView:_cross_img_right_2 frame:CGRectMake(0, 0, 8, 8) imageName:@"signIn_star_cross" tag:107];
    _cross_img_bottom_2 = [self setImgView:_cross_img_right_2 frame:CGRectMake(0, 0, 7, 7) imageName:@"signIn_star_cross" tag:108];
}
- (UIImageView *)setImgView:(UIImageView *)imgView frame:(CGRect)frame imageName:(NSString *)imageName tag:(NSInteger)tag {
    imgView = [[UIImageView alloc] initWithFrame:frame];
    imgView.hidden = YES;
    imgView.tag = tag;
    imgView.image = [UIImage imageNamed:imageName];
    [self addSubview:imgView];
    //随机旋转
    if([imageName rangeOfString:@"cross"].location != NSNotFound) {
        CGFloat rotation = 0.38 * (arc4random()%2);
        imgView.transform= CGAffineTransformMakeRotation(M_PI * rotation);
    }
    return imgView;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    //     [_animator removeAllBehaviors];
    [self changeSelfFrame:frame];
    
}

- (void)changeSelfFrame:(CGRect)frame {
    _bgImgView.frame = self.bounds;
    _isSignSuccImgView.center = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2 - 17);//90 - (上50 + viewCenterY23)
    _maxSignImgView.center = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2 - 18); //90 - (上30 + viewCenterY42)
    _signButton.center = CGPointMake(CGRectGetWidth(_maxSignImgView.frame)/2, CGRectGetWidth(_maxSignImgView.frame)/2);
    
    _label1.frame = CGRectMake(0, Y(_maxSignImgView) + HEIGHT_GHS(_maxSignImgView) + 8, self.bounds.size.width, 18);
    _label2.frame = CGRectMake(0, Y(_label1) + 18 + 6, self.bounds.size.width, 13);
    //星星坐标
    _start_img_left_0.center = CGPointMake(CGRectGetWidth(self.bounds)/2 - 138, CGRectGetHeight(self.bounds)/2 - (90 - 9 - 5));
    _start_img_ritht_top_0.center = CGPointMake(CGRectGetWidth(self.bounds)/2 + 137, CGRectGetHeight(self.bounds)/2 - (90 - 27 - 3));
    _start_img_ritht_bottom_0.center = CGPointMake(CGRectGetWidth(self.bounds)/2 + 39, CGRectGetHeight(self.bounds)/2 - (90 - 99 - 3));
    
    _circle_img_left_1.center = CGPointMake(CGRectGetWidth(self.bounds)/2 - 93, CGRectGetHeight(self.bounds)/2 - (90 - 56 - 3));
    _circle_img_right_1.center = CGPointMake(CGRectGetWidth(self.bounds)/2 + 77, CGRectGetHeight(self.bounds)/2 - (90 - 20 - 4));
    
    _cross_img_mid_2.center = CGPointMake(CGRectGetWidth(self.bounds)/2 - 2, CGRectGetHeight(self.bounds)/2 - (90 - 19 - 3));
    _cross_img_left_2.center = CGPointMake(CGRectGetWidth(self.bounds)/2 - 59, CGRectGetHeight(self.bounds)/2 - (90 - 31 - 4));
    _cross_img_right_2.center = CGPointMake(CGRectGetWidth(self.bounds)/2 + 91, CGRectGetHeight(self.bounds)/2 - (90 - 56 - 3));
    _cross_img_bottom_2.center = CGPointMake(CGRectGetWidth(self.bounds)/2 - 36, CGRectGetHeight(self.bounds)/2 - (90 - 90 - 3));
}

- (void)signButtonClick {
    if([self.rxTarget respondsToSelector:self.rxAction]) {
        RXMsgSend(RXMsgTarget(self.rxTarget), self.rxAction, self);
    }
}

/// 签到点击
- (void)addTarget:(id)target action:(SEL)action {
    _rxTarget = target;
    _rxAction = action;
}


- (void)signIned:(BOOL)isSignIned signInDay:(NSInteger)signInDay prizeName:(NSString*)prizeName needSignInDay:(NSInteger)needSignInDay needPrizeName:(NSString*)needPrizeName {
    
    if(isSignIned==NO && signInDay == 0 && ![prizeName strBOOL] && needSignInDay == 0 && ![needPrizeName strBOOL]) {
        return;
    }
    
    if(isSignIned) {
        _signButton.hidden = YES;
        _maxSignImgView.hidden = YES;
        _isSignSuccImgView.hidden = NO;
        _signButton.enabled = NO;
        _label1.text = [self labelWithSignGetPrizeName:prizeName signDay:signInDay];
        if(_is_sign && !_showAnimalIng) {
            _isSignSuccView.frame = CGRectMake(_tickL, _tickT, _tickW, _tickH);
            _label1.hidden = NO;
            _label2.hidden = NO;
            for(NSInteger i = 0; i < 9; i ++) {
                UIImageView * imgView = [self viewWithTag:100 + i];
                imgView.hidden = NO;
            }
        }
    }
    else {
        _label1.hidden = NO;
        _label2.hidden = NO;
        _signButton.hidden = NO;
        _maxSignImgView.hidden = NO;
        _isSignSuccImgView.hidden = YES;
        _signButton.enabled = YES;
        _label1.text = [self labelWithSignDay:signInDay];
    }
    _label2.attributedText = [self labelWithAginSignDay:needSignInDay - signInDay willPrizeName:needPrizeName];
    
    
}


- (NSString *)labelWithSignDay:(NSInteger)signDay {
    return [NSString stringWithFormat:@"- 您已连续签到%zd天 -", signDay];
}

///// 签到成功！(恭喜您获得10积分!)
- (NSString *)labelWithSignGetPrizeName:(NSString *)prizeName signDay:(NSInteger)signDay {
    if([prizeName strBOOL])
        return [NSString stringWithFormat:@"签到成功！恭喜您获得%@!", prizeName];
    
    return [NSString stringWithFormat:@"签到成功！您已连续签到%zd天", signDay];
}

///// 再连续签到(7)天即可获得 (10元优惠券)
- (NSMutableAttributedString *)labelWithAginSignDay:(NSInteger)signDay willPrizeName:(NSString *)prizeName {
    prizeName = [prizeName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    prizeName = [NSString stringWithFormat:@" %@", prizeName];
    NSString * string = [NSString stringWithFormat:@"再连续签到%zd天即可获得%@", signDay, prizeName];
    
    NSMutableAttributedString * attri = [[NSMutableAttributedString alloc] initWithString:string];
    [attri addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12], NSForegroundColorAttributeName : [UIColor whiteColor]} range:NSMakeRange(0, attri.length)];
    
    [attri addAttribute:NSForegroundColorAttributeName value:[UIColor yellowColor] range:NSMakeRange(attri.length - prizeName.length, prizeName.length)];
    
    return attri;
}

- (void)signButtonClickSucess {
    //防止动画时，这些影响效果
    _signButton.hidden = YES;
    _maxSignImgView.hidden = YES;
    _isSignSuccImgView.hidden = NO;
    _signButton.enabled = NO;
    
    _label1.hidden = YES;
    _label2.hidden = YES;
    
    //告诉controller scroll.bounce = NO;//在点击的时候，就有处理，这个可以不传过去
    _showAnimalIng = YES;
    _is_sign = YES;
    _isSignSuccView.frame = CGRectMake(_tickL, _tickT, 0, _tickH);
    _isSignSuccImgView.center = CGPointMake(CGRectGetWidth(self.bounds)/2, - 46);
    //    [self createCollisionBehavior];
    [self starAnimation];
    __weak typeof(self)wself = self;
    [UIView animateWithDuration:1.5f
                          delay:0.f
         usingSpringWithDamping:0.5f
          initialSpringVelocity:0.f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         _isSignSuccImgView.center = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2 - 17);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.2 animations:^{
                             //画对号
                             _isSignSuccView.frame = CGRectMake(_tickL, _tickT, _tickW, _tickH);
                         } completion:^(BOOL finished) {
                             //告诉controller scroll.bounce = YES;
                             _showAnimalIng = NO;
                             if(_animalComplete) {
                                 _animalComplete();
                             }
                         }];
                         _label1.hidden = NO;
                         _label2.hidden = NO;
                     }];
    
}

//- (void)createCollisionBehavior {
//
//    // 创建UIDynamicAnimator 对象
//    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
//
//    NSArray *animatorObjects = @[_isSignSuccImgView];
//    // 刚刚在API 看到了初始化UIDynamicAnimator需要关联一个或者多个行为
//    _gravityBehav = [[UIGravityBehavior alloc] initWithItems:animatorObjects];
//    _colision = [[UICollisionBehavior alloc] initWithItems:animatorObjects];
//    // 这里设置代理是为了监听碰撞状态的，可以去了解一下代理方法
//    _colision.collisionDelegate = self;
//
//    // 设置碰撞边界
//    [_colision addBoundaryWithIdentifier:@"boundaryLine" fromPoint:CGPointMake(0, CGRectGetHeight(self.bounds)/2 - 17 + (CGRectGetHeight(_isSignSuccImgView.frame)/2.0)) toPoint:CGPointMake(ScreenWidth, CGRectGetHeight(self.bounds)/2 - 17 + (CGRectGetHeight(_isSignSuccImgView.frame)/2.0))];
//    // 设置动态行为参数
//    UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:animatorObjects];
//    // 设置弹性
//    [itemBehavior setElasticity:0.3];
//
//    // 创建了行为需要animator添加
//    [_animator addBehavior:_gravityBehav];
//    [_animator addBehavior:_colision];
//    [_animator addBehavior:itemBehavior];
//}
////检测到碰撞时
//- (void)collisionBehavior:(UICollisionBehavior*)behavior beganContactForItem:(id <UIDynamicItem>)item withBoundaryIdentifier:(nullable id <NSCopying>)identifier atPoint:(CGPoint)p {
//
//    TTLog(@"检测到碰撞");
//}
//
////碰撞结束
//- (void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier {
//
//    TTLog(@"end");
//
//    if(_collisionEndBool) {
//        _isSignSuccView.frame = CGRectMake(0, 0, 0, 46);
//        [UIView animateWithDuration:0.8 animations:^{
//            //画对号
//            _isSignSuccView.frame = CGRectMake(0, 0, 50, 46);
//        } completion:^(BOOL finished) {
//            _label1.hidden = NO;
//            _label2.hidden = NO;
//            //告诉controller scroll.bounce = YES;
//            _showAnimalIng = NO;
//            if(_animalComplete) {
//                _animalComplete();
//            }
//        }];
//        _collisionEndBool = NO;
//    }
//    else {
//        _collisionEndBool = YES;
//    }
//
//
//}

- (void)alterDrawLineAnimal {
    
    [UIView animateWithDuration:0.5 animations:^{
        //画对号
        _isSignSuccView.frame = CGRectMake(_tickL, _tickT, _tickW, _tickH);
    } completion:^(BOOL finished) {
        //告诉controller scroll.bounce = YES;
        _showAnimalIng = NO;
        if(_animalComplete) {
            _animalComplete();
        }
    }];
}
- (void)showPrizeLabel {
    _label1.hidden = NO;
    _label2.hidden = NO;
}


- (void)starAnimation {
    for(NSInteger i = 0; i < 9; i ++) {
        UIImageView * imgView = [self viewWithTag:100 + i];
        imgView.hidden = NO;
        imgView.alpha = 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((arc4random() % 3 + (arc4random() % (i+1) / 10)) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [imgView.layer addAnimation:[self opacityAnimation:0.8] forKey:nil];
        });
    }
}

//星星 闪烁动画
-(CABasicAnimation *)opacityAnimation:(float)time
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = @(1);
    animation.toValue = @(0);
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = 3;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    return animation;
}


@end
