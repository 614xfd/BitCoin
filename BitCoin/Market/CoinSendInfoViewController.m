//
//  CoinSendInfoViewController.m
//  BitCoin
//
//  Created by LBH on 2018/9/19.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "CoinSendInfoViewController.h"
#import "CoinSendSuccessViewController.h"
#import "CoinInfoViewController.h"

@interface CoinSendInfoViewController () {
    CGRect _rect;
    BOOL _isHaveDian;
    NSString *_bbcBalance;
}

@end

@implementation CoinSendInfoViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setBarBlackColor:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.phoneLabel.text = [NSString stringWithFormat:@"账户:%@", [self numberSuitScanf:self.phoneString]];
    _rect = self.payView.frame;
    [self.bgView.layer setMasksToBounds:YES];
    self.bgView.layer.cornerRadius = 4;
    [self.payView.layer setMasksToBounds:YES];
    self.payView.layer.cornerRadius = 5;
    [self.payTVView.layer setBorderWidth:0.5];
    [self.payTVView.layer setBorderColor:[UIColor colorWithRed:159/255.0 green:159/255.0 blue:159/255.0 alpha:1].CGColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payPassWord:) name:UITextFieldTextDidChangeNotification object:nil];
    _bbcBalance = @"";
    [self.numberTF becomeFirstResponder];
    [self requestBalance];
}

- (void) setTFP
{
    //    self.numberTF.placeholder = [NSString stringWithFormat:@"最大可转%.2lfBBC", [_bbcBalance doubleValue]*0.05];
}

- (void) requestBalance
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    if (token.length) {
        __weak __typeof(self) weakSelf = self;
        NSDictionary *d = @{@"token":token};
        
        
        
        [[NetworkTool sharedTool] requestWithURLString:@"/v1/user/account/info" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
            NSLog(@"%@      ------------- %@", stringData, JSON );
            NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
            if ([code isEqualToString:@"1"]) {
                NSDictionary *data = [JSON objectForKey:@"data"];
                
                _bbcBalance = data[@"normal"];
                //                for (NSDictionary *dic in array) {
                //                    NSString *type = [dic objectForKey:@"type"];
                //                    if ([type compare:@"BBC" options:NSCaseInsensitiveSearch | NSNumericSearch] == NSOrderedSame) {
                //                        _bbcBalance = [NSString stringWithFormat:@"%@", [dic objectForKey:@"balance"]];
                //                        [weakSelf performSelectorOnMainThread:@selector(setTFP) withObject:nil waitUntilDone:YES];
                //                    }
                //                }
                
            } else {
                
            }
        } failed:^(NSError *error) {
            //        [weakSelf requestError];
        }];
    }
}

- (void) requestWithPW:(NSString *) string {
    if (self.numberTF.text.length < 1) {
        [self showToastWithMessage:@"请输入数量"];
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    NSString *phoneNum = [defaults objectForKey:@"phoneNum"];
    
    //    [self md5:[NSString stringWithFormat:@"%@%@",[self.numArray componentsJoinedByString:@""],phoneNum]]
    if (token.length) {
        __weak __typeof(self) weakSelf = self;
        NSString *password = [self md5:[NSString stringWithFormat:@"%@%@",string,phoneNum]];
        NSDictionary *dic = @{@"token": token, @"money":self.numberTF.text, @"payPass":password, @"toPhone":self.phoneString};
        [[NetworkTool sharedTool] requestWithURLString:@"/v1/account/transfer" parameters:dic method:@"POST" completed:^(id JSON, NSString *stringData) {
            NSLog(@"%@      ------------- %@", stringData, JSON );
            //        NSString *isError = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
            NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
            if ([code isEqualToString:@"1"]) {
                [weakSelf performSelectorOnMainThread:@selector(sendSuccess) withObject:nil waitUntilDone:YES];
            } else {
                [weakSelf performSelectorOnMainThread:@selector(showToastWithMessage:) withObject:[JSON objectForKey:@"msg"] waitUntilDone:YES];
            }
        } failed:^(NSError *error) {
            //        [weakSelf requestError];
        }];
    }
}

- (void) sendSuccess
{
    CoinSendSuccessViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CoinSendSuccessVC"];
    vc.numberString = self.numberTF.text;
    vc.phoneString = [self numberSuitScanf:self.phoneString];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)sendBtnClick:(id)sender {
    
    
    
    self.payNumLabel.text = [NSString stringWithFormat:@"%@", self.numberTF.text];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    self.bgBtn.alpha = 0.25;
    self.payView.alpha = 1;
    [UIView commitAnimations];
    UITextField *tv = (UITextField *)[self.view viewWithTag:20];
    [tv becomeFirstResponder];
}

- (IBAction)bgBtnClick:(id)sender {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    self.bgBtn.alpha = 0;
    self.payView.alpha = 0;
    [UIView commitAnimations];
    
    for (int i = 20; i < 26; i++) {
        UITextField *tf = [self.view viewWithTag:i];
        tf.text = @"";
    }
    
}

- (void) payPassWord : (NSNotification *)obj
{
    UITextField *tf = obj.object;
    if (tf == self.numberTF) {
        if (tf.text.length < 1) {
            self.sendImage.image = [UIImage imageNamed:@"转币输入值_03.png"];
        } else {
            self.sendImage.image = [UIImage imageNamed:@"转币输入值_06.png"];
        }
        
        if ([tf.text doubleValue] > [_bbcBalance doubleValue]) {
            tf.text = [NSString stringWithFormat:@"%.2lf", [_bbcBalance doubleValue] - [_bbcBalance doubleValue]*0.05];
            _isHaveDian = YES;
        }
        CGFloat s = [tf.text doubleValue];
        s = s*0.05;
        if (s>50.0) {
            s = 50.0;
        }
        self.chargeLabel.text = [NSString stringWithFormat:@"手续费(5%%) : %.2lfBBC(上限50.00GTSE)", s];
        return;
    }
    if (tf.text.length > 0) {
        tf.text = [tf.text substringToIndex:1];
    }
    int x = 0;
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"a", @"a", @"a", @"a", @"a", @"a", nil];
    for (int i = 20; i < 26; i++) {
        UITextField *t = (UITextField *)[self.view viewWithTag:i];
        if (t.text.length>0) {
            x++;
            [array replaceObjectAtIndex:i-20 withObject:t.text];
            if (x == 6) {
                NSLog(@"%@", array);
                // 验证支付密码
                [self requestWithPW:[array componentsJoinedByString:@""]];
            }
            continue;
        } else {
            break;
        }
    }
    NSInteger y = tf.tag;
    if (y == 25) {
        return;
    }
    UITextField *tv = (UITextField *)[self.view viewWithTag:y+1];
    [tv becomeFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.numberTF) {
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
        return YES;
    }
    
    if ([string isEqualToString:@""]) {
        for (int i = 20; i < 26; i++) {
            UITextField *tv = (UITextField *)[self.view viewWithTag:i];
            tv.text = @"";
        }
        UITextField *tv = (UITextField *)[self.view viewWithTag:20];
        [tv becomeFirstResponder];
    }
    return YES;
}

-(NSString *)numberSuitScanf:(NSString*)number
{
    if (number.length>10) {
        NSString *numberString = [number stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        return numberString;
    }
    return number;
}

//键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
    self.payView.frame = CGRectMake(self.payView.frame.origin.x, 164, self.payView.frame.size.width, self.payView.frame.size.height);
}

//键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {
    self.payView.frame = _rect;
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)coinInfoTap:(id)sender {
    CoinInfoViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CoinInfoVC"];
    [self.navigationController pushViewController:vc animated:YES];
    
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
