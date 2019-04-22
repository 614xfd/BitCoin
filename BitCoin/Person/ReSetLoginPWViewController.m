//
//  ReSetLoginPWViewController.m
//  BitCoin
//
//  Created by LBH on 2017/12/28.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import "ReSetLoginPWViewController.h"
#import "LoginViewController.h"

@interface ReSetLoginPWViewController () {
    UIColor *_color;
}

@end

@implementation ReSetLoginPWViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setBarBlackColor:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.lineLabel.layer setBorderWidth:0.5];
    [self.lineLabel.layer setBorderColor:[UIColor groupTableViewBackgroundColor].CGColor];
    
    [self.nextBtn.layer setMasksToBounds:YES];
    [self.nextBtn.layer setCornerRadius:6];
    
    if (self.isReSet) {
        [self.nextBtn setTitle:@"保存密码" forState:UIControlStateNormal];
        self.tipLabel.textColor = [UIColor grayColor];
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:self.tipLabel.text];
        NSUInteger firstLoc = [[noteStr string] rangeOfString:@"登录了"].location + 3;
        NSUInteger secondLoc = [[noteStr string] rangeOfString:@"并通过"].location;
        NSRange range = NSMakeRange(firstLoc, secondLoc - firstLoc);
        [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range];
        [noteStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18] range:range];
        [self.tipLabel setAttributedText:noteStr];
        self.tipLabel.hidden = NO;
    }
    
    _color = self.nextBtn.titleLabel.textColor;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRegisterBtnColor) name:UITextFieldTextDidChangeNotification object:nil];

}

- (void) changeRegisterBtnColor
{
    if (self.passwordNumTF.text.length>5) {
        [self.nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.nextBtn setBackgroundColor:[UIColor colorWithRed:47/255.0 green:130/255.0 blue:200/255.0 alpha:1]];
    } else {
        [self.nextBtn setTitleColor:_color forState:UIControlStateNormal];
        [self.nextBtn setBackgroundColor:[UIColor colorWithRed:203/255.0 green:204/255.0 blue:205/255.0 alpha:1]];
    }
}

- (IBAction)nextBtnClick:(id)sender {
    if ([self inputShouldNumber:self.passwordNumTF.text]||[self inputShouldLetter:self.passwordNumTF.text]) {
        ToastView *messageView = [[ToastView alloc]initWithFrame:self.view.bounds WithMessage:@"密码必须是6-16位英文字母+数字，注意区分大小写！"];
        [self.view addSubview:messageView];
        return;
    } else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *phoneNum = [defaults objectForKey:@"phoneNum"];
        NSString *string = [self md5:self.passwordNumTF.text];
        
        //  请求
        if (self.isReSet) {
            __weak __typeof(self) weakSelf = self;
            NSDictionary *dic = @{@"phone":phoneNum, @"pwd":self.password, @"newPassWord":string};
            [[NetworkTool sharedTool] requestWithURLString:@"forgotPassWord/updatePassWord" parameters:dic method:@"POST" completed:^(id JSON, NSString *stringData) {
                NSLog(@"%@      ------------- %@", stringData, JSON );
                NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
                if ([code isEqualToString:@"1"]) {
                    [weakSelf performSelectorOnMainThread:@selector(resetSuccess) withObject:nil waitUntilDone:YES];
                } else {
                    [weakSelf performSelectorOnMainThread:@selector(showToastWithMessage:) withObject:[JSON objectForKey:@"msg"] waitUntilDone:YES];
                }
            } failed:^(NSError *error) {
            }];
        } else {
            __weak __typeof(self) weakSelf = self;
            NSDictionary *dic = @{@"phone":phoneNum, @"pwd":string};
            [[NetworkTool sharedTool] requestWithURLString:@"forgotPassWord/verificationLogin" parameters:dic method:@"POST" completed:^(id JSON, NSString *stringData) {
                NSLog(@"%@      ------------- %@", stringData, JSON );
                NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
                if ([code isEqualToString:@"1"]) {
                    [weakSelf performSelectorOnMainThread:@selector(resetPW) withObject:nil waitUntilDone:YES];
                } else {
                    [weakSelf performSelectorOnMainThread:@selector(showToastWithMessage:) withObject:[JSON objectForKey:@"msg"] waitUntilDone:YES];
                }
            } failed:^(NSError *error) {
            }];
        }
        
//        UILabel *label = [[UILabel alloc]initWithFrame:self.view.bounds];
//        label.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
//        [self.view addSubview:label];
//
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"您的账号（%@）新密码设置成功，请用新密码进行登录，切记", self.phoneNum] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        [alert show];
        
    }
}

- (void) resetSuccess
{
    ToastView *messageView = [[ToastView alloc]initWithFrame:self.view.bounds WithMessage:@"设置新密码成功"];
    [self.view addSubview:messageView];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    [defaults removeObjectForKey:@"phoneNum"];
    [defaults removeObjectForKey:@"isLogin"];
    [defaults synchronize];
    double delayInSeconds = 1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_global_queue(0,0), ^(void){
        dispatch_async(dispatch_get_main_queue(), ^{
            LoginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
            vc.isResetPW = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        });
    });
}

- (void) resetPW
{
    ReSetLoginPWViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ReSetLPWVC"];
    vc.isReSet = YES;
    vc.password = [self md5:self.passwordNumTF.text];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)goBack:(id)sender {
    if (self.isReSet) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
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
