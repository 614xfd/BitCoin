//
//  CoinINViewController.m
//  BitCoin
//
//  Created by LBH on 2019/4/22.
//  Copyright © 2019年 LBH. All rights reserved.
//

#import "CoinINViewController.h"
#import "CreatQRCode.h"

@interface CoinINViewController () {
    NSString *_address;
}

@end

@implementation CoinINViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self request];
}

- (void) request
{
    __weak __typeof(self) weakSelf = self;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    if (token.length) {
        NSDictionary *d = @{@"token":token};
        [[NetworkTool sharedTool] requestWithURLString:@"v1/param/recharge" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
            NSLog(@"%@      ------------- %@", stringData, JSON );
            NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
            if ([code isEqualToString:@"1"]) {
                NSLog(@"");
                _address = [JSON objectForKey:@"data"];
                [weakSelf performSelectorOnMainThread:@selector(setAddress) withObject:nil waitUntilDone:YES];
            } else {
               
            }
        } failed:^(NSError *error) {
            //        [weakSelf requestError];
        }];
    }
}

- (void) requestIN
{
    if (self.contentTF.text.length<1) {
        [self showToastWithMessage:@"请填写备注"];
        return;
    }
    __weak __typeof(self) weakSelf = self;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    if (token.length) {
        NSDictionary *d = @{@"token":token, @"fromAddress":self.addressTF.text, @"toAddress":_address, @"count":self.numTF.text, @"mark":self.contentTF.text};
        [[NetworkTool sharedTool] requestWithURLString:@"v1/user/recharge/add" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
            NSLog(@"%@      ------------- %@", stringData, JSON );
            NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
            if ([code isEqualToString:@"1"]) {
                NSLog(@"");
                [weakSelf performSelectorOnMainThread:@selector(success) withObject:nil waitUntilDone:YES];
            } else {
                [weakSelf performSelectorOnMainThread:@selector(showToastWithMessage:) withObject:[JSON objectForKey:@"msg"] waitUntilDone:YES];
            }
        } failed:^(NSError *error) {
            //        [weakSelf requestError];
        }];
    }
}

- (void) success
{
    [self showToastWithMessage:@"充值成功"];
    double delayInSeconds = 1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_global_queue(0,0), ^(void){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    });
}

- (void) setAddress{
    self.addressImageView.image = [CreatQRCode qrImageForString:_address imageSize:356 logoImageSize:0];
    self.addressLabel.text = _address;
}

- (IBAction)upData:(id)sender {
    if (self.addressTF.text.length>0&&[self.numTF.text doubleValue]>0) {
        [self requestIN];
    } else {
        [self showToastWithMessage:@"请输入地址和数量。"];
    }
}
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)copy:(id)sender {
    UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
    pastboard.string = _address;
    [self showToastWithMessage:@"复制成功"];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.numTF resignFirstResponder];
    [self.addressTF resignFirstResponder];
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
