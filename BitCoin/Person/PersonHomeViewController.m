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
    if (_code.length<1) {
        [self request];
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _token = [defaults objectForKey:@"token"];
    
    NSString *value = [defaults objectForKey:@"isLogin"];
    NSString *phoneNum = [defaults objectForKey:@"phoneNum"];
    NSString *s = [defaults objectForKey:@"authenticationStatus"];
    if ([value isEqualToString:@"YES"]) {
        self.phoneNum.text = [NSString stringWithFormat:@"%@",phoneNum];
        if ([s isEqualToString:@"0"]) {
            self.tipLabel.text = @"立即认证";
        } else if ([s isEqualToString:@"1"]) {
            self.tipLabel.text = @"审核中";
        } else if ([s isEqualToString:@"2"]) {
            self.tipLabel.text = @"认证成功";
        } else if ([s isEqualToString:@"3"]) {
            self.tipLabel.text = @"认证失败";
        }
        [self login];
        [self requestBalanle];
    } else {
        [self logout];
    }
    [self requestAllUser];
    [self requestSubordinate];
}

//- (void) creatView
//{
//    if (_code.length<1) {
//        [self request];
//    }
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *value = [defaults objectForKey:@"isLogin"];
//    NSString *phoneNum = [defaults objectForKey:@"phoneNum"];
//    NSString *s = [defaults objectForKey:@"authenticationStatus"];
//    if ([value isEqualToString:@"YES"]) {
//        _isLogin = YES;
//        self.phoneNum.text = [NSString stringWithFormat:@"账号：%@",phoneNum];
//        if ([s isEqualToString:@"0"]) {
//            _status = @"立即认证";
//        } else if ([s isEqualToString:@"1"]) {
//            _status = @"审核中";
//        } else if ([s isEqualToString:@"2"]) {
//            _status = @"认证成功";
//        }
//    } else {
//        _isLogin = NO;
//        self.phoneNum.text = @"未登录";
//        _status = @"立即认证";
//    }
//    if ([YWUnlockView haveGesturePassword]) {
//        _titleArr = [NSArray arrayWithObjects: @"钱包", @"订单", @"生息记录", @"实名认证", @"托管服务", @"分享", @"安全设置", @"修改手势密码", @"关于我们", nil];
//    } else {
//        _titleArr = [NSArray arrayWithObjects: @"钱包", @"订单", @"生息记录", @"实名认证", @"托管服务", @"分享", @"安全设置", @"手势密码", @"关于我们", nil];
//    }
//    [self.tableView reloadData];
//}

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
        [self requestStatus:phoneNum];
    } else {
        self.logoutBtn.hidden = YES;
        self.scroll.contentSize = CGSizeMake(self.view.frame.size.width, 646*kScaleH);
    }
    [self request];
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
            } else {
                
            }
        } failed:^(NSError *error) {
            //        [weakSelf requestError];
        }];
    }
}

- (void) request
{
    //    __weak __typeof(self) weakSelf = self;
    //    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    NSString *phoneNum = [defaults objectForKey:@"phoneNum"];
    //    if (phoneNum.length) {
    //        NSDictionary *d = @{@"phone":phoneNum};
    //        [[NetworkTool sharedTool] requestWithURLString:@"UserRegister/shareRegister" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
    //            NSLog(@"%@      ------------- %@", stringData, JSON );
    //            NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
    //            if ([code isEqualToString:@"1"]) {
    //                NSLog(@"");
    //                _code = [JSON objectForKey:@"Data"];
    //            } else {
    //
    //            }
    //        } failed:^(NSError *error) {
    //            //        [weakSelf requestError];
    //        }];
    //    }
}

- (void) requestAllUser
{
    //    __weak __typeof(self) weakSelf = self;
    //    NSDictionary *d = @{};
    //    [[NetworkTool sharedTool] requestWithURLString:@"user/findAllUserSum" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
    //        NSLog(@"%@      ------------- %@", stringData, JSON );
    //        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
    //        if ([code isEqualToString:@"1"]) {
    //            [weakSelf performSelectorOnMainThread:@selector(setAllUserNum:) withObject:[NSString stringWithFormat:@"%@", [JSON objectForKey:@"Data"]] waitUntilDone:YES];
    //        } else {
    //
    //        }
    //    } failed:^(NSError *error) {
    //        //        [weakSelf requestError];
    //    }];
}

- (void) requestSubordinate
{
    //    __weak __typeof(self) weakSelf = self;
    //    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    NSString *uid = [defaults objectForKey:@"uid"];
    //    if (uid.length) {
    //        NSDictionary *d = @{@"uid":uid};
    //        [[NetworkTool sharedTool] requestWithURLString:@"user/getAllSubordinate" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
    //            NSLog(@"%@      ------------- %@", stringData, JSON );
    //            NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
    //            if ([code isEqualToString:@"1"]) {
    //                [weakSelf performSelectorOnMainThread:@selector(setSubordinateNum:) withObject:[NSString stringWithFormat:@"%@", [JSON objectForKey:@"Data"]] waitUntilDone:YES];
    //            } else {
    //
    //            }
    //        } failed:^(NSError *error) {
    //            //        [weakSelf requestError];
    //        }];
    //    }
}

- (void) requestStatus : (NSString *)phone
{
    //    __weak __typeof(self) weakSelf = self;
    //    NSDictionary *dic = @{@"phone":phone};
    //    [[NetworkTool sharedTool] requestWithURLString:@"Certificates/findSate" parameters:dic method:@"POST" completed:^(id JSON, NSString *stringData) {
    //        NSLog(@"%@      ------------- %@", stringData, JSON );
    //        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
    //        if ([code isEqualToString:@"1"]) {
    //            NSString *string = [NSString stringWithFormat:@"%@", [[JSON objectForKey:@"Data"] objectForKey:@"AuthenticationStatus"]];
    //            NSString *str = @"立即认证";
    //            if ([string isEqualToString:@"1"]) {
    //                str = @"审核中";
    //            } else if ([string isEqualToString:@"2"]) {
    //                str = @"认证成功";
    //            } else if ([string isEqualToString:@"3"]) {
    //                str = @"认证失败";
    //            }
    //            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //            [defaults setObject:code forKey:@"authenticationStatus"];
    //            [weakSelf performSelectorOnMainThread:@selector(resetMessage:) withObject:str waitUntilDone:YES];
    //        } else {
    //            [weakSelf performSelectorOnMainThread:@selector(showToastWithMessage:) withObject:[JSON objectForKey:@"msg"] waitUntilDone:YES];
    //        }
    //    } failed:^(NSError *error) {
    //    }];
}

- (void) requestBalanle
{
    //    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    NSString *uid = [defaults objectForKey:@"uid"];
    //    if (uid.length) {
    //        __weak __typeof(self) weakSelf = self;
    //        NSDictionary *d = @{@"id":uid};
    //        [[NetworkTool sharedTool] requestWithURLString:@"UserAccount/findUserBalanleSum" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
    //            NSLog(@"%@      ------------- %@", stringData, JSON );
    //            NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
    //            if ([code isEqualToString:@"1"]) {
    //                NSArray *array = [NSArray arrayWithArray:[JSON objectForKey:@"Data"]];
    //                for (int i = 0; i < array.count; i++) {
    //                    if ([[[array objectAtIndex:i] objectForKey:@"type"] isEqualToString:@"bbc"]) {
    //                        NSString *str = [NSString stringWithFormat:@"%@", [[array objectAtIndex:i] objectForKey:@"balance"]];
    //                        [weakSelf performSelectorOnMainThread:@selector(creatBalance:) withObject:str waitUntilDone:YES];
    //                    }
    //                }
    //            } else {
    //            }
    //        } failed:^(NSError *error) {
    //            //        [weakSelf requestError];
    //        }];
    //    }
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.row == 5) {
////        [self share];
//        if (_code.length) {
//            ShareViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ShareVC"];
//            vc.code = _code;
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//        return;
//
//    }
//    if (indexPath.row == 8) {
//        AboutMeViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutMeVC"];
//        [self.navigationController pushViewController:vc animated:YES];
//        return;
//    }
//
//    if (indexPath.row == 4) {
//        TrusteeshipViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TrusteeshipVC"];
//        [self.navigationController pushViewController:vc animated:YES];
//        return;
//    }
//
//    if (!_isLogin) {
//        LoginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
//        [self.navigationController pushViewController:vc animated:YES];
//        return;
//    }
//
//    if (indexPath.row == 0) {
//        WalletViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WalletVC"];
//        [self.navigationController pushViewController:vc animated:YES];
//        return;
//    }
//
//    if (indexPath.row == 6) {
//        SafeViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SafeVC"];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//
//    if (indexPath.row == 7) {
//        if ([YWUnlockView haveGesturePassword]) {
//            [YWUnlockView showUnlockViewWithType:YWUnlockViewUnlock  andReset:@"验证手势密码" andIsVerify:YES callBack:^(BOOL result) {
//                NSLog(@"-->%@",@(result));
//            }];
//        } else {
//            [YWUnlockView showUnlockViewWithType:YWUnlockViewCreate andReset:@"设置手势密码" andIsVerify:NO callBack:^(BOOL result) {
//                NSLog(@"-->%@",@(result));
//                if (result) {
//                    _titleArr = [NSArray arrayWithObjects: @"钱包", @"生息记录", @"实名认证", @"托管服务", @"分享", @"安全设置", @"修改手势密码", @"关于我们", nil];
//                    [self.tableView reloadData];
//                }
//            }];
//        }
//    }
//
////    if (indexPath.row == 0) {
////        WalletViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WalletVC"];
////        [self.navigationController pushViewController:vc animated:YES];
////    }
//
//    if (indexPath.row == 2) {
//        HoldMoneyViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HoldMoneyVC"];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
////    else
////        if (indexPath.row == 3 || indexPath.row == 0) {
////        MyOrderViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MyOrderVC"];
////        [self.navigationController pushViewController:vc animated:YES];
////            [self showToastWithMessage:@"暂未开放，敬请期待"];
////    } else
//        if (indexPath.row == 3) {
//            if ([_status isEqualToString:@"立即认证"]) {
//                RealNameViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RealNameVC"];
//                vc.delegate = self;
//                [self.navigationController pushViewController:vc animated:YES];
//            } else {
//                ExamineViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ExamineVC"];
//                if ([_status isEqualToString:@"审核中"]) {
//                    vc.status = @"0";
//                } else {
//                    vc.status = @"1";
//                }
//                [self presentViewController:vc animated:YES completion:nil];
//            }
//    }
//    if (indexPath.row == 1){
//        MyOrderViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MyOrderVC"];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//}

- (void)resetMessage:(NSString *)string
{
    self.tipLabel.text = string;
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    //    UIColor * color = [UIColor whiteColor];
//    CGFloat offsetY = scrollView.contentOffset.y;
//    if (offsetY > NAVBAR_CHANGE_POINT) {
//        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
//        //        self.bgTitleLabel.backgroundCo lor = [color colorWithAlphaComponent:alpha];
//        self.titleLabel.alpha = alpha;
//        self.bgLabel.alpha = alpha;
//        //        self.titleLabel.textColor = [color colorWithAlphaComponent:alpha];
////        NSLog(@"%lf", alpha);
//    } else {
//        //        self.bgTitleLabel.backgroundColor = [color colorWithAlphaComponent:0];
//        self.titleLabel.alpha = 0;
//        self.bgLabel.alpha = 0;
//        //        self.titleLabel.textColor = [color colorWithAlphaComponent:0];
//    }
////    NSLog(@"%lf", offsetY);
////    if (offsetY <= 0) {
////        self.titleLabel.hidden = YES;
////    } else {
////        self.titleLabel.hidden = NO;
////    }
//
//}
//
//- (void) btnClick
//{
//
//}
//
//- (void) logOutORLogin
//{
//    if (_isLogin) {
//        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出登录" otherButtonTitles: nil];
//        [actionSheet showInView:actionSheet];
//
//    } else {
//        LoginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//}
//
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"isLogin"];
        [defaults removeObjectForKey:@"phoneNum"];
        [defaults removeObjectForKey:@"uid"];
        [defaults removeObjectForKey:@"authenticationStatus"];
        [defaults removeObjectForKey:@"paymentPasswordStatus"];
        [defaults synchronize];
        //        [YWUnlockView deleteGesturesPassword];
        
        [self logout];
    }
}

//- (void) hiddenGestureView
//{
////    NSArray *subviews = [self.view subviews];
////    for (int i = 0 ; i < subviews.count; i++) {
////
////    }
////    NSArray *subviews = [[UIApplication sharedApplication].keyWindow subviews];
////    NSLog(@"%@", subviews);
////    for (int i = 0 ; i < subviews.count; i++) {
////        if ([[[subviews objectAtIndex:i] class] isKindOfClass:[YWUnlockView class]]) {
////            [(YWUnlockView *)[subviews objectAtIndex:i] removeFromSuperview];
////            return;
////        }
////    }
//    [[[UIApplication sharedApplication].keyWindow viewWithTag:989898] removeFromSuperview];
//}
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
    self.tipLabel.text = @"立即认证";
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
