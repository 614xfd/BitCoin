//
//  CoinSendViewController.m
//  BitCoin
//
//  Created by LBH on 2018/9/18.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "CoinSendViewController.h"
#import "CoinSendInfoViewController.h"

@interface CoinSendViewController ()

@end

@implementation CoinSendViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setBarBlackColor:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRegisterBtnColor) name:UITextFieldTextDidChangeNotification object:nil];
    
}

- (void) changeRegisterBtnColor
{
//    if (self.phoneTF.text.length<11) {
//        self.nextImage.image = [UIImage imageNamed:@"转币输入值_03.png"];
//    } else {
//        self.nextImage.image = [UIImage imageNamed:@"转币输入值_06.png"];
//    }
}
- (IBAction)nextBtnClick:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *phoneNum = [defaults objectForKey:@"phoneNum"];
    if (self.phoneTF.text.length != 11) {
        [self showToastWithMessage:@"您输入的手机号码不合法，请检查。"];
        return;
    }
    //    else if ([phoneNum isEqualToString: self.phoneTF.text]) {
    //        [self showToastWithMessage:@"不能对自己账户进行转账操作。"];
    //        return;
    //    }
    //    [self intoCoinSendInfo];
    __weak __typeof(self) weakSelf = self;
    NSDictionary *dic = @{@"phone": self.phoneTF.text};
    [[NetworkTool sharedTool] requestWithURLString:@"/checkPhoneIsRegister" parameters:dic method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@", stringData, JSON );
        //        NSString *isError = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            [weakSelf performSelectorOnMainThread:@selector(showToastWithMessage:) withObject:@"账号不存在" waitUntilDone:YES];
        } else {
            [weakSelf performSelectorOnMainThread:@selector(intoCoinSendInfo) withObject:nil waitUntilDone:YES];
        }
    } failed:^(NSError *error) {
        //        [weakSelf requestError];
    }];
}

- (void) intoCoinSendInfo
{
    CoinSendInfoViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CoinSendInfoVC"];
    vc.phoneString = self.phoneTF.text;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
