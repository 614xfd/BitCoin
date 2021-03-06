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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEditChanged:) name:UITextFieldTextDidChangeNotification object:self.numTF];

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
    if ([self.numTF.text doubleValue]<1) {
        [self showToastWithMessage:@"请输入提币数量"];
        return;
    }
    if (self.contentTF.text.length<1) {
        [self showToastWithMessage:@"请填写备注"];
        return;
    }
    __weak __typeof(self) weakSelf = self;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    if (token.length) {
        NSDictionary *d = @{@"token":token, @"toAddress":self.addressTF, @"count":self.numTF.text, @"mark":self.contentTF.text};
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
    self.coinNumLabel.text = [NSString stringWithFormat:@"%.2lf GTSE", [_bbcBalance doubleValue]-5];
}

-(void)textFieldEditChanged:(NSNotification *)obj
{
    UITextField *tf = obj.object;
    if (tf ==self.numTF) {
        if ([tf.text doubleValue]>[_bbcBalance doubleValue]-5) {
            tf.text = [NSString stringWithFormat:@"%.2lf", [_bbcBalance doubleValue]-5];
        }
    }
}
- (IBAction)upData:(id)sender {
    if (self.addressTF.text.length>0&&[self.numTF.text doubleValue]>0) {
        [self requestOUT];
    }
}
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.numTF resignFirstResponder];
    [self.addressTF resignFirstResponder];
    [self.contentTF resignFirstResponder];
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
