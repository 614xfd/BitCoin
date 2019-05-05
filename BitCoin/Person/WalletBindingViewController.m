//
//  WalletBindingViewController.m
//  BitCoin
//
//  Created by mac on 2019/4/20.
//  Copyright © 2019 LBH. All rights reserved.
//

#import "WalletBindingViewController.h"
#import "QRCodeViewController.h"

@interface WalletBindingViewController ()<QRCodeViewControllerDelegate>

@end

@implementation WalletBindingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) requestAdd
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    __weak __typeof(self) weakSelf = self;
    NSDictionary *d = @{@"token":token,@"address":self.textField.text};
    [[NetworkTool sharedTool] requestWithURLString:@"/v1/digit/address/add" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@", stringData, JSON );
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            
            [self showToastWithMessage:@"小蚂蚁：绑定地址成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            
        }
    } failed:^(NSError *error) {
    }];
    
}

- (IBAction)scanTap:(id)sender {
    QRCodeViewController *qrcodeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"qrcodeview"];
    qrcodeVC.delegate = self;
    [self.navigationController pushViewController:qrcodeVC animated:YES];
}
- (IBAction)bandingBtnClick:(id)sender {
    [self requestAdd];
}

- (void) returnString:(NSString *)string{
    
    if (string) {
        self.textField.text = string;
    }
}
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textField resignFirstResponder];
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
