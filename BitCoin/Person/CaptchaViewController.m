//
//  CaptchaViewController.m
//  BitCoin
//
//  Created by LBH on 2017/9/23.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import "CaptchaViewController.h"
#import "SetPasswordViewController.h"
#import <AdSupport/AdSupport.h>
#import "ResetPasswordViewController.h"
#import "SetPayPassWordViewController.h"

@interface CaptchaViewController () {
    int _secondsCountDown; //倒计时总时长
    NSTimer *_countDownTimer;
    NSString *_captchaString;
    BOOL _isS;
    
}

@end

@implementation CaptchaViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _isS = NO;
    [self setBarBlackColor:YES];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    _captchaString = @"101010";
    _captchaString = [NSString string];
    [self request];
    _isS = NO;
    self.tipLabel.text = [NSString stringWithFormat:@"我们已向 %@ 发送验证码短信，请查看短信并输入验证码。", self.phoneNum];
    self.tipLabel.textColor = [UIColor grayColor];
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:self.tipLabel.text];
    NSUInteger firstLoc = [[noteStr string] rangeOfString:@"向"].location + 1;
    NSUInteger secondLoc = [[noteStr string] rangeOfString:@"发"].location;
    NSRange range = NSMakeRange(firstLoc, secondLoc - firstLoc);
    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range];
    [noteStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20] range:range];
    [self.tipLabel setAttributedText:noteStr];
    if (self.isPayVerify) {
        self.resetTitleLabel.text = @"重置支付密码";
        self.resetTitleLabel.hidden = NO;
    }
    [self Countdown];
    for (int i = 1; i < 7; i++) {
        UITextView *tf = (UITextView *)[self.view viewWithTag:i];
        [tf resignFirstResponder];
        [tf.layer setBorderWidth:1.0];
        [tf.layer setBorderColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1].CGColor];
        tf.font = [UIFont fontWithName:@"DIN Alternate" size:20];
        tf.tintColor = [UIColor colorWithRed:47/255.0 green:130/255.0 blue:200/255.0 alpha:1];

    }
    UITextView *tf = (UITextView *)[self.view viewWithTag:1];
    [tf becomeFirstResponder];
    [tf.layer setBorderWidth:1.0];
    [tf.layer setBorderColor:[UIColor colorWithRed:47/255.0 green:130/255.0 blue:200/255.0 alpha:1].CGColor];
}

- (void) request
{
    __weak __typeof(self) weakSelf = self;
    NSDictionary *dic = @{@"phone": self.phone};
    [[NetworkTool sharedTool] requestWithURLString:@"SMSVerification/Verification" parameters:dic method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@",stringData, JSON );
        //        NSString *isError = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
//            [weakSelf verifyPass];
//            _captchaString = [JSON objectForKey:@"Data"];
        } else {
            [weakSelf performSelectorOnMainThread:@selector(showToastWithMessage:) withObject:[JSON objectForKey:@"msg"] waitUntilDone:YES];
        }
    } failed:^(NSError *error) {
        [weakSelf requestError];
    }];
}

- (void) requestCode : (NSString *)string
{
    __weak __typeof(self) weakSelf = self;
    NSDictionary *dic = @{@"phone": self.phone, @"sms":string};
    [[NetworkTool sharedTool] requestWithURLString:@"verifySMS/verifySMS" parameters:dic method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@",stringData, JSON );
        //        NSString *isError = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            //            [weakSelf verifyPass];
            [weakSelf performSelectorOnMainThread:@selector(verify:) withObject:@"1" waitUntilDone:YES];
        } else {
            [weakSelf performSelectorOnMainThread:@selector(verify:) withObject:@"0" waitUntilDone:YES];
        }
    } failed:^(NSError *error) {
        [weakSelf requestError];
    }];
}

- (void) requestLogin
{
    __weak __typeof(self) weakSelf = self;
    NSString *uuid = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSString *string = [self md5:self.password];
    NSDictionary *dic = @{@"phone": self.phone, @"pwd" : string, @"mac" : uuid};
    [[NetworkTool sharedTool] requestWithURLString:@"userLogin/verifyLanding" parameters:dic method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@",stringData, JSON );
        //        NSString *isError = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            [weakSelf performSelectorOnMainThread:@selector(login) withObject:nil waitUntilDone:YES];
        } else {
            [weakSelf performSelectorOnMainThread:@selector(showToastWithMessage:) withObject:[JSON objectForKey:@"msg"] waitUntilDone:YES];
        }
    } failed:^(NSError *error) {
        //        [weakSelf requestError];
        NSLog(@"jalskdjfashdflasdkfhasdf");
    }];
}

- (void) verify : (NSString *)string
{
    if ([string isEqualToString:@"1"]) {
        _isS = YES;
        //验证码通过
        if (self.isVerify) {
            [self requestLogin];
            return;
        }
        if (self.isReset) {
            ResetPasswordViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ResetPasswordVC"];
            vc.phoneNum   = self.phoneNum;
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        if (self.isPayVerify) {
            SetPayPassWordViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SetPayPassWordVC"];
            vc.isVerify = YES;
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        if (self.isRun) {
            [self.delegate verifySuccessWithCode:_captchaString];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        
        SetPasswordViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SetPasswordVC"];
        vc.phoneNum = self.phoneNum;
        vc.phone = self.phone;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        self.errorLabel.hidden = NO;
        [self rewriteCaptcha];
    }
}

- (void) login
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"YES" forKey:@"isLogin"];
    [defaults setObject:self.phone forKey:@"phoneNum"];
    [defaults synchronize];
    
    NSString *string = @"登录密码设置成功";
    if (self.isVerify) {
        string = @"登录成功";
    }
    ToastView *messageView = [[ToastView alloc]initWithFrame:self.view.bounds WithMessage:string];
    [self.view addSubview:messageView];
    
    double delayInSeconds = 1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_global_queue(0,0), ^(void){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
    });
}


- (void)textViewDidChange:(UITextView *)textView
{
    self.errorLabel.hidden = YES;

    if (_isS) {
        return;
    }
    
    if (textView.text.length > 0) {
        textView.text = [textView.text substringToIndex:1];
    }
    int x = 0;
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"a", @"a", @"a", @"a", @"a", @"a", nil];
    for (int i = 1; i < 7; i++) {
        UITextView *tf = (UITextView *)[self.view viewWithTag:i];
        if (tf.text.length>0) {
            x++;
            [array replaceObjectAtIndex:i-1 withObject:tf.text];
            // 验证输入的验证码
            if (x == 6) {
                NSLog(@"%@", array);
                NSString *string = [array componentsJoinedByString:@""];
                
            }
            continue;
        } else {
            if (textView.text.length < 1) {
                continue;
            }
            [textView.layer setBorderWidth:1.0];
            [textView.layer setBorderColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1].CGColor];
            NSInteger x = 0;
            if (textView.tag == 6) {
                x = 0;
            } else {
                x = textView.tag;
            }
            UITextView *tv = (UITextView *)[self.view viewWithTag:x+1];
            [tv becomeFirstResponder];
            [tv.layer setBorderWidth:1.0];
            [tv.layer setBorderColor:[UIColor colorWithRed:47/255.0 green:130/255.0 blue:200/255.0 alpha:1].CGColor];
        }
    }
    
    [array replaceObjectAtIndex:textView.tag-1 withObject:textView.text];
    if (![array containsObject:@"a"]) {
        [self requestCode:[array componentsJoinedByString:@""]];
    }

}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSInteger x = textView.tag;
    if (x == 1) {
        x = 7;
    }
    if ([text isEqualToString:@""]) {
        UITextView *tv = (UITextView *)[self.view viewWithTag:x-1];
        tv.text = @"";
        textView.text = @"";
        [tv becomeFirstResponder];
    }
    return YES;
}

- (void) rewriteCaptcha
{
    for (int i = 1; i < 7; i++) {
        UITextView *tf = (UITextView *)[self.view viewWithTag:i];
        [tf.layer setBorderWidth:1.0];
        [tf.layer setBorderColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1].CGColor];
        tf.text = @"";
    }
    UITextView *textView = (UITextView *)[self.view viewWithTag:1];
    [textView.layer setBorderWidth:1.0];
    [textView.layer setBorderColor:[UIColor colorWithRed:47/255.0 green:130/255.0 blue:200/255.0 alpha:1].CGColor];
    [textView becomeFirstResponder];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    for (int i = 1; i < 7; i++) {
        UITextView *tf = (UITextView *)[self.view viewWithTag:i];
        [tf.layer setBorderWidth:1.0];
        [tf.layer setBorderColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1].CGColor];
    }
    [textView.layer setBorderWidth:1.0];
    [textView.layer setBorderColor:[UIColor colorWithRed:47/255.0 green:130/255.0 blue:200/255.0 alpha:1].CGColor];
}

- (void) Countdown
{
    self.reSandBtn.hidden = YES;
    self.countDownLabel.hidden = NO;
    _secondsCountDown = 60;
    _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES]; //启动倒计时后会每秒钟调用一次方法 timeFireMethod
    self.countDownLabel.text = @"收短信大约需要60秒";
}

-(void)timeFireMethod{
    _secondsCountDown--;
    if(_secondsCountDown==0){
        [_countDownTimer invalidate];
        _countDownTimer = nil;
        self.reSandBtn.hidden = NO;
        self.countDownLabel.hidden = YES;
        return;
    }
    [self changeTipLabel];
}

- (void) changeTipLabel
{
    self.countDownLabel.text=[NSString stringWithFormat:@"收短信大约需要%d秒",_secondsCountDown];
}

- (IBAction)reSandBtnClick:(id)sender {
    [self Countdown];
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for (int i = 1; i < 7; i++) {
        UITextView *tf = (UITextView *)[self.view viewWithTag:i];
        [tf resignFirstResponder];
    }
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
