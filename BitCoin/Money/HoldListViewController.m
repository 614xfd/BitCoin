//
//  HoldListViewController.m
//  BitCoin
//
//  Created by LBH on 2018/9/21.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "HoldListViewController.h"
#import "MoneyInfoViewController.h"
#import "HoldMoneyViewController.h"
#import "LoginViewController.h"

@interface HoldListViewController () {
    NSDictionary *_dic_3;
    NSDictionary *_dic_6;
    NSDictionary *_dic_12;
    NSString *_day;
    NSString *_time;
}

@end

@implementation HoldListViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setBarBlackColor:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _day = @"90";
    _time = @"三月";
    [self requestRate];
}

- (void) requestRate
{
    __weak __typeof(self) weakSelf = self;
    [[NetworkTool sharedTool] requestWithURLString:@"financingType/list" parameters:nil method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@", stringData, JSON );
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            weakSelf.dataArray = [NSArray arrayWithArray:[JSON objectForKey:@"data"]];
            [weakSelf performSelectorOnMainThread:@selector(setRate) withObject:nil waitUntilDone:YES];
        } else {
        }
    } failed:^(NSError *error) {
        //        [weakSelf requestError];
    }];
}

- (void) setRate
{
    for (NSDictionary *dic in self.dataArray) {
        NSString *type = [NSString stringWithFormat:@"%@", [dic objectForKey:@"type"]];
        if ([type isEqualToString:@"3"]) {
            self.rete_3.text = [NSString stringWithFormat:@"%.2lf%%", [[dic objectForKey:@"rate"] doubleValue]];
            _dic_3 = [NSDictionary dictionaryWithDictionary:dic];
        } else if ([type isEqualToString:@"6"]) {
            self.rate_6.text = [NSString stringWithFormat:@"%.2lf%%", [[dic objectForKey:@"rate"] doubleValue]];
            _dic_6 = [NSDictionary dictionaryWithDictionary:dic];
        } else if ([type isEqualToString:@"12"]) {
            self.rate_12.text = [NSString stringWithFormat:@"%.2lf%%", [[dic objectForKey:@"rate"] doubleValue]];
            _dic_12 = [NSDictionary dictionaryWithDictionary:dic];
        }
    }
}


- (IBAction)rate3BtnClick:(id)sender {
    _day = @"90";
    _time = @"三月";
    [self intoHold:_dic_3];
}
- (IBAction)rate6BtnClick:(id)sender {
    _day = @"180";
    _time = @"六月";
    [self intoHold:_dic_6];
}
- (IBAction)rate12BtnClick:(id)sender {
    _day = @"360";
    _time = @"一年";
    [self intoHold:_dic_12];
}

- (void) intoHold:(NSDictionary *)dic
{
    MoneyInfoViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MoneyInfoVC"];
    vc.day = _day;
    vc.time = _time;
    vc.rate = [dic objectForKey:@"rate"];
    vc.idString = [dic objectForKey:@"id"];
    vc.type = [dic objectForKey:@"type"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)my:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    if (!token) {
        LoginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    HoldMoneyViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HoldMoneyVC"];
    [self.navigationController pushViewController:vc animated:YES];
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
