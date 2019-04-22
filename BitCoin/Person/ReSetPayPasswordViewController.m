//
//  ReSetPayPasswordViewController.m
//  BitCoin
//
//  Created by LBH on 2017/11/9.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import "ReSetPayPasswordViewController.h"
#import "SetPayPassWordViewController.h"
#import "CaptchaViewController.h"

@interface ReSetPayPasswordViewController ()

@end

@implementation ReSetPayPasswordViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setBarBlackColor:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *phoneNum = [defaults objectForKey:@"phoneNum"];
    self.phoneNumLabel.text = phoneNum;
    
    [self.forgetBtn.layer setBorderWidth:1.0];
    [self.forgetBtn.layer setBorderColor:[UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1].CGColor];
    [self.forgetBtn.layer setMasksToBounds:YES];
    self.forgetBtn.layer.cornerRadius = 4;
    [self.rememberBtn.layer setMasksToBounds:YES];
    self.rememberBtn.layer.cornerRadius = 4;
}
- (IBAction)forgetBtnClick:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *phoneNum = [defaults objectForKey:@"phoneNum"];
    CaptchaViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CaptchaVC"];
    vc.phoneNum = phoneNum;
    vc.phone = phoneNum;
    vc.isPayVerify = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)rememberBtnClick:(id)sender {
    SetPayPassWordViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SetPayPassWordVC"];
    vc.isReset = YES;
    vc.tipString = @"输入支付密码，完成身份验证";
    [self.navigationController pushViewController:vc animated:YES];
}
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
