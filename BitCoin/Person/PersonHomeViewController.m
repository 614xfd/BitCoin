//
//  PersonHomeViewController.m
//  BitCoin
//
//  Created by LBH on 2017/9/23.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import "PersonHomeViewController.h"
#import "LoginViewController.h"
#import "HoldMoneyViewController.h"
#import "MyOrderViewController.h"
#import "ExamineViewController.h"
#import "AboutMeViewController.h"
#import "TrusteeshipViewController.h"
#import "WalletViewController.h"
#import "YWUnlockView.h"
#import "ShareViewController.h"
#import "SafeViewController.h"
#import "MyNodeMiningViewController.h"
#import "BalanceViewController.h"
#import "BillViewController.h"
#import "SubordinateViewController.h"
#import "NewRealNameViewController.h"
#import "NewShareViewController.h"

#define NAVBAR_CHANGE_POINT 50

@interface PersonHomeViewController () {
    UIView *_bgView;
    NSArray *_imageArr;
    NSArray *_titleArr;
    BOOL _isLogin;
    NSString *_code;
    NSString *_token;
    NSDictionary *_infoData;
}

@end

@implementation PersonHomeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    [self creatView];
    [self setBarBlackColor:NO];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _token = [defaults objectForKey:@"token"];
    
    NSString *value = [defaults objectForKey:@"isLogin"];
    NSString *phoneNum = [defaults objectForKey:@"phoneNum"];
    if ([value isEqualToString:@"YES"]) {
        self.phoneNum.text = [NSString stringWithFormat:@"%@",phoneNum];

        [self login];
        [self requestUserInfo];
    } else {
        [self logout];
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    //    // Do any additional setup after loading the view.
    if (@available(iOS 11.0, *)) {
        [self.scroll setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.scroll.contentSize = CGSizeMake(self.view.frame.size.width, 693*kScaleH);
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenGestureView)name:@"Unlock_Hidden" object:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(creatView)name:@"Unlock_Del" object:nil];
    
    _code = @"";
    _isLogin = NO;
    //    self.loginBtn.layer.cornerRadius = 4;
    //    self.loginBtn.layer.masksToBounds = YES;
    //    [self.loginBtn.layer setBorderWidth:1];
    //    [self.loginBtn.layer setBorderColor:[UIColor colorWithRed:193/255.0 green:169/255.0 blue:107/255.0 alpha:1].CGColor];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *value = [defaults objectForKey:@"isLogin"];
    NSString *phoneNum = [defaults objectForKey:@"phoneNum"];
    if ([value isEqualToString:@"YES"]) {
        _isLogin = YES;
    } else {
        self.logoutBtn.hidden = YES;
        self.scroll.contentSize = CGSizeMake(self.view.frame.size.width, 646*kScaleH);
    }
    ////    self.phoneNum.font = [UIFont fontWithName:FONT_DIN size:14];
    //    if ([YWUnlockView haveGesturePassword]) {
    //        _titleArr = [NSArray arrayWithObjects: @"钱包", @"订单", @"生息记录", @"实名认证", @"托管服务", @"分享", @"安全设置", @"修改手势密码", @"关于我们", nil];
    //    } else {
    //        _titleArr = [NSArray arrayWithObjects: @"钱包", @"订单", @"生息记录", @"实名认证", @"托管服务", @"分享", @"安全设置", @"手势密码", @"关于我们", nil];
    //    }
    //    _imageArr = [NSArray arrayWithObjects: @"钱包.png", @"订单.png", @"持有理财.png", @"实名认证.png", @"托管服务.png", @"分享.png", @"安全设置.png", @"手势密码.png", @"关于我们.png", nil];
    //
    ////    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    //
    ////    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    ////    [defaults setObject:@"YES" forKey:@"isLogin"];
    ////    [defaults setObject:@"13624578909" forKey:@"phoneNum"];
    ////    [defaults synchronize];
    
}

- (void) creatBalance :(NSString *) string{
    self.balance.text = [NSString stringWithFormat:@"%.2lf", [string doubleValue]];
}

- (void) setAllUserNum : (NSString *)string
{
    self.allUserLabel.text = string;
}

- (void) setSubordinateNum:(NSString *) string
{
    self.subordinateLabel.text = string;
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
//                [weakSelf performSelectorOnMainThread:@selector(tokenError) withObject:nil waitUntilDone:YES];
//                [weakSelf performSelectorOnMainThread:@selector(showToastWithMessage:) withObject:@"登录身份过期" waitUntilDone:YES];
            }
        } failed:^(NSError *error) {
            //        [weakSelf requestError];
        }];
    }
}

- (void) setInfo
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:[_infoData objectForKey:@"payPasswordStatus"] forKey:@"paymentPasswordStatus"];
    [defaults setObject:[_infoData objectForKey:@"authenticationStatus"] forKey:@"authenticationStatus"];
    [defaults setObject:[_infoData objectForKey:@"inviteCode"] forKey:@"inviteCode"];
}

- (void)resetMessage:(NSString *)string
{
    self.tipLabel.text = string;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"isLogin"];
        [defaults removeObjectForKey:@"phoneNum"];
        [defaults removeObjectForKey:@"uid"];
        [defaults removeObjectForKey:@"authenticationStatus"];
        [defaults removeObjectForKey:@"paymentPasswordStatus"];
        [defaults removeObjectForKey:@"token"];
        [defaults synchronize];
//                [YWUnlockView deleteGesturesPassword];
        
        [self logout];
    }
}


- (IBAction)intoPersonWallet:(id)sender {
    if (_isLogin) {
        BalanceViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BalanceVC"];
        vc.coinName = @"BBC";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)intoSubordinate:(id)sender {
    if (!_isLogin) {
        [self loginBtn:nil];
        return;
    }
    SubordinateViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SubordinateVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)billBtnClick:(id)sender {
    if (!_isLogin) {
        [self loginBtn:nil];
        return;
    }
    BillViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BillVC"];
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)walletBtnClick:(id)sender {
    if (!_isLogin) {
        [self loginBtn:nil];
        return;
    }
    WalletViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WalletVC"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)myorderBtnClick:(id)sender {
    if (!_isLogin) {
        [self loginBtn:nil];
        return;
    }
    MyOrderViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MyOrderVC"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)accrualBtnClick:(id)sender {
    if (!_isLogin) {
        [self loginBtn:nil];
        return;
    }
    HoldMoneyViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HoldMoneyVC"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)nodeminingBtnClick:(id)sender {
    if (!_isLogin) {
        [self loginBtn:nil];
        return;
    }
    MyNodeMiningViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MyNodeMiningVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)realnameBtnClick:(id)sender {
    if (_isLogin) {
        if ([_tipLabel.text isEqualToString:@"立即认证"] || [_tipLabel.text isEqualToString:@"认证失败"]) {
            RealNameViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RealNameVC"];
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            ExamineViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ExamineVC"];
            if ([_tipLabel.text isEqualToString:@"审核中"]) {
                vc.status = @"0";
            } else {
                vc.status = @"1";
            }
            [self presentViewController:vc animated:YES completion:nil];
        }
    } else {
        [self loginBtn:nil];
    }
}

- (IBAction)trusteeshipBtnClick:(id)sender {
    TrusteeshipViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TrusteeshipVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)shareBtnClick:(id)sender {
    if (!_isLogin) {
        [self loginBtn:nil];
        return;
    }
    
    
    
//    if (_code.length) {
//        ShareViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ShareVC"];
//        vc.code = _code;
//        vc.number = self.subordinateLabel.text;
//        [self.navigationController pushViewController:vc animated:YES];
        
    
    
    NewShareViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"NewShareVC"];
    vc.codeStr = [_infoData objectForKey:@"inviteCode"];
    [self.navigationController pushViewController:vc animated:YES];
//    }
}

- (IBAction)aboutmeBtnClick:(id)sender {
    AboutMeViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutMeVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)setBtnClick:(id)sender {
    if (!_isLogin) {
        [self loginBtn:nil];
        return;
    }
    SafeViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SafeVC"];
    [self.navigationController pushViewController:vc animated:YES];
}




- (IBAction)loginBtn:(id)sender {
    LoginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)logoutBtnClick:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出登录" otherButtonTitles: nil];
    [actionSheet showInView:actionSheet];
}

- (void) login
{
    _isLogin = YES;
    self.phoneNum.hidden = NO;
    self.loginBtn.hidden = YES;
    self.logoutBtn.hidden = NO;
    self.scroll.contentSize = CGSizeMake(self.view.frame.size.width, 693*kScaleH);
}

- (void) logout
{
    _isLogin = NO;
    self.phoneNum.text = @"创建账户/登录";
    //    self.phoneNum.hidden = YES;
    self.loginBtn.hidden = NO;
    self.logoutBtn.hidden = YES;
    self.scroll.contentSize = CGSizeMake(self.view.frame.size.width, 646*kScaleH);
    self.balance.text = @"0";
    self.subordinateLabel.text = @"0";
}

- (IBAction)intoNewRealName:(id)sender {
    if (!_token.length) {
        LoginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    NewRealNameViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"NewRealNameVC"];
    vc.infoDic = _infoData;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)service:(id)sender {
    [self showService];
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
