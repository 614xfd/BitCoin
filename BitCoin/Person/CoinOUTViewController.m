//
//  CoinOUTViewController.m
//  BitCoin
//
//  Created by LBH on 2019/4/23.
//  Copyright © 2019年 LBH. All rights reserved.
//

#import "CoinOUTViewController.h"

@interface CoinOUTViewController () {
    NSString *_bbcBalance;
}

@end

@implementation CoinOUTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self requestBalance];
}

- (void) requestBalance
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    if (token.length) {
        __weak __typeof(self) weakSelf = self;
        NSDictionary *d = @{@"token":token};
        [[NetworkTool sharedTool] requestWithURLString:@"v1/user/account/info" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
            NSLog(@"%@      ------------- %@", stringData, JSON );
            NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
            if ([code isEqualToString:@"1"]) {
                _bbcBalance = [NSString stringWithFormat:@"%.2lf", [[[JSON objectForKey:@"data"] objectForKey:@"normal"] doubleValue]];
                [weakSelf performSelectorOnMainThread:@selector(creatBalance) withObject:nil waitUntilDone:YES];
            } else {
                
            }
        } failed:^(NSError *error) {
            //        [weakSelf requestError];
        }];
    }
}

- (void) requestOUT
{
    __weak __typeof(self) weakSelf = self;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    if (token.length) {
        NSDictionary *d = @{@"token":token, @"toAddress":self.addressTF, @"count":self.numTF.text};
        [[NetworkTool sharedTool] requestWithURLString:@"v1/user/withdraw/add" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
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
    [self showToastWithMessage:@"提交成功，等待审核"];
    double delayInSeconds = 1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_global_queue(0,0), ^(void){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    });
}

- (void) creatBalance
{
    self.coinNumLabel.text = [NSString stringWithFormat:@"%@ GTSE", _bbcBalance];
}

- (IBAction)upData:(id)sender {
    if (self.addressTF.text.length>0&&[self.numTF.text doubleValue]>0) {
        
    }
}
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
