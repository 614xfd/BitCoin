//
//  BalanceViewController.m
//  BitCoin
//
//  Created by LBH on 2018/5/22.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "BalanceViewController.h"
#import "ExtractViewController.h"
#import "RechargeViewController.h"

@interface BalanceViewController ()

@end

@implementation BalanceViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setBarBlackColor:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self.coinName isEqualToString:@"USDT"]) {
        self.coinImage.image = [UIImage imageNamed:@"钱包1_03.png"];
    }
    self.titleLabel.text = self.coinName;
    self.nameLabel.text = [NSString stringWithFormat:@"%@余额(%@)", self.coinName, self.coinName];
    [self request];

}

- (void) setBalance:(NSArray *)array
{
    for (NSDictionary *dic in array) {
        if ([[[dic objectForKey:@"type"] uppercaseString] isEqualToString:self.coinName]) {
            self.balanceLabel.text = [NSString stringWithFormat:@"%.2lf", [[dic objectForKey:@"balance"] doubleValue]];
        }
    }
}

- (void) request
{
//    NSString *url = @"UserAccount/bbc";
//    if ([self.coinName isEqualToString:@"USDT"]) {
//        url = @"UserAccount/usdt";
//    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uid = [defaults objectForKey:@"uid"];
    if (uid.length) {
        __weak __typeof(self) weakSelf = self;
        NSDictionary *d = @{@"uid":uid};
        [[NetworkTool sharedTool] requestWithURLString:@"UserAccount/getUserBalance" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
            NSLog(@"%@      ------------- %@", stringData, JSON );
            NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
            if ([code isEqualToString:@"1"]) {
                //            NSString *string = @"";
                //            if ([self.coinName isEqualToString:@"BBC"]) {
                //                double x = [[[JSON objectForKey:@"Dada"] objectForKey:@"BBC_balance"] doubleValue] + [[[JSON objectForKey:@"Dada"] objectForKey:@"BBC_share"] doubleValue];
                //                string = [NSString stringWithFormat:@"%.2lf", x];
                //            } else {
                //                string = [NSString stringWithFormat:@"%.2lf", [[JSON objectForKey:@"Data"] doubleValue]];
                //            }
                NSArray *array = [NSArray arrayWithArray:[JSON objectForKey:@"Data"]];
                [weakSelf performSelectorOnMainThread:@selector(setBalance:) withObject:array waitUntilDone:YES];
            } else {
                
            }
        } failed:^(NSError *error) {
            //        [weakSelf requestError];
        }];
    }
    
//    [[NetworkTool sharedTool] requestWithHPURLString:@"http://192.168.0.109:8080/Bitboss/UserAccount/getUserBalance" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
//        NSLog(@"%@      ------------- %@", stringData, JSON );
//        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
//        if ([code isEqualToString:@"1"]) {
//            NSString *string = @"";
////            if ([self.coinName isEqualToString:@"BBC"]) {
////                double x = [[[JSON objectForKey:@"Dada"] objectForKey:@"BBC_balance"] doubleValue] + [[[JSON objectForKey:@"Dada"] objectForKey:@"BBC_share"] doubleValue];
////                string = [NSString stringWithFormat:@"%.2lf", x];
////            } else {
////                string = [NSString stringWithFormat:@"%.2lf", [[JSON objectForKey:@"Data"] doubleValue]];
////            }
////            [weakSelf performSelectorOnMainThread:@selector(setBalance:) withObject:string waitUntilDone:YES];
//        } else {
//
//        }
//    } failed:^(NSError *error) {
//        //        [weakSelf requestError];
//    }];
}

- (IBAction)rechargeBtnClick:(id)sender {
//    if ([self.coinName isEqualToString:@"BBC"]) {
//        return;
//    }
    
    RechargeViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RechargeVC"];
    vc.coinName = self.coinName;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)extractBtnClick:(id)sender {
    if ([self.coinName isEqualToString:@"ETH"]) {
        return;
    }
    ExtractViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ExtractVC"];
    vc.count = [self.balanceLabel.text doubleValue];
    vc.coinName = self.coinName;
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
