//
//  ResetPasswordViewController.m
//  BitCoin
//
//  Created by LBH on 2017/9/23.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "LoginViewController.h"

@interface ResetPasswordViewController () {
    UIColor *_color;
    NSString *_uid;
    NSString *_authenticationStatus;
    NSString *_PaymentPasswordStatus;

}

@end

@implementation ResetPasswordViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setBarBlackColor:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.nextBtn.layer setMasksToBounds:YES];
    self.nextBtn.layer.cornerRadius = 8;
    _uid = @"";
    _authenticationStatus = @"";
    _PaymentPasswordStatus = @"";
    self.tipLabel.text = [NSString stringWithFormat:@"请为您的账号 %@ 设置一个新密码。", self.phoneNum];
    self.tipLabel.textColor = [UIColor grayColor];
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:self.tipLabel.text];
    NSUInteger firstLoc = [[noteStr string] rangeOfString:@"号"].location + 1;
    NSUInteger secondLoc = [[noteStr string] rangeOfString:@"设"].location;
    NSRange range = NSMakeRange(firstLoc, secondLoc - firstLoc);
    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range];
    [noteStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20] range:range];
    [self.tipLabel setAttributedText:noteStr];
    
    _color = self.nextBtn.titleLabel.textColor;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRegisterBtnColor) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void) changeRegisterBtnColor
{
    if (self.passwordNumTF.text.length>0) {
        [self.nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else {
        [self.nextBtn setTitleColor:_color forState:UIControlStateNormal];
    }
}

- (IBAction)nextBtnClick:(id)sender {
    if ([self inputShouldNumber:self.passwordNumTF.text]||[self inputShouldLetter:self.passwordNumTF.text]) {
        ToastView *messageView = [[ToastView alloc]initWithFrame:self.view.bounds WithMessage:@"密码必须是6-16位英文字母+数字，注意区分大小写！"];
        [self.view addSubview:messageView];
        return;
    } else {
        //  请求
        NSString *string = [self md5:self.passwordNumTF.text];

        __weak __typeof(self) weakSelf = self;
        NSDictionary *dic = @{@"phone":self.phoneNum, @"pwd":string};
        [[NetworkTool sharedTool] requestWithURLString:@"forgotPassWord/updatepwd" parameters:dic method:@"POST" completed:^(id JSON, NSString *stringData) {
            NSLog(@"%@      ------------- %@", stringData, JSON );
            NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
            if ([code isEqualToString:@"1"]) {
                _uid = [[JSON objectForKey:@"Data"] objectForKey:@"id"];
                _authenticationStatus = [[JSON objectForKey:@"Data"] objectForKey:@"AuthenticationStatus"];
                _PaymentPasswordStatus = [[JSON objectForKey:@"Data"] objectForKey:@"PaymentPasswordStatus"];
                [weakSelf performSelectorOnMainThread:@selector(resetSuccess) withObject:nil waitUntilDone:YES];
            } else {
                [weakSelf performSelectorOnMainThread:@selector(showToastWithMessage:) withObject:[JSON objectForKey:@"msg"] waitUntilDone:YES];
            }
        } failed:^(NSError *error) {
        }];
        
//        UILabel *label = [[UILabel alloc]initWithFrame:self.view.bounds];
//        label.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
//        [self.view addSubview:label];
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"您的账号（%@）新密码设置成功，请用新密码进行登录，切记", self.phoneNum] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        [alert show];
        
    }
}

- (void) resetSuccess
{
    ToastView *messageView = [[ToastView alloc]initWithFrame:self.view.bounds WithMessage:@"设置新密码成功"];
    [self.view addSubview:messageView];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:_uid forKey:@"uid"];
    [defaults setObject:_authenticationStatus forKey:@"authenticationStatus"];
    [defaults setObject:_PaymentPasswordStatus forKey:@"paymentPasswordStatus"];
    [defaults removeObjectForKey:@"phoneNum"];
    [defaults removeObjectForKey:@"isLogin"];
    [defaults synchronize];
    double delayInSeconds = 1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_global_queue(0,0), ^(void){
        dispatch_async(dispatch_get_main_queue(), ^{
            LoginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
            vc.isResetPW = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        });
    });
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) error {
    ToastView *messageView = [[ToastView alloc]initWithFrame:self.view.bounds WithMessage:@"密码必须是6-16位英文字母+数字，注意区分大小写！"];
    [self.view addSubview:messageView];
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
