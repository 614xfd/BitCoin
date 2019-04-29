//
//  NewPersonHomeViewController.m
//  BitCoin
//
//  Created by CCC on 2019/4/23.
//  Copyright © 2019年 LBH. All rights reserved.
//

#import "NewPersonHomeViewController.h"
#import "LoginViewController.h"
#import "WalletViewController.h"
#import "MyOrderViewController.h"
#import "MacAddressListViewController.h"
#import "HoldMoneyViewController.h"
#import "NewRealNameViewController.h"
#import "NewShareViewController.h"
#import "AboutMeViewController.h"
#import "SafeViewController.h"
#import "WalletDetailViewController.h"
#import "YWUnlockView.h"
#import "MyTeamListViewController.h"

@interface NewPersonHomeViewController () {
    NSArray *_nameArray;
    NSArray *_iconArray;
    NSString *_token;
    NSDictionary *_infoData;
    BOOL _isLogin;

}

@end

@implementation NewPersonHomeViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setBarBlackColor:NO];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _token = [defaults objectForKey:@"token"];
    
    NSString *value = [defaults objectForKey:@"isLogin"];
    if ([value isEqualToString:@"YES"]) {
        NSString *phoneNum = [defaults objectForKey:@"phoneNum"];
        self.phoneLabel.text = [NSString stringWithFormat:@"%@",phoneNum];
        _isLogin = YES;
        [self requestUserInfo];
        [self login];
    } else {
        [self logout];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _nameArray = @[@"钱包",@"订单",@"MAC地址",@"账单",@"生息记录",@"我的团队",@"实名认证",@"推荐有奖",@"关于我们",@"设置"];
    _iconArray = @[@"wallet.png",@"order.png",@"mac_new.jpg",@"account.png",@"sxjl.png", @"jdwk.png",@"smrz.png",@"share.png",@"aboutus.png",@"setting.png"];
}

- (void) requestUserInfo
{
    __weak __typeof(self) weakSelf = self;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *phoneNum = [defaults objectForKey:@"phoneNum"];
    if (phoneNum.length) {
        NSDictionary *d = @{@"token":_token};
        [[NetworkTool sharedTool] requestWithURLString:@"v1/user/user/query" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
            NSLog(@"%@      ------------- %@", stringData, JSON );
            NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
            if ([code isEqualToString:@"1"]) {
                NSLog(@"");
                _infoData = [NSDictionary dictionaryWithDictionary:[JSON objectForKey:@"data"]];
                [weakSelf performSelectorOnMainThread:@selector(setInfo) withObject:nil waitUntilDone:YES];
            } else {
                [weakSelf performSelectorOnMainThread:@selector(logout) withObject:nil waitUntilDone:YES];
            }
        } failed:^(NSError *error) {
            
        }];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newpersonhome" forIndexPath:indexPath];

    UIImageView *image = (UIImageView *)[cell.contentView viewWithTag:1];
    image.image = [UIImage imageNamed:[_iconArray objectAtIndex:indexPath.row]];
    
    UILabel *name = (UILabel *)[cell.contentView viewWithTag:2];
    name.text = [_nameArray objectAtIndex:indexPath.row];
 
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _nameArray.count;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 8&&!_isLogin) {
        [self loginBtnClick:nil];
    } else {
        switch (indexPath.row) {
            case 0: {
                WalletViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WalletVC"];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            case 1: {
                MyOrderViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MyOrderVC"];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }

            case 2: {
                MacAddressListViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MacAddressListVC"];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
                
            case 3: {
                WalletDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WalletDetailVC"];
                vc.isNewPH = YES;
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            case 4: {
                NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                if ([[defaults objectForKey:@"isOpen"] isEqualToString:@"1"]) {
                    HoldMoneyViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HoldMoneyVC"];
                    [self.navigationController pushViewController:vc animated:YES];
                } else {
                    [self showToastWithMessage:@"暂未开放"];
                }
                break;
            }
            case 5: {
                MyTeamListViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MyTeamListVC"];
                [self.navigationController pushViewController:vc animated:YES];
                
                break;
            }
                
            case 6: {
                NewRealNameViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"NewRealNameVC"];
                vc.infoDic = _infoData;
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }

            case 7:{
                NewShareViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"NewShareVC"];
                vc.codeStr = [_infoData objectForKey:@"inviteCode"];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }

            case 8: {
                AboutMeViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutMeVC"];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }

            case 9: {
                SafeViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SafeVC"];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }

            default:
                break;
        }
    }
    
    
}

- (void) setInfo
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:[_infoData objectForKey:@"payPasswordStatus"] forKey:@"paymentPasswordStatus"];
    [defaults setObject:[_infoData objectForKey:@"authenticationStatus"] forKey:@"authenticationStatus"];
    [defaults setObject:[_infoData objectForKey:@"inviteCode"] forKey:@"inviteCode"];
}

- (void) login
{
    self.footView.hidden = NO;
}

- (void) logout
{
    _isLogin = NO;
    self.phoneLabel.text = @"创建账户/登录";
    self.footView.hidden = YES;
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"isLogin"];
    [defaults removeObjectForKey:@"phoneNum"];
    [defaults removeObjectForKey:@"uid"];
    [defaults removeObjectForKey:@"authenticationStatus"];
    [defaults removeObjectForKey:@"paymentPasswordStatus"];
    [defaults removeObjectForKey:@"token"];
    [defaults removeObjectForKey:@"inviteCode"];
    [YWUnlockView deleteGesturesPassword];

    [defaults synchronize];
}

- (IBAction)loginBtnClick:(id)sender {
    if (!_isLogin) {
        LoginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (IBAction)logoutBtnClick:(id)sender {
    [self logout];
}
- (IBAction)service:(id)sender {
    [self showService];
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
