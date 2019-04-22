//
//  ExtractViewController.m
//  BitCoin
//
//  Created by LBH on 2018/5/22.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "ExtractViewController.h"
#import "SetPayPassWordViewController.h"

@interface ExtractViewController () {
    BOOL _isSMRZ;
    BOOL _isZJMM;
}

@end

@implementation ExtractViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setBarBlackColor:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (@available(iOS 11.0, *)) {
        [self.scroll setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _isSMRZ = YES;
    _isZJMM = YES;
    self.scroll.contentSize = CGSizeMake(self.view.frame.size.width, 647*kScaleH);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenTV)];
    [self.scroll addGestureRecognizer:tap];
    self.countLabel.text = [NSString stringWithFormat:@"%.2lf %@", self.count, self.coinName];
    self.numberTF.placeholder = [NSString stringWithFormat:@"最大可提%.2lf", self.count];
    self.coinLabel.text = self.coinName;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEditChanged:) name:UITextFieldTextDidChangeNotification object:self.numberTF];

}

- (IBAction)QRCodeBtnClick:(id)sender {
    [self QRCode];
}

#pragma mark 二维码扫描
- (void) QRCode
{
    QRCodeViewController *qrcodeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"qrcodeview"];
    qrcodeVC.delegate = self;
    [self.navigationController pushViewController:qrcodeVC animated:NO];
}

- (void) returnString:(NSString *)string
{
    self.addressTF.text = string;
}

-(void)textFieldEditChanged:(NSNotification *)obj
{
    UITextField *tf = obj.object;
    
    NSString *str = tf.text;
    if ([str doubleValue] > self.count) {
        self.numberTF.text = [NSString stringWithFormat:@"%.2lf", self.count];
    }
    if ([str doubleValue] > 10.0) {
        self.numberLabel.text = [NSString stringWithFormat:@"%.2lf %@", [str doubleValue] - 10.0, self.coinName];
    } else {
        self.numberLabel.text = [NSString stringWithFormat:@"0 %@", self.coinName];
    }
        
}

- (void) resetMessage:(NSString *)string
{
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if (!_isSMRZ) {
            RealNameViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RealNameVC"];
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        if (!_isZJMM) {
            SetPayPassWordViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SetPayPassWordVC"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (IBAction)allBtnClick:(id)sender {
    self.numberTF.text = [NSString stringWithFormat:@"%.2lf", self.count];
    self.numberLabel.text = [NSString stringWithFormat:@"%.2lf USDT", [self.numberTF.text doubleValue] - 10.0];
}

- (IBAction)extractBtnClick:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *status = [defaults objectForKey:@"authenticationStatus"];
    NSString *paymentPasswordStatus = [defaults objectForKey:@"paymentPasswordStatus"];
    if ([status isEqualToString:@"0"]) {
        _isSMRZ = NO;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"您暂未实名认证，请先实名认证购买" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"认证", nil];
        [alert show];
        return;
    }
    if ([paymentPasswordStatus isEqualToString:@"0"]) {
        _isZJMM = NO;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"您暂未设置支付密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
        return;
    }

    [self request];
}

- (void) request
{
    __weak __typeof(self) weakSelf = self;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uid = [defaults objectForKey:@"uid"];
    NSDictionary *d = @{@"id":uid, @"path":self.addressTF.text, @"sum":self.numberTF.text};
    [[NetworkTool sharedTool] requestWithURLString:@"UserAccount/withdrawBBC" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@", stringData, JSON );
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
//        if ([code isEqualToString:@"1"]) {
        
//        } else {
//
//        }
//        [weakSelf showToastWithMessage:[JSON objectForKey:@"msg"]];
        [weakSelf performSelectorOnMainThread:@selector(showToastWithMessage:) withObject:[JSON objectForKey:@"msg"] waitUntilDone:YES];

    } failed:^(NSError *error) {
        //        [weakSelf requestError];
    }];
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hiddenTV];
}

- (void) hiddenTV
{
    [self.addressTF resignFirstResponder];
    [self.numberTF resignFirstResponder];
    
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
