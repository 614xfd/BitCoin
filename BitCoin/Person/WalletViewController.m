//
//  WalletViewController.m
//  BitCoin
//
//  Created by LBH on 2017/11/15.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import "WalletViewController.h"
#import "BalanceViewController.h"
#import "HistoryViewController.h"
#import "WalletDetailViewController.h"
#import "CoinINViewController.h"
#import "CoinOUTViewController.h"
#import "SafeViewController.h"

@interface WalletViewController ()

@end

@implementation WalletViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setBarBlackColor:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.tableFooterView = [[UIView alloc] init];

    [self request];
}

- (void) setMoney:(NSString *)string
{
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2lf", [string doubleValue]];
}

- (void) setMoneyWithDic : (NSDictionary *)dic
{
    self.normalLab.text = [NSString stringWithFormat:@"%.4lf", [dic[@"normal"] doubleValue]];
    self.freezeLab.text = [NSString stringWithFormat:@"%.4lf", [dic[@"freeze"] doubleValue]];
    
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    //            [defaults setObject:dic[@"last"] forKey:@"GTSE_Price"];
    CGFloat normal = [dic[@"normal"] floatValue];
    CGFloat freeze = [dic[@"freeze"] floatValue];
    CGFloat  maney = (normal + freeze) * [[ud objectForKey:@"GTSE_Price"] floatValue];
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2lf",maney];
}

- (void) request
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    __weak __typeof(self) weakSelf = self;
    NSDictionary *d = @{@"token":token};
    [[NetworkTool sharedTool] requestWithURLString:@"/v1/user/account/info" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@", stringData, JSON );
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            
            NSDictionary *data = JSON[@"data"];
            [weakSelf performSelectorOnMainThread:@selector(setMoneyWithDic:) withObject:data waitUntilDone:YES];

        } else {

        }
    } failed:^(NSError *error) {
    }];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"walletcell" forIndexPath:indexPath];

    UILabel *type = (UILabel *) [cell viewWithTag:1];
    type.text = [[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"type"] uppercaseString];
    
    UILabel *freeze = (UILabel *) [cell viewWithTag:2];
    freeze.text = [NSString stringWithFormat:@"%.2lf", [[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"balance"] doubleValue]];
    UILabel *balance = (UILabel *) [cell viewWithTag:3];
    balance.text = [NSString stringWithFormat:@"%.2lf", [[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"freeze"] doubleValue]];


    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *string = [[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"type"] uppercaseString];
    BalanceViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BalanceVC"];
    vc.coinName = string;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)historyBtnClick:(id)sender {
    HistoryViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HistoryVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)cbBtnClick:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    if (token.length) {
        CoinINViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CoinINVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (IBAction)tbBtnClick:(id)sender {
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    if (token.length) {
        NSString *authenticationStatus = [defaults objectForKey:@"authenticationStatus"];
        if (![authenticationStatus isEqualToString:@"2"]) {
            [self showToastWithMessage:@"请先完成实名认证"];
            return;
        }
        CoinOUTViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CoinOUTVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (IBAction)bindingSiteBtnClick:(id)sender {
}
- (IBAction)detailBtnClick:(id)sender {
    WalletDetailViewController *vc = [[WalletDetailViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];

}
- (IBAction)pwdBtnClick:(id)sender {
    SafeViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SafeVC"];
    vc.isWallet = YES;
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
