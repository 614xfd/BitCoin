//
//  FindIDViewController.m
//  BitCoin
//
//  Created by LBH on 2017/9/23.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import "FindIDViewController.h"
#import "CaptchaViewController.h"

@interface FindIDViewController () {
    UIColor *_color;
}

@end

@implementation FindIDViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setBarBlackColor:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.nextBtn.layer setMasksToBounds:YES];
    self.nextBtn.layer.cornerRadius = 8;
    
    _color = self.nextBtn.titleLabel.textColor;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRegisterBtnColor) name:UITextFieldTextDidChangeNotification object:nil];

}

- (void) changeRegisterBtnColor
{
    if (self.phoneNum.text.length>0) {
        [self.nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else {
        [self.nextBtn setTitleColor:_color forState:UIControlStateNormal];
    }
}

- (void) request
{
    __weak __typeof(self) weakSelf = self;
    
    [[NetworkTool sharedTool] requestWithURLString:@"UserRegister/VerifyPhone" parameters:@{@"phone": self.phoneNum.text} method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@",stringData, JSON );
        //        NSString *isError = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        if ([code isEqualToString:@"0"]) {
            [weakSelf performSelectorOnMainThread:@selector(canResetPassword) withObject:nil waitUntilDone:YES];
        } else {
            [weakSelf performSelectorOnMainThread:@selector(showToastWithMessage:) withObject:[JSON objectForKey:@"msg"] waitUntilDone:YES];
        }
    } failed:^(NSError *error) {
        [weakSelf requestError];
    }];
}

- (void) canResetPassword
{
    CaptchaViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CaptchaVC"];
    vc.phoneNum = [NSString stringWithFormat:@"%@", self.phoneNum.text];
    vc.phone = self.phoneNum.text;
    vc.isReset = YES;
    [self.navigationController pushViewController:vc animated:YES];

}

- (IBAction)nextBtnClick:(id)sender {
    if (self.phoneNum.text.length>0) {
        [self request];
    }
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) error {
    ToastView *messageView = [[ToastView alloc]initWithFrame:self.view.bounds WithMessage:@"该号码尚未注册，请检查输入是否正确"];
    [self.view addSubview:messageView];
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
