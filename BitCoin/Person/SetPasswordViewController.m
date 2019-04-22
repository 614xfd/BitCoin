//
//  SetPasswordViewController.m
//  BitCoin
//
//  Created by LBH on 2017/9/23.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import "SetPasswordViewController.h"
#import <AdSupport/AdSupport.h>
#import "LoginViewController.h"

@interface SetPasswordViewController () {
    NSString *_uid;
    NSString *_authenticationStatus;
    NSString *_PaymentPasswordStatus;

}

@end

@implementation SetPasswordViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setBarBlackColor:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.saveBtn.layer setMasksToBounds:YES];
    self.saveBtn.layer.cornerRadius = 8;
    _uid = @"";
    _authenticationStatus = @"";
    _PaymentPasswordStatus = @"";
    self.tipLabel.text = [NSString stringWithFormat:@"请为您的账号 %@ 设置一个密码。", self.phoneNum];
    self.tipLabel.textColor = [UIColor grayColor];
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:self.tipLabel.text];
    NSUInteger firstLoc = [[noteStr string] rangeOfString:@"号"].location + 1;
    NSUInteger secondLoc = [[noteStr string] rangeOfString:@"设"].location;
    NSRange range = NSMakeRange(firstLoc, secondLoc - firstLoc);
    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range];
    [noteStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20] range:range];
    [self.tipLabel setAttributedText:noteStr];
    
    self.fPassword.returnKeyType =UIReturnKeyDone;
    self.sPassword.returnKeyType =UIReturnKeyDone;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSaveBtnColor) name:UITextFieldTextDidChangeNotification object:nil];

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"najhvpasdhfahsdfiasdf");
    if (textField == self.fPassword) {
        [self.sPassword becomeFirstResponder];
    } else {
        if (self.fPassword.text.length > 0 && self.sPassword.text.length > 0) {
            [self.saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.saveBtn setBackgroundColor:[UIColor colorWithRed:47/255.0 green:130/255.0 blue:200/255.0 alpha:1]];
            [self.fPassword resignFirstResponder];
            [self.sPassword resignFirstResponder];
        } else {
            [self.fPassword becomeFirstResponder];
        }
    }
    
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.fPassword || textField == self.sPassword) {
        NSUInteger lengthOfString = string.length;  //lengthOfString的值始终为1
        for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {
            unichar character = [string characterAtIndex:loopIndex]; //将输入的值转化为ASCII值（即内部索引值），可以参考ASCII表
            // 48-57;{0,9};65-90;{A..Z};97-122:{a..z}
            if (character < 48) return NO; // 48 unichar for 0
            if (character > 57 && character < 65) return NO; //
            if (character > 90 && character < 97) return NO;
            if (character > 122) return NO;
            
        }
        // Check for total length
//        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
//        if (proposedNewLength > 6) {
//            return NO;//限制长度
//        }
        return YES;
    }
    return YES;
}


- (void) changeSaveBtnColor
{
    if (self.fPassword.text.length<1 || self.sPassword.text.length<1) {
        [self.saveBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.saveBtn setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    }
    if (self.fPassword.text.length > 0 && self.sPassword.text.length > 0) {
        [self.saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.saveBtn setBackgroundColor:[UIColor colorWithRed:47/255.0 green:130/255.0 blue:200/255.0 alpha:1]];
    }
}

- (void) request
{
    NSString *s = @"";
    if (self.invite.text.length > 0) {
        s = self.invite.text;
    }
    __weak __typeof(self) weakSelf = self;
    NSString *uuid = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSString *string = [self md5:self.sPassword.text];
    NSDictionary *dic = @{@"phone": self.phone, @"pwd" : string, @"inviteYards":s};
    [[NetworkTool sharedTool] requestWithURLString:@"UserRegister/newRegister" parameters:dic method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@",stringData, JSON );
        //        NSString *isError = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];

        if ([code isEqualToString:@"1"]) {
//            _uid = [[JSON objectForKey:@"Data"] objectForKey:@"id"];
//            _authenticationStatus = [[JSON objectForKey:@"Data"] objectForKey:@"AuthenticationStatus"];
//            _PaymentPasswordStatus = [[JSON objectForKey:@"Data"] objectForKey:@"PaymentPasswordStatus"];
            [weakSelf performSelectorOnMainThread:@selector(login) withObject:nil waitUntilDone:YES];
        } else {
            [weakSelf performSelectorOnMainThread:@selector(showToastWithMessage:) withObject:[JSON objectForKey:@"msg"] waitUntilDone:YES];
        }
    } failed:^(NSError *error) {
//        [weakSelf requestError];
        NSLog(@"jalskdjfashdflasdkfhasdf");
    }];
}

- (void) login
{
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:@"YES" forKey:@"isLogin"];
//    [defaults setObject:self.phone forKey:@"phoneNum"];
//    [defaults setObject:_PaymentPasswordStatus forKey:@"paymentPasswordStatus"];
//    [defaults setObject:_uid forKey:@"uid"];
//    [defaults setObject:_authenticationStatus forKey:@"authenticationStatus"];
//    [defaults synchronize];
    
    ToastView *messageView = [[ToastView alloc]initWithFrame:self.view.bounds WithMessage:@"登录密码设置成功"];
    [self.view addSubview:messageView];
    
    double delayInSeconds = 1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_global_queue(0,0), ^(void){
        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.navigationController popToRootViewControllerAnimated:YES];
            LoginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
            vc.isResetPW = YES;
            [self.navigationController pushViewController:vc animated:YES];
        });
    });
}

- (IBAction)savePassword:(id)sender {
    if ([self.fPassword.text isEqualToString:self.sPassword.text]) {
        if ([self inputShouldNumber:self.fPassword.text]||[self inputShouldLetter:self.fPassword.text]) {
            ToastView *messageView = [[ToastView alloc]initWithFrame:self.view.bounds WithMessage:@"密码必须是6-16位英文字母+数字，注意区分大小写！"];
            [self.view addSubview:messageView];
            return;
        }
        
        //设置密码网络请求
        [self request];
//        [self login];

    } else {
        ToastView *messageView = [[ToastView alloc]initWithFrame:self.view.bounds WithMessage:@"密码不一致，请重新输入"];
        [self.view addSubview:messageView];
    }
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.fPassword resignFirstResponder];
    [self.sPassword resignFirstResponder];
    [self.invite resignFirstResponder];
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
