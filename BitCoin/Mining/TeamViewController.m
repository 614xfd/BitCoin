//
//  TeamViewController.m
//  BitCoin
//
//  Created by CCC on 2019/4/20.
//  Copyright © 2019年 LBH. All rights reserved.
//

#import "TeamViewController.h"

@interface TeamViewController ()

@end

@implementation TeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self requestPeople];
    [self requestcount];
    [self requestcoin];
}

- (void) setpeopel:(NSString *)string
{
    self.peopei.text = [NSString stringWithFormat:@"%@ 人", string];

}

- (void) setcountL:(NSString *)string
{
    self.count.text = [NSString stringWithFormat:@"%@ 台服务器", string];

}

- (void) setcoin :(NSString *) stirng
{
    self.coin.text = [NSString stringWithFormat:@"%@ GTSE", stirng];
}

- (void) requestPeople
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    __weak __typeof(self) weakSelf = self;
    if (token.length) {
        NSDictionary *d = @{@"token":token};
        [[NetworkTool sharedTool] requestWithURLString:@"v1/user/user/pushCount" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
            NSLog(@"%@      ------------- %@", stringData, JSON );
            NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
            if ([code isEqualToString:@"1"]) {
                [weakSelf performSelectorOnMainThread:@selector(setpeopel:) withObject:[NSString stringWithFormat:@"%@", [JSON objectForKey:@"data"]] waitUntilDone:YES];
            }
            
        } failed:^(NSError *error) {
            //        [weakSelf requestError];
        }];
    }
}

- (void) requestcount
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    __weak __typeof(self) weakSelf = self;
    if (token.length) {
        NSDictionary *d = @{@"token":token};
        [[NetworkTool sharedTool] requestWithURLString:@"v1/user/user/machines" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
            NSLog(@"%@      ------------- %@", stringData, JSON );
            NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
            if ([code isEqualToString:@"1"]) {
                [weakSelf performSelectorOnMainThread:@selector(setcountL:) withObject:[NSString stringWithFormat:@"%@", [JSON objectForKey:@"data"]] waitUntilDone:YES];
            }
            
        } failed:^(NSError *error) {
            //        [weakSelf requestError];
        }];
    }
}

- (void) requestcoin
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    __weak __typeof(self) weakSelf = self;
    if (token.length) {
        NSDictionary *d = @{@"token":token};
        [[NetworkTool sharedTool] requestWithURLString:@"v1/user/user/jiCha" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
            NSLog(@"%@      ------------- %@", stringData, JSON );
            NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
            if ([code isEqualToString:@"1"]) {
                [weakSelf performSelectorOnMainThread:@selector(setcoin:) withObject:[NSString stringWithFormat:@"%@", [JSON objectForKey:@"data"]] waitUntilDone:YES];
            }
            
        } failed:^(NSError *error) {
            //        [weakSelf requestError];
        }];
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
