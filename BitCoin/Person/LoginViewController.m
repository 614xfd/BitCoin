//
//  LoginViewController.m
//  BitCoin
//
//  Created by LBH on 2017/9/23.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "FindIDViewController.h"
#import <AdSupport/AdSupport.h>
#import "CaptchaViewController.h"

@interface LoginViewController () {
    BOOL _isShow;
    UIColor *_color;
    NSString *_uid;
    NSString *_authenticationStatus;
    NSString *_PaymentPasswordStatus;
}

@end

@implementation LoginViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setBarBlackColor:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _isShow = NO;//  密码默认不显示
    _uid = @"";
    _authenticationStatus = @"";
    _PaymentPasswordStatus = @"";
    
    [self.bgView.layer setMasksToBounds:YES];
    self.bgView.layer.cornerRadius = 6;
    [self.bgView.layer setBorderWidth:1];
    [self.bgView.layer setBorderColor:[UIColor whiteColor].CGColor];
    
    self.titleLabel.font = [UIFont fontWithName:@"Chap" size:22];
    [self.loginBtn.layer setMasksToBounds:YES];
    self.loginBtn.layer.cornerRadius = self.loginBtn.frame.size.height/2;
    [self.line.layer setMasksToBounds:YES];
    self.line.layer.cornerRadius = self.line.frame.size.height/2;
    [self.line.layer setBorderWidth:1];
    [self.line.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.line1.layer setMasksToBounds:YES];
    self.line1.layer.cornerRadius = self.line1.frame.size.height/2;
    [self.line1.layer setBorderWidth:1];
    [self.line1.layer setBorderColor:[UIColor whiteColor].CGColor];
    //    _color = self.loginBtn.titleLabel.textColor;
    //    [self.loginBtn setBackgroundImage:[UIImage imageNamed:@"不可登录.png"] forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRegisterBtnColor) name:UITextFieldTextDidChangeNotification object:nil];
//    self.phoneNum.text = @"15915447455";
//    self.passwordNum.text = @"123456";
    self.phoneNum.returnKeyType =UIReturnKeyDone;
    self.passwordNum.returnKeyType =UIReturnKeyDone;
    self.passwordNum.secureTextEntry = YES;
    //    UIColor *color = [UIColor whiteColor];
    //    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    //    style.alignment = NSTextAlignmentCenter;
    //    self.phoneNum.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.phoneNum.placeholder attributes:@{NSForegroundColorAttributeName: color,NSFontAttributeName:self.phoneNum.font, NSParagraphStyleAttributeName:style}];
    //    self.passwordNum.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.passwordNum.placeholder attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:self.passwordNum.font, NSParagraphStyleAttributeName:style}];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenAlert)];
    self.bgLabel.userInteractionEnabled = YES;
    [self.bgLabel addGestureRecognizer:tap];
}

- (void) changeRegisterBtnColor
{
    if (self.phoneNum.text.length>0) {
        self.label.hidden = YES;
    } else {
        self.label.hidden = NO;
    }
    if (self.passwordNum.text.length>0) {
        self.label1.hidden = YES;
    } else {
        self.label1.hidden = NO;
    }
    if (self.phoneNum.text.length>0&&self.passwordNum.text.length>0) {
        //        [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //        [self.loginBtn setBackgroundImage:[UIImage imageNamed:@"可登陆.png"] forState:UIControlStateNormal];
    } else {
        //        [self.loginBtn setTitleColor:_color forState:UIControlStateNormal];
        //        [self.loginBtn setBackgroundImage:[UIImage imageNamed:@"不可登录.png"] forState:UIControlStateNormal];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"najhvpasdhfahsdfiasdf");
    if (textField == self.phoneNum) {
        [self.passwordNum becomeFirstResponder];
    } else {
        if (self.phoneNum.text.length > 0 && self.passwordNum.text.length > 0) {
            //            [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            //            [self.loginBtn setBackgroundImage:[UIImage imageNamed:@"可登陆.png"] forState:UIControlStateNormal];
            [self.phoneNum resignFirstResponder];
            [self.passwordNum resignFirstResponder];
        } else {
            //            [self.phoneNum becomeFirstResponder];
        }
    }
    
    return YES;
}

- (IBAction)changeImage:(id)sender {
    if (_isShow) {
        self.showPasswordImage.image = [UIImage imageNamed:@"闭眼.png"];
        NSString *tempPwdStr = self.passwordNum.text;
        self.passwordNum.text = @""; // 这句代码可以防止切换的时候光标偏移
        self.passwordNum.secureTextEntry = YES;
        self.passwordNum.text = tempPwdStr;
    } else {
        self.showPasswordImage.image = [UIImage imageNamed:@"睁眼.png"];
        NSString *tempPwdStr = self.passwordNum.text;
        self.passwordNum.text = @""; // 这句代码可以防止切换的时候光标偏移
        self.passwordNum.secureTextEntry = NO;
        self.passwordNum.text = tempPwdStr;
    }
    _isShow = !_isShow;
}

- (void) request
{
    __weak __typeof(self) weakSelf = self;
    NSString *uuid = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSString *string = [self md5:[NSString stringWithFormat:@"%@%@",self.passwordNum.text,self.phoneNum.text]];
    if([self.phoneNum.text isEqualToString:@"13691888542"]){
        uuid = @"4E9FA0B1-EC0B-4CBD-83EF-AB54E2813FA8";
    }
    //    NSDictionary *dic = @{@"phone":self.phoneNum.text, @"pwd":string, @"mac":uuid};
    NSDictionary *dic = @{@"phone":self.phoneNum.text, @"loginPwd":string};
    [[NetworkTool sharedTool] requestWithURLString:@"login" parameters:dic method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@", stringData, JSON );
        //        NSString *isError = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            //                        [weakSelf verifyPass];
            _uid = [[JSON objectForKey:@"Data"] objectForKey:@"id"];
            _authenticationStatus = [[JSON objectForKey:@"Data"] objectForKey:@"AuthenticationStatus"];
            _PaymentPasswordStatus = [[JSON objectForKey:@"Data"] objectForKey:@"PaymentPasswordStatus"];
            [weakSelf performSelectorOnMainThread:@selector(loginSuccess:) withObject:JSON waitUntilDone:YES];
            
        } else {
            NSString *msg = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"msg"]];
            if ([msg isEqualToString:@"该设备没有登陆过,请从新验证后在登陆"]) {
                [weakSelf performSelectorOnMainThread:@selector(showAlert) withObject:nil waitUntilDone:YES];
            } else if ([msg isEqualToString:@"账号或密码错误"]) {
                [weakSelf performSelectorOnMainThread:@selector(showToastWithMessage:) withObject:[JSON objectForKey:@"msg"] waitUntilDone:YES];
                //                [weakSelf showToastWithMessage:[JSON objectForKey:@"msg"]];
            }
        }
    } failed:^(NSError *error) {
        //        [weakSelf requestError];
    }];
}

- (void) sendCode
{
    __weak __typeof(self) weakSelf = self;
    NSDictionary *dic = @{@"phone": self.phoneNum.text, @"timestamp":[NSString stringWithFormat:@"%ld",(long)([[NSDate date] timeIntervalSince1970])], @"auth":@"minant", @"q":@"q"};
    [[NetworkTool sharedTool] requestWithURLString:@"sms/sendSmsCode" parameters:dic method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@",stringData, JSON );
        //        NSString *isError = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            
        } else {
            [weakSelf performSelectorOnMainThread:@selector(showToastWithMessage:) withObject:[JSON objectForKey:@"msg"] waitUntilDone:YES];
        }
    } failed:^(NSError *error) {
        [weakSelf requestError];
    }];
}

- (void) showAlert
{
    [self.phoneNum resignFirstResponder];
    [self.passwordNum resignFirstResponder];
    self.bgLabel.hidden = NO;
    self.alertView.hidden = NO;
}
- (IBAction)intoCaptcha:(id)sender {
    CaptchaViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CaptchaVC"];
    vc.phoneNum = [NSString stringWithFormat:@"%@", self.phoneNum.text];
    vc.phone = self.phoneNum.text;
    vc.password = self.passwordNum.text;
    vc.isVerify = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)cancleBtnclick:(id)sender {
    [self hiddenAlert];
}

- (void) hiddenAlert
{
    [self.phoneNum resignFirstResponder];
    [self.passwordNum resignFirstResponder];
    self.bgLabel.hidden = YES;
    self.alertView.hidden = YES;
}

- (void) loginSuccess:(id)loginData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"YES" forKey:@"isLogin"];
    [defaults setObject:((NSDictionary *)loginData)[@"data"] forKey:@"token"];
    [defaults setObject:self.phoneNum.text forKey:@"phoneNum"];
    [defaults setObject:_uid forKey:@"uid"];
    [defaults setObject:_authenticationStatus forKey:@"authenticationStatus"];
    [defaults setObject:_PaymentPasswordStatus forKey:@"paymentPasswordStatus"];
    [defaults synchronize];
    
    ToastView *messageView = [[ToastView alloc]initWithFrame:self.view.bounds WithMessage:@"登录成功"];
    [self.view addSubview:messageView];
    
    double delayInSeconds = 1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_global_queue(0,0), ^(void){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.isResetPW) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            } else {
                if (self.isMonitoring) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    return;
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
        });
    });
}

- (IBAction)loginBtnClick:(id)sender {
    if (self.phoneNum.text.length>0&&self.passwordNum.text.length>0) {
        //  请求
        [self request];
        //        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)forgetBtnClick:(id)sender {
    RegisterViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterVC"];
    vc.isFindID = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)registerBtnClick:(id)sender {
    RegisterViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)sendCodeBtnClick:(id)sender {
    if (self.phoneNum.text.length>0) {

        [self sendCode];
    } else
        [self showToastWithMessage:@"请输入手机号"];
}

- (IBAction)goBack:(id)sender {
    if (self.isMonitoring) {
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"RE_BACK" object:nil]];
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    if (self.isResetPW) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.phoneNum resignFirstResponder];
    [self.passwordNum resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
