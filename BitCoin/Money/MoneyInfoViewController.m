//
//  MoneyInfoViewController.m
//  BitCoin
//
//  Created by LBH on 2017/10/12.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import "MoneyInfoViewController.h"
#import "LoginViewController.h"
#import "CalculatorViewController.h"
#import "RSAEncryptor.h"
#import "SetPayPassWordViewController.h"

@interface MoneyInfoViewController () <UITextFieldDelegate> {
    CGRect _rect;
    BOOL _isKeyBoardShow;
    NSDictionary *_data;
    NSString *_bbcBalance;
    NSString *_uid;
    //    double _parities;
    NSString *_orderData;
    BOOL _isSMRZ;
    BOOL _isZJMM;
    NSString *_payString;
}

@property (nonatomic, assign) BOOL isHaveDian;

@end

@implementation MoneyInfoViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setBarBlackColor:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _uid = [defaults objectForKey:@"uid"];
    _rect = self.buyInfoView.frame;
    _isKeyBoardShow = NO;
    _data = [NSDictionary dictionary];
    //    _parities = 5000;
    _orderData = @"";
    _isSMRZ = YES;
    _isZJMM = YES;
    self.scroll.contentSize = CGSizeMake(self.view.frame.size.width, 630*kScaleH);
    
    self.yearLabel.font = [UIFont fontWithName:FONT_DIN size:35];
    self.saveLabel.font = [UIFont fontWithName:FONT_DIN size:25];
    self.dayLabel.font = [UIFont fontWithName:FONT_DIN size:25];
    self.yearLabel.text = [NSString stringWithFormat:@"%@", self.rate];
    self.dayLabel.text = [NSString stringWithFormat:@"%@", self.day];
    self.allDayLabel.text = [NSString stringWithFormat:@"%@天期限", self.day];
    self.titleLabel.text = [NSString stringWithFormat:@"%@期", self.time];
    [self requestBalance];
    [self requestInfo];
    
    self.USDTLine.layer.cornerRadius = 4;
    self.USDTLine.layer.masksToBounds = YES;
    [self.USDTLine.layer setBorderWidth:1];
    [self.USDTLine.layer setBorderColor:[UIColor colorWithRed:241/255.0 green:241/255.0 blue:245/255.0 alpha:1].CGColor];
    
    //    self.BBCLine.layer.cornerRadius = 4;
    //    self.BBCLine.layer.masksToBounds = YES;
    //    [self.BBCLine.layer setBorderWidth:1];
    //    [self.BBCLine.layer setBorderColor:[UIColor colorWithRed:241/255.0 green:241/255.0 blue:245/255.0 alpha:1].CGColor];
    
    //    self.lastBBCLine.layer.cornerRadius = 4;
    //    self.lastBBCLine.layer.masksToBounds = YES;
    //    [self.lastBBCLine.layer setBorderWidth:1];
    //    [self.lastBBCLine.layer setBorderColor:[UIColor colorWithRed:241/255.0 green:241/255.0 blue:245/255.0 alpha:1].CGColor];
    
    [self.buyInfoView.layer setMasksToBounds:YES];
    self.buyInfoView.layer.cornerRadius = 4;
//    [self.payView.layer setMasksToBounds:YES];
//    self.payView.layer.cornerRadius = 4;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEditChanged:) name:UITextFieldTextDidChangeNotification object:self.bbcTF];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEditChanged:) name:UITextFieldTextDidChangeNotification object:self.usdtTF];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEditChanged:) name:UITextFieldTextDidChangeNotification object:self.allBBCTF];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void) creatInfoView
{
    //    double p = 1/_parities;
    //    int p1 = p*100;
    //    self.bbcPriceLabel.text = [NSString stringWithFormat:@"1ETH=%.2lfBBC", _parities];
    
    //    double d = [[_data objectForKey:@"userETHBalance"] doubleValue];
    
    //    self.bbcTF.placeholder = [NSString stringWithFormat:@"最大可买%.2lfBBC", d*_parities];
    self.limitLabel.text = [NSString stringWithFormat:@"最低买入%@GTSE", [_data objectForKey:@"limit"]];
    
    //    if ([[_data objectForKey:@"type"] isEqualToString:@"1"]) {
    //        self.allBBCTF.placeholder = [NSString stringWithFormat:@"转入%@%%分享所得BBC", [_data objectForKey:@"typeValue"]];
    //    } else if ([[_data objectForKey:@"type"] isEqualToString:@"2"]) {
    //        self.allBBCTF.placeholder = [NSString stringWithFormat:@"转入%@个分享所得BBC", [_data objectForKey:@"typeValue"]];
    //    }
}

- (void) creatRate
{
    self.saveLabel.text = _bbcBalance;
    self.usdtTF.placeholder = [NSString stringWithFormat:@"最大可买%.2lfGTSE", [_bbcBalance floatValue]];
    
}

- (void) requestBalance
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    if (token.length) {
        __weak __typeof(self) weakSelf = self;
        NSDictionary *d = @{@"token":token};
        [[NetworkTool sharedTool] requestWithURLString:@"v1/user/account/info" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
            NSLog(@"%@      ------------- %@", stringData, JSON );
            NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
            if ([code isEqualToString:@"1"]) {
                _bbcBalance = [NSString stringWithFormat:@"%.2lf", [[[JSON objectForKey:@"data"] objectForKey:@"normal"] doubleValue]];
                [weakSelf performSelectorOnMainThread:@selector(creatRate) withObject:nil waitUntilDone:YES];
            } else {
                
            }
        } failed:^(NSError *error) {
            //        [weakSelf requestError];
        }];
    }
}

- (void) requestInfo
{
    if (!self.idString || !self.idString.length) {
        return;
    }
    //    __weak __typeof(self) weakSelf = self;
    //    NSDictionary *d = @{@"id":_uid};
    //    [[NetworkTool sharedTool] requestWithURLString:@"financing/clickBuy" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
    //        NSLog(@"%@      ------------- %@", stringData, JSON );
    //        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
    //        if ([code isEqualToString:@"1"]) {
    //            NSString *string = JSON[@"Data"];
    //            NSData *JSONData = [string dataUsingEncoding:NSUTF8StringEncoding];
    //            _data = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    //            _parities = [[_data objectForKey:@"usdtCurrentPrice"] doubleValue];
    //            [weakSelf performSelectorOnMainThread:@selector(creatInfoView) withObject:nil waitUntilDone:YES];
    //        } else {
    //
    //        }
    //    } failed:^(NSError *error) {
    //        //        [weakSelf requestError];
    //    }];
    __weak __typeof(self) weakSelf = self;
    NSDictionary *d = @{@"id":self.idString};
    [[NetworkTool sharedTool] requestWithURLString:@"financingType/getFinanceById" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@", stringData, JSON );
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            //            NSString *string = JSON[@"Data"];
            //            NSData *JSONData = [string dataUsingEncoding:NSUTF8StringEncoding];
            //            _data = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
            _data = [NSDictionary dictionaryWithDictionary:JSON[@"data"]];
            //            _parities = [[[JSON objectForKey:@"Data"] objectForKey:@"usdtCurrentPrice"] doubleValue];
            [weakSelf performSelectorOnMainThread:@selector(creatInfoView) withObject:nil waitUntilDone:YES];
        } else {
            
        }
    } failed:^(NSError *error) {
        //        [weakSelf requestError];
    }];
}

- (void) order
{
    __weak __typeof(self) weakSelf = self;
    
    NSString *s = @"0";
    //    if (self.allBBCTF.text.length > 0) {
    //        s = self.allBBCTF.text;
    //    }
    if ([self.usdtTF.text doubleValue] < 1) {
        [self showToastWithMessage:@""];
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    NSDictionary *d = @{@"token":token, @"amount":self.usdtTF.text, @"type":self.type, @"pwd":_payString};
    [[NetworkTool sharedTool] requestWithURLString:@"v1/financing/pay" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@", stringData, JSON );
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            //            [weakSelf performSelectorOnMainThread:@selector(goPay:) withObject:[NSString stringWithFormat:@"%@", [JSON objectForKey:@"Data"]] waitUntilDone:YES];
            [weakSelf performSelectorOnMainThread:@selector(success:) withObject:[JSON objectForKey:@"msg"] waitUntilDone:YES];
        } else {
            [weakSelf performSelectorOnMainThread:@selector(orderError:) withObject:[JSON objectForKey:@"msg"] waitUntilDone:YES];
        }
    } failed:^(NSError *error) {
        //        [weakSelf requestError];
    }];
}

- (void) orderError : (NSString *) string
{
    [self showToastWithMessage:string];
}

- (void) success : (NSString *) string
{
    [self showToastWithMessage:string];
    double delayInSeconds = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_global_queue(0,0), ^(void){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    });
}

- (void) pay : (NSString *)string
{
    __weak __typeof(self) weakSelf = self;
    //    NSString *pw = [self md5:string];
    NSDictionary *d = @{@"payPassword":string, @"orderInfo":_orderData};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:d options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *public_key_path = [[NSBundle mainBundle] pathForResource:@"public_key.der" ofType:nil];
    NSString *encryptStr = [RSAEncryptor encryptString:str publicKeyWithContentsOfFile:public_key_path];
    
    NSDictionary *dic = @{@"data":encryptStr};
    [[NetworkTool sharedTool] requestWithURLString:@"financing/pay" parameters:dic method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@", stringData, JSON );
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            [weakSelf performSelectorOnMainThread:@selector(payError:) withObject:@"支付成功" waitUntilDone:YES];
        } else {
            [weakSelf performSelectorOnMainThread:@selector(payError:) withObject:[JSON objectForKey:@"msg"] waitUntilDone:YES];
        }
    } failed:^(NSError *error) {
        //        [weakSelf requestError];
    }];
}

- (void) payError : (NSString *)string
{
    for (int i = 20; i < 26; i++) {
        UITextView *tf = (UITextView *)[self.view viewWithTag:i];
        [tf resignFirstResponder];
    }
    self.bgButton.hidden = YES;
    self.buyInfoView.hidden = YES;
//    self.payView.hidden = YES;
    [self.bbcTF resignFirstResponder];
    [self.usdtTF resignFirstResponder];
    [self.allBBCTF resignFirstResponder];
    [self showToastWithMessage:string];
}

- (void) goPay : (NSString *)string
{
    //    //    //原始数据
    //    NSString *originalString = @"{\"payPassword\":\"123456\",\"orderInfo\":\"{\"bbcShare\":20.0000000000,\"bbcamount\":50.0000000000,\"daoqi\":\"2018-08-14 18:02:18\",\"id\":\"20180514180218713yMfUZV\",\"orderStatus\":1,\"time\":\"2018-05-14 18:02:18\",\"type\":\"3\",\"uid\":41,\"usdtAmount\":100.0000000000,\"zfyxsj\":\"30\"}\"}";
    
    //使用.der和.p12中的公钥私钥加密解密
    //    NSString *public_key_path = [[NSBundle mainBundle] pathForResource:@"public_key.der" ofType:nil];
    NSString *private_key_path = [[NSBundle mainBundle] pathForResource:@"private_key.p12" ofType:nil];
    
    //    NSString *encryptStr = [RSAEncryptor encryptString:originalString publicKeyWithContentsOfFile:public_key_path];
    //    NSLog(@"加密前:%@", originalString);
    //    NSLog(@"加密后:%@", encryptStr);
    //    NSLog(@"解密后:%@", [RSAEncryptor decryptString:@"E7Uh9LVxdjSur7J7ibViYuGWjPfXYTxiRdnsHulOB8qM80Ilj/xfOT+TT2hsePSI6n6ofciqOtdUCVXqbBP3tvg6vIIPOm8BPh4EfnZvrT5vo4or+ykezhw00G7+h/b2s2LhNbH7DsEoK4yLPUJo8fy/eTPgRit73L6uwI4ZE9JPupZwvPYypbjpqPLL5vstjZE6PmrmmNZLoyPqFe8UVCQw1KNA+WUCXuA1TLdLcq72T9Vn2X775ZVFyV1AbN9DYWC2CcGnOq2GXM2/+xNHgt71obu4//b9KMso4xmsWjqVktxEdVIihPEuDvoBpwXIpj3xOWCbe5NWyA8ANKoJRqhWqjSrMxpsAeaB0dxe1b+sMYg2sRDgzZvQ1CrO9qJsw99vJnFi+jJn7eeTJD/um+FMbZQGKnmaarWcavJ01A6Srxp3FTd1VD4ukNX429YuRlW39AkyKoeSRULwFRDWqUCEcylMCpbUSTvEBdj2Xam4j7tAR133SGH1/RIMyPcx" privateKeyWithContentsOfFile:private_key_path password:@""]);
    _orderData = [RSAEncryptor decryptString:string privateKeyWithContentsOfFile:private_key_path password:@""];
    self.buyInfoView.hidden = YES;
//    self.payView.hidden = NO;
    self.bgButton.hidden = NO;
}

- (IBAction)buyButtonClick:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *value = [defaults objectForKey:@"isLogin"];
    if (!value) {
        LoginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    [self requestInfo];
    self.bgButton.hidden = NO;
    self.buyInfoView.hidden = NO;
}

- (IBAction)allBuy:(id)sender {
    //    double p = 1/_parities;
    //    int p1 = p*100;
    
    //    double d = [[_data objectForKey:@"userETHBalance"] doubleValue];
    self.usdtTF.text = [NSString stringWithFormat:@"%.2lf", [_bbcBalance floatValue]];
    
    //    self.bbcTF.text = [NSString stringWithFormat:@"%.2lf", d*_parities];
    
    //    if ([[_data objectForKey:@"type"] isEqualToString:@"1"]) {
    //        self.allBBCTF.text = [NSString stringWithFormat:@"%.2lf", [[_data objectForKey:@"userShareBBCBalance"] doubleValue]*0.1];
    //    } else if ([[_data objectForKey:@"type"] isEqualToString:@"2"]) {
    //        self.allBBCTF.text = [NSString stringWithFormat:@"%@", [_data objectForKey:@"userShareBBCBalance"]];
    //    }
}

- (IBAction)buy:(id)sender {
    //    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    NSString *status = [defaults objectForKey:@"authenticationStatus"];
    //    NSString *paymentPasswordStatus = [defaults objectForKey:@"paymentPasswordStatus"];
    //    if ([status isEqualToString:@"0"]) {
    //        _isSMRZ = NO;
    //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"您暂未实名认证，请先实名认证购买" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"认证", nil];
    //        [alert show];
    //        return;
    //    }
    //    if ([paymentPasswordStatus isEqualToString:@"0"]) {
    //        _isZJMM = NO;
    //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"您暂未设置支付密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
    //        [alert show];
    //        return;
    //    }
    //
    //    if ([self.usdtTF.text doubleValue] < [[_data objectForKey:@"limitAmount"] doubleValue]) {
    //        self.warnImage.hidden = NO;
    //        self.warnLabel.hidden = NO;
    //        return;
    //    }
    [self.bbcTF resignFirstResponder];
    [self.usdtTF resignFirstResponder];
    [self.allBBCTF resignFirstResponder];
    
    //    [self order];
//    self.payView.hidden = NO;
    [self inputPayPasswordWithPayTip:@"支付" andPrice:[NSString stringWithFormat:@"%@ GTSE", self.usdtTF.text]];
    self.bgButton.hidden = NO;
    self.payMoneyLabel.text = [NSString stringWithFormat:@"%@ GTSE", self.usdtTF.text];
}

- (void) returnPayPassword:(NSString *)string
{
    _payString = string;
    [self order];
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

- (IBAction)calculatorBtnClick:(id)sender {
    CalculatorViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CalculatorVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)cancleBuy:(id)sender {
    [self hiddenBuyInfoView:nil];
}

- (IBAction)hiddenBuyInfoView:(id)sender {
    if (_isKeyBoardShow) {
        [self.bbcTF resignFirstResponder];
        [self.usdtTF resignFirstResponder];
        [self.allBBCTF resignFirstResponder];
        for (int i = 20; i < 26; i++) {
            UITextView *tf = (UITextView *)[self.view viewWithTag:i];
            [tf resignFirstResponder];
        }
        return;
    }
    self.bgButton.hidden = YES;
    self.buyInfoView.hidden = YES;
//    self.payView.hidden = YES;
    [self.bbcTF resignFirstResponder];
    [self.usdtTF resignFirstResponder];
    [self.allBBCTF resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 0) {
        textView.text = [textView.text substringToIndex:1];
    }
    int x = 0;
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"a", @"a", @"a", @"a", @"a", @"a", nil];
    for (int i = 20; i < 26; i++) {
        UITextView *tf = (UITextView *)[self.view viewWithTag:i];
        if (tf.text.length>0) {
            x++;
            [array replaceObjectAtIndex:i-20 withObject:tf.text];
            if (x == 6) {
                NSLog(@"%@", array);
                // 验证支付密码
                //                [self pay:[array componentsJoinedByString:@""]];
                _payString = [array componentsJoinedByString:@""];
                [self order];
            }
            continue;
        } else {
            if (textView.text.length < 1) {
                continue;
            }
            NSInteger y = 20;
            if (textView.tag == 6) {
                y = 20;
            } else {
                y = textView.tag;
            }
            UITextView *tv = (UITextView *)[self.view viewWithTag:y+1];
            [tv becomeFirstResponder];
        }
    }
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSInteger x = textView.tag;
    if (x == 20) {
        x = 27;
    }
    if ([text isEqualToString:@""]) {
        UITextView *tv = (UITextView *)[self.view viewWithTag:x-1];
        tv.text = @"";
        textView.text = @"";
        [tv becomeFirstResponder];
    }
    return YES;
}

-(void)textFieldEditChanged:(NSNotification *)obj
{
    UITextField *tf = obj.object;
    
    //    NSString *str = tf.text;
    //    if (tf == self.bbcTF) {
    ////        double p = 1.0/_parities;
    ////        int p1 = p*100;
    //        double d = [[_data objectForKey:@"userETHBalance"] doubleValue];
    //        if ([str doubleValue] > d*_parities) {
    //            tf.text = [NSString stringWithFormat:@"%.2lf", d*_parities];
    //        }
    //        self.usdtTF.text = [NSString stringWithFormat:@"%.2lf", [str doubleValue]/_parities];
    //
    //    } else if (tf == self.usdtTF) {
    //        if ([str doubleValue] > [[_data objectForKey:@"userETHBalance"] doubleValue]) {
    //            tf.text = [NSString stringWithFormat:@"%.2lf", [[_data objectForKey:@"userETHBalance"] doubleValue]];
    //        }
    ////        double p = 1/_parities;
    ////        int p1 = p*100;
    //        self.bbcTF.text = [NSString stringWithFormat:@"%.2lf", [tf.text doubleValue]*_parities];
    //        if ([self.usdtTF.text doubleValue] >= [[_data objectForKey:@"limitAmount"] doubleValue]) {
    //            self.warnImage.hidden = YES;
    //            self.warnLabel.hidden = YES;
    //        }
    //    } else if (tf == self.allBBCTF) {
    //        if ([[_data objectForKey:@"type"] isEqualToString:@"1"]) {
    //            if ([tf.text doubleValue] > [[_data objectForKey:@"userShareBBCBalance"] doubleValue]*0.1) {
    //                self.allBBCTF.text = [NSString stringWithFormat:@"%.2lf", [[_data objectForKey:@"userShareBBCBalance"] doubleValue]*0.1];
    //            }
    //        } else if ([[_data objectForKey:@"type"] isEqualToString:@"2"]) {
    //            if ([tf.text doubleValue] > [[_data objectForKey:@"userShareBBCBalance"] doubleValue]) {
    //                self.allBBCTF.text = [NSString stringWithFormat:@"%@", [_data objectForKey:@"userShareBBCBalance"]];
    //            }
    //        }
    //    }
    if (tf.text.length == 0) {
        //        self.bbcTF.text = @"";
        self.usdtTF.text = @"";
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField.text rangeOfString:@"."].location==NSNotFound) {
        _isHaveDian = NO;
    }
    if ([string length]>0){
        unichar single=[string characterAtIndex:0];//当前输入的字符
        if ((single >='0' && single<='9') || single=='.'){
            //首字母不能为0和小数点
            if([textField.text length]==0){
                if(single == '.'){
                    //                    [self alertView:@"亲，第一个数字不能为小数点"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
                if (single == '0') {
                    //                    [self alertView:@"亲，第一个数字不能为0"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            if (single=='.'){
                if(!_isHaveDian){
                    _isHaveDian=YES;
                    return YES;
                }else{
                    //                    [self alertView:@"亲，您已经输入过小数点了"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }else{
                if (_isHaveDian) {
                    //判断小数点的位数
                    NSRange ran=[textField.text rangeOfString:@"."];
                    NSInteger tt = range.location - ran.location;
                    if (tt <= 2){
                        return YES;
                    }else{
                        //                        [self alertView:@"亲，您最多输入两位小数"];
                        return NO;
                    }
                }else{
                    return YES;
                }
            }
        }else{//输入的数据格式不正确
            //            [self alertView:@"亲，您输入的格式不正确"];
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }else{
        return YES;
    }
}

//键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
    //    //获取键盘高度，在不同设备上，以及中英文下是不同的
    //    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    //
    //    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
    //    CGFloat offset = (_tf.frame.size.height - kbHeight);
    //
    //    //textView到self.view原点的距离
    //    CGFloat tv = _tf.frame.origin.y;
    //
    //    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    //    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //    NSLog(@"%lf",self.frame.origin.y);
    //    //将视图上移计算好的偏移
    //    //    if(offset > 0) {
    //    //        [UIView animateWithDuration:10.0 animations:^{
    //    self.frame = CGRectMake(0.0f, offset-25, self.frame.size.width, self.frame.size.height);
    //    //        }];
    //    //    }
    //    NSLog(@"%lf",self.frame.origin.y);
    _isKeyBoardShow = YES;
    
    self.buyInfoView.frame = CGRectMake(self.buyInfoView.frame.origin.x, 64, self.buyInfoView.frame.size.width, self.buyInfoView.frame.size.height);
}

//键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {
    //    // 键盘动画时间
    //    //    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //
    //    //视图下沉恢复原状
    //    //    [UIView animateWithDuration:10.0 animations:^{
    //    self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    //    //    }];
    _isKeyBoardShow = NO;
    
    self.buyInfoView.frame = _rect;
    
}
- (IBAction)callBtnClick:(id)sender {
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"075589301180"];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
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
