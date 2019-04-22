//
//  SetPayPassWordViewController.m
//  BitCoin
//
//  Created by LBH on 2017/11/9.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import "SetPayPassWordViewController.h"
#import "CaptchaViewController.h"

@interface SetPayPassWordViewController () {
    BOOL _isS;
    int _sum;
}

@end

@implementation SetPayPassWordViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _isS = NO;
    for (int i = 1; i < 7; i++) {
        UITextView *tf = (UITextView *)[self.view viewWithTag:i];
        tf.text = @"";
    }
    UITextView *tf = (UITextView *)[self.view viewWithTag:1];
    [tf becomeFirstResponder];
    [self setBarBlackColor:YES];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isS = NO;
    _sum = 3;
    UITextView *tf = (UITextView *)[self.view viewWithTag:1];
    [tf becomeFirstResponder];
    
    if (self.isReset) {
        self.tipLabel.text = self.tipString;
        self.titleLabel.text = @"重置支付密码";
    }
}

- (void) request
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *phoneNum = [defaults objectForKey:@"phoneNum"];
    NSString *password = [self md5:[self.numArray componentsJoinedByString:@""]];
    __weak __typeof(self) weakSelf = self;
    NSDictionary *d = @{@"phone":phoneNum, @"paymentPassword":password};
    [[NetworkTool sharedTool] requestWithURLString:@"PaymentPassword/addPaymentPassword" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@", stringData, JSON );
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
           
            [weakSelf performSelectorOnMainThread:@selector(success) withObject:nil waitUntilDone:YES];
        } else {
            
        }
    } failed:^(NSError *error) {
        //        [weakSelf requestError];
    }];
}

- (void) success
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"1" forKey:@"paymentPasswordStatus"];
    [self showToastWithMessage:@"支付密码设置成功"];
    double delayInSeconds = 1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_global_queue(0,0), ^(void){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
    });
}

- (void) verify : (NSString *)ps
{
    _sum--;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *phoneNum = [defaults objectForKey:@"phoneNum"];
    NSString *password = [self md5:ps];
    __weak __typeof(self) weakSelf = self;
    NSDictionary *d = @{@"phone":phoneNum, @"paymentPassword":password};
    [[NetworkTool sharedTool] requestWithURLString:@"PaymentPassword/checkPay" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@", stringData, JSON );
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            
            [weakSelf performSelectorOnMainThread:@selector(verifySuccess:) withObject:ps waitUntilDone:YES];
        } else {
            [weakSelf performSelectorOnMainThread:@selector(psError) withObject:nil waitUntilDone:YES];
        }
    } failed:^(NSError *error) {
        //        [weakSelf requestError];
    }];
}

- (void) verifySuccess : (NSString *)string
{
    [self showToastWithMessage:@"支付密码验证成功"];
    double delayInSeconds = 1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_global_queue(0,0), ^(void){
        dispatch_async(dispatch_get_main_queue(), ^{
            SetPayPassWordViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SetPayPassWordVC"];
            vc.original = string;
            vc.isNewPayPW = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        });
    });
    
}

- (void) psError
{
    if (_sum == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"支付密码已被锁定，请3小时后再试。若您想立即解锁，请点击重置密码" delegate:self cancelButtonTitle:@"重置密码" otherButtonTitles:@"取消", nil];
        [alert show];
        return;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"支付密码不正确，您还可以输入%d次", _sum] delegate:self cancelButtonTitle:@"忘记密码" otherButtonTitles:@"重新输入", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        for (int i = 1; i < 7; i++) {
            UITextView *tf = (UITextView *)[self.view viewWithTag:i];
            tf.text = @"";
        }
        UITextView *tf = (UITextView *)[self.view viewWithTag:1];
        [tf becomeFirstResponder];
    } else {
        for (int i = 1; i < 7; i++) {
            UITextView *tf = (UITextView *)[self.view viewWithTag:i];
            [tf resignFirstResponder];
        }
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *phoneNum = [defaults objectForKey:@"phoneNum"];
        CaptchaViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CaptchaVC"];
        vc.phoneNum = phoneNum;
        vc.phone = phoneNum;
        vc.isPayVerify = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void) requestWithNewPayPW
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *phoneNum = [defaults objectForKey:@"phoneNum"];
    NSString *password = [self md5:[self.numArray componentsJoinedByString:@""]];
    NSString *s = [self md5:self.original];
    __weak __typeof(self) weakSelf = self;
    NSDictionary *d = @{@"phone":phoneNum, @"newPaymentPassword":password, @"paymentPassword":s};
    [[NetworkTool sharedTool] requestWithURLString:@"PaymentPassword/addPaymentPassword" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@", stringData, JSON );
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            
            [weakSelf performSelectorOnMainThread:@selector(success) withObject:nil waitUntilDone:YES];
        } else {
            
        }
    } failed:^(NSError *error) {
        //        [weakSelf requestError];
    }];
}

- (void)textViewDidChange:(UITextView *)textView
{
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
            if (x == 6) {
                NSLog(@"%@", array);
                // 验证支付密码
                if (self.isReset) {
                    [self verify:[array componentsJoinedByString:@""]];
                } else {
                    // 验证两次输入的支付密码
                    if (self.numArray.count) {
                        NSString *number = [self.numArray componentsJoinedByString:@""];
                        NSString *string = [array componentsJoinedByString:@""];
                        if ([string isEqualToString:number]) {
                            _isS = YES;
                            //验证通过
                            if (self.isNewPayPW) {
                                
                                return;
                            }
                            if(self.isVerify) {
                                
                                return;
                            }
                            [self request];
                        } else {
                            [self showToastWithMessage:@"两次密码输入不一致，请重新输入"];
                            double delayInSeconds = 2;
                            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                            dispatch_after(popTime, dispatch_get_global_queue(0,0), ^(void){
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self.navigationController popViewControllerAnimated:YES];
                                });
                            });
                        }
                    } else {
                        SetPayPassWordViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SetPayPassWordVC"];
                        vc.numArray = [NSArray arrayWithArray:array];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                }
            }
            continue;
        } else {
            if (textView.text.length < 1) {
                continue;
            }
            NSInteger y = 0;
            if (textView.tag == 6) {
                y = 0;
            } else {
                y = textView.tag;
            }
            UITextView *tv = (UITextView *)[self.view viewWithTag:y+1];
            [tv becomeFirstResponder];
        }
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

//- (void) rewriteCaptcha
//{
//    for (int i = 1; i < 7; i++) {
//        UITextView *tf = (UITextView *)[self.view viewWithTag:i];
//        [tf.layer setBorderWidth:1.0];
//        [tf.layer setBorderColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1].CGColor];
//        tf.text = @"";
//    }
//    UITextView *textView = (UITextView *)[self.view viewWithTag:1];
//    [textView.layer setBorderWidth:1.0];
//    [textView.layer setBorderColor:[UIColor colorWithRed:47/255.0 green:130/255.0 blue:200/255.0 alpha:1].CGColor];
//    [textView becomeFirstResponder];
//}

//- (void)textViewDidBeginEditing:(UITextView *)textView
//{
//    for (int i = 1; i < 7; i++) {
//        UITextView *tf = (UITextView *)[self.view viewWithTag:i];
//        [tf.layer setBorderWidth:1.0];
//        [tf.layer setBorderColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1].CGColor];
//    }
//    [textView.layer setBorderWidth:1.0];
//    [textView.layer setBorderColor:[UIColor colorWithRed:47/255.0 green:130/255.0 blue:200/255.0 alpha:1].CGColor];
//}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
