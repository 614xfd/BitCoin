//
//  YWUnlockView.m
//  YWUnlock
//
//  Created by dyw on 2017/2/24.
//  Copyright © 2017年 dyw. All rights reserved.
//

#import "YWUnlockView.h"
#import "YWUnlockMacros.h"
#import "YWUnlockPreviewView.h"
#import "YWGesturesUnlockView.h"

#define GesturesPassword @"GesturesPassword"

#define normalColor [UIColor colorWithRed:76/255.0 green:76/255.0 blue:76/255.0 alpha:1]
#define warnlColor [UIColor colorWithRed:240/255.0 green:80/255.0 blue:80/255.0 alpha:1]

@interface YWUnlockView ()
/** 头像 */
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
/** 绘制密码的状态label */
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
/** 重新绘制按钮 */
@property (weak, nonatomic) IBOutlet UIButton *resetGesturesPasswordButton;
/** 手势密码预览图 */
@property (weak, nonatomic) IBOutlet YWUnlockPreviewView *unlockPreviewView;
/** 手势密码绘制视图 */
@property (weak, nonatomic) IBOutlet YWGesturesUnlockView *gesturesUnlockView;
/** 当前创建的手势密码 */
@property (nonatomic, copy) NSString *curentGesturePassword;
/** 当前处理密码类型 (默认是创建密码) */
@property (nonatomic, assign) YWUnlockViewType type;
/** 操作结果 回调 */
@property (nonatomic, copy) CallBackBlock block;
@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//@property (weak, nonatomic) IBOutlet UIButton *backBtn;
//@property (weak, nonatomic) IBOutlet UIImageView *backImage;

@property (nonatomic, assign) BOOL isVerify;

@end

@implementation YWUnlockView

#pragma mark - life cycle
- (void)awakeFromNib{
    [super awakeFromNib];
    self.type = YWUnlockViewCreate;//默认是创建密码
}

#pragma mark - private methods
/** 根据不同的类型处理 */
- (void)handleWithType:(YWUnlockViewType)type password:(NSString *)gesturePassword{
    switch (type) {
        case YWUnlockViewCreate://创建手势密码
            [self createGesturesPassword:gesturePassword];
            self.forgetBtn.hidden = YES;
//            self.backBtn.hidden = NO;
//            self.backImage.hidden = NO;
            break;
        case YWUnlockViewUnlock://解锁手势密码
            [self validateGesturesPassword:gesturePassword];
            self.forgetBtn.hidden = NO;
//            self.backBtn.hidden = NO;
//            self.backImage.hidden = NO;
            break;
    }
}

//创建手势密码
- (void)createGesturesPassword:(NSString *)gesturesPassword {
    if (self.curentGesturePassword.length == 0) {
        if (gesturesPassword.length <6) {
            self.statusLabel.text = @"至少连接六个点，请重新输入";
            self.statusLabel.textColor = warnlColor;
            [self shakeAnimationForView:self.statusLabel];
            return;
        }
        if (self.resetGesturesPasswordButton.hidden == YES) {
            self.resetGesturesPasswordButton.hidden = NO;
        }
        self.curentGesturePassword = gesturesPassword;
        [self.unlockPreviewView setGesturesPassword:gesturesPassword];
        self.statusLabel.text = @"请再次绘制解锁图案";
        self.statusLabel.textColor = normalColor;
        return;
    }
    if ([self.curentGesturePassword isEqualToString:gesturesPassword]) {//绘制成功
        //保存手势密码
        [YWUnlockView saveGesturesPassword:gesturesPassword];
        !self.block?:self.block(YES);
        [self hide];
    }else {
        self.statusLabel.text = @"两次绘制的图案不一致，请重新绘制";
        self.statusLabel.textColor = warnlColor;
        [self shakeAnimationForView:self.statusLabel];
    }
}

//验证手势密码
- (void)validateGesturesPassword:(NSString *)gesturesPassword {
    static NSInteger errorCount = 5;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *phoneNum = [defaults objectForKey:@"phoneNum"];
    self.statusLabel.text = phoneNum;
    self.statusLabel.textColor = normalColor;
    self.forgetBtn.hidden = NO;
    if ([gesturesPassword isEqualToString:[YWUnlockView getGesturesPassword]]) {
        if (self.isVerify) {
            [YWUnlockView showUnlockViewWithType:YWUnlockViewCreate andReset:@"设置手势密码" andIsVerify:NO callBack:^(BOOL result) {
                if (result) {
                    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"Unlock_Hidden" object:nil]];
                }
            }];
            return;
        }
        errorCount = 5;
        !self.block?:self.block(YES);
        [self hide];

    }else {
        if (errorCount - 1 == 0) {//你已经输错五次了！ 退出登陆！
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"手势密码已失效" message:@"请重新登陆" delegate:self cancelButtonTitle:nil otherButtonTitles:@"重新登陆", nil];
            [alertView show];
            errorCount = 5;
            return;
        }
        self.statusLabel.text = [NSString stringWithFormat:@"密码错误，还可以再输入%ld次",--errorCount];
        self.statusLabel.textColor = warnlColor;
        [self shakeAnimationForView:self.statusLabel];
    }
}

//抖动动画
- (void)shakeAnimationForView:(UIView *)view{
    CALayer *viewLayer = view.layer;
    CGPoint position = viewLayer.position;
    CGPoint left = CGPointMake(position.x - 10, position.y);
    CGPoint right = CGPointMake(position.x + 10, position.y);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:left]];
    [animation setToValue:[NSValue valueWithCGPoint:right]];
    [animation setAutoreverses:YES]; // 平滑结束
    [animation setDuration:0.08];
    [animation setRepeatCount:3];
    [viewLayer addAnimation:animation forKey:nil];
}

#pragma mark - public methods
/** 展示 手势密码视图 */
+ (void)showUnlockViewWithType:(YWUnlockViewType)type andReset:(NSString *)string andIsVerify:(BOOL)isVerify callBack:(CallBackBlock)callBack{
    if(type == YWUnlockViewUnlock && ![YWUnlockView getGesturesPassword].length) return;
    YWUnlockView *unlockView = [YWUnlock_BD loadNibNamed:@"YWUnlockView" owner:nil options:nil].lastObject;
    unlockView.titleLabel.text = string;
    unlockView.frame = CGRectMake(0, YWUnlock_SH, YWUnlock_SW, YWUnlock_SH);
    [YWUnlock_KW addSubview:unlockView];
    unlockView.block = [callBack copy];
    unlockView.type = type;
    unlockView.isVerify = isVerify;
    if (isVerify) {
        unlockView.tag = 989898;
    } else {
        unlockView.tag = 989899;
    }
    [UIView animateWithDuration:0.25 animations:^{
        unlockView.frame = CGRectMake(0, 0, YWUnlock_SW, YWUnlock_SH);
    }];
}

/** 隐藏视图 */
- (void)hide{
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, YWUnlock_SH, YWUnlock_SW, YWUnlock_SH);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    !self.block?:self.block(NO);
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"isLogin"];
    [defaults removeObjectForKey:@"phoneNum"];
    [defaults removeObjectForKey:@"uid"];
    [defaults removeObjectForKey:@"authenticationStatus"];
    [defaults removeObjectForKey:@"paymentPasswordStatus"];
    [defaults synchronize];
    [YWUnlockView deleteGesturesPassword];
    
    [self hide];
}

- (IBAction)forgetBtnClick:(id)sender {
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"isLogin"];
    [defaults removeObjectForKey:@"phoneNum"];
    [defaults removeObjectForKey:@"uid"];
    [defaults removeObjectForKey:@"authenticationStatus"];
    [defaults removeObjectForKey:@"paymentPasswordStatus"];
    [defaults synchronize];
    [YWUnlockView deleteGesturesPassword];
    
    [self hide];
}

#pragma mark - event response
//返回按钮点击
- (IBAction)backButtonClick:(UIButton *)sender {
    if (self.type == YWUnlockViewUnlock) {
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"isLogin"];
        [defaults removeObjectForKey:@"phoneNum"];
        [defaults removeObjectForKey:@"uid"];
        [defaults removeObjectForKey:@"authenticationStatus"];
        [defaults removeObjectForKey:@"paymentPasswordStatus"];
        [defaults synchronize];
        [YWUnlockView deleteGesturesPassword];
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"Unlock_Del" object:nil]];
        [self hide];
    } else {
        !self.block?:self.block(NO);
        [self hide];
    }
}

//点击重新绘制按钮
- (IBAction)resetGesturePassword:(id)sender {
    self.curentGesturePassword = nil;
    self.statusLabel.text = @"请绘制手势密码";
    self.resetGesturesPasswordButton.hidden = YES;
    [self.unlockPreviewView setGesturesPassword:@""];
}

#pragma mark - getters and setters
/** 设置密码的操作类型 */
- (void)setType:(YWUnlockViewType)type{
    _type = type;
    self.unlockPreviewView.hidden = _type != YWUnlockViewCreate;
    self.iconImageView.hidden = _type == YWUnlockViewCreate;
    YWUnlock_WKSELF;
    [self.gesturesUnlockView setDrawRectFinishedBlock:^(NSString *gesturePassword) {
        [weakSelf handleWithType:type password:gesturePassword];
    }];
}

#pragma mark - other methods
/** 是否已经创建过手势密码 */
+ (BOOL)haveGesturePassword{
    return [YWUnlockView getGesturesPassword].length?YES:NO;
}

/** 删除手势密码 */
+ (void)deleteGesturesPassword{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:GesturesPassword];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/** 保存手势密码 */
+ (void)saveGesturesPassword:(NSString *)gesturesPassword {
    [[NSUserDefaults standardUserDefaults] setObject:gesturesPassword forKey:GesturesPassword];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/** 获取手势密码 */
+ (NSString *)getGesturesPassword{
    return [[NSUserDefaults standardUserDefaults] objectForKey:GesturesPassword];
}

@end
