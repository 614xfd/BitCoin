//
//  SafeViewController.m
//  BitCoin
//
//  Created by LBH on 2018/5/22.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "SafeViewController.h"
#import "ReSetLoginPWViewController.h"
#import "SetPayPassWordViewController.h"
#import "ReSetPayPasswordViewController.h"

@interface SafeViewController () {
    NSString *_status;
    NSString *_paymentPasswordStatus;
}

@end

@implementation SafeViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setBarBlackColor:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _status = [defaults objectForKey:@"authenticationStatus"];
    _paymentPasswordStatus = [defaults objectForKey:@"paymentPasswordStatus"];
    if ([_paymentPasswordStatus isEqualToString:@"0"]) {
        self.payPWLabel.text = @"设置支付密码";
    } else {
        self.payPWLabel.text = @"重置支付密码";
    }
    if ([_status isEqualToString:@"0"]) {
        self.tipLabel.text = @"请先实名认证";
    } else {
        self.tipLabel.text = @"已实名认证";
    }
}
- (void)resetMessage:(NSString *)string
{
    self.tipLabel.text = @"已实名认证";
}

- (IBAction)payBtnClick:(id)sender {
//    if ([_status isEqualToString:@"0"]) {
//        RealNameViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RealNameVC"];
//        vc.delegate = self;
//        [self.navigationController pushViewController:vc animated:YES];
//    } else {
    

    
        if ([_paymentPasswordStatus isEqualToString:@"1"] | YES) {
//
            self.dustView.alpha = 0.4;
            self.tipView.alpha = 1;
        } else {
            SetPayPassWordViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SetPayPassWordVC"];
            [self.navigationController pushViewController:vc animated:YES];
        }
//    }
}
- (IBAction)resetLoginBtnClick:(id)sender {
    ReSetLoginPWViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ReSetLPWVC"];
    vc.isReSet = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)tipCancel:(id)sender {
    self.dustView.alpha = 0;
    self.tipView.alpha = 0;
}

- (IBAction)typeReset:(id)sender {
    self.dustView.alpha = 0;
    self.tipView.alpha = 0;
//    ReSetPayPasswordViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ReSetPayPasswordVC"];
//    [self.navigationController pushViewController:vc animated:YES];
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
