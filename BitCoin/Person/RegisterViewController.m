//
//  RegisterViewController.m
//  BitCoin
//
//  Created by LBH on 2017/9/23.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import "RegisterViewController.h"
#import "CaptchaViewController.h"
#import "ServiceExplainViewController.h"

@interface RegisterViewController () {
    UIColor *_color;
    int _secondsCountDown; //倒计时总时长
    NSTimer *_countDownTimer;
    NSString *_codeMSG;
}

@end

@implementation RegisterViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setBarBlackColor:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.registerBtn.layer setMasksToBounds:YES];
    self.registerBtn.layer.cornerRadius = 8;
    
    [self.bgView.layer setMasksToBounds:YES];
    self.bgView.layer.cornerRadius = 6;
    [self.bgView.layer setBorderWidth:1];
    [self.bgView.layer setBorderColor:[UIColor whiteColor].CGColor];
    
    [self.sendBtn.layer setMasksToBounds:YES];
    self.sendBtn.layer.cornerRadius = 4;
    //    [self.registerBtn setBackgroundImage:[UIImage imageNamed:@"不可登录.png"] forState:UIControlStateNormal];
    //    _color = self.registerBtn.titleLabel.textColor;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRegisterBtnColor) name:UITextFieldTextDidChangeNotification object:nil];
    _codeMSG = @"";
    self.phoneNumberTF.returnKeyType =UIReturnKeyDone;
    
    
    if (self.isFindID) {
        self.invitaCodeImgV.image = [UIImage imageNamed:@"pndqy_icon.png"];
        self.inviteTf.placeholder = @"请确认新密码";
        [self.registerBtn setTitle:@"确认" forState:UIControlStateNormal];
    }
    
}

- (void) changeRegisterBtnColor
{
    if (self.phoneNumberTF.text.length==11) {
        //        [self.registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //        [self.registerBtn setBackgroundImage:[UIImage imageNamed:@"可登陆.png"] forState:UIControlStateNormal];
        
    } else {
        //        [self.registerBtn setTitleColor:_color forState:UIControlStateNormal];
        //        [self.registerBtn setBackgroundImage:[UIImage imageNamed:@"不可登录.png"] forState:UIControlStateNormal];
        
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.phoneNumberTF.text.length == 11) {
        //            [self.registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //            [self.registerBtn setBackgroundImage:[UIImage imageNamed:@"可登陆.png"] forState:UIControlStateNormal];
        
    }
    return YES;
}

- (IBAction)selectCountryBtnClick:(id)sender {
    
}


- (void)requestCheckPhoneIsRegister{
    
    __weak __typeof(self) weakSelf = self;
    NSDictionary *dic = @{@"phone": self.phoneNumberTF.text};
    
    
    [[NetworkTool sharedTool] requestWithURLString:@"/checkPhoneIsRegister" parameters:dic method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@", stringData, JSON );
        //        NSString *isError = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {//新用户可以注册
            [self Countdown];
            [self sendCode];
        } else {
            [self showToastWithMessage:@"该手机号已注册"];
        }
    } failed:^(NSError *error) {
        //        [weakSelf requestError];
    }];
}
///

- (void) request
{
    
    __weak __typeof(self) weakSelf = self;
    NSDictionary *dic;
    NSString *url;
    if (self.isFindID) {//找回密码
        //forgetLoginPwd
        if (![self.passwordTF.text isEqualToString:self.inviteTf.text]) {
            [self showToastWithMessage:@"两次输入的密码不一致"];
            return;
        }
        dic = @{@"phone": self.phoneNumberTF.text,@"loginPassword":[self md5:[NSString stringWithFormat:@"%@",self.passwordTF.text]]};
        url = @"/forgetLoginPwd";
    }else{
        dic = @{@"phone": self.phoneNumberTF.text,@"loginPassword":[self md5:[NSString stringWithFormat:@"%@%@",self.passwordTF.text,self.phoneNumberTF.text]],@"comeFrom":@"app",@"inviteYards":self.inviteTf.text};//,@"smsCode":self.codeTF.text
        url = @"/register";
    }
    
    
    
    
    
    
    [[NetworkTool sharedTool] requestWithURLString:url parameters:dic method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@", stringData, JSON );
        //        NSString *isError = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            //            [weakSelf performSelectorOnMainThread:@selector(verifyPass) withObject:nil waitUntilDone:YES];
            //            [self.navigationController popToRootViewControllerAnimated:YES];
            if(weakSelf.isFindID){
                [self showToastWithMessage:@"修改密码成功！"];
            }else{
                [self showToastWithMessage:@"创建账号成功！"];
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            //            [weakSelf performSelectorOnMainThread:@selector(showToastWithMessage:) withObject:[JSON objectForKey:@"msg"] waitUntilDone:YES];
        }
    } failed:^(NSError *error) {
        //        [weakSelf requestError];
    }];
}
- (void) sendCode
{
    __weak __typeof(self) weakSelf = self;
    NSDictionary *dic = @{@"phone": self.phoneNumberTF.text, @"timestamp":[NSString stringWithFormat:@"%ld",(long)([[NSDate date] timeIntervalSince1970])], @"auth":@"minant", @"q":@"q"};
    [[NetworkTool sharedTool] requestWithURLString:@"sms/sendSmsCode" parameters:dic method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@",stringData, JSON );
        //        NSString *isError = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            
        } else {
            [weakSelf performSelectorOnMainThread:@selector(showToastWithMessage:) withObject:[JSON objectForKey:@"msg"] waitUntilDone:YES];
        }
    } failed:^(NSError *error) {
        [weakSelf requestError];
    }];
}

- (void) requestCode : (NSString *)string
{
    __weak __typeof(self) weakSelf = self;
    NSDictionary *dic = @{@"phone": self.phoneNumberTF.text, @"smsCode":self.codeTF.text};
    [[NetworkTool sharedTool] requestWithURLString:@"sms/validSmsCode" parameters:dic method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@",stringData, JSON );
        //        NSString *isError = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            _codeMSG = @"";
            //            [weakSelf verifyPass];
            //            [weakSelf performSelectorOnMainThread:@selector(verify:) withObject:@"1" waitUntilDone:YES];
        } else {
            _codeMSG = @"验证码x错误，请重新输入。";
            //            [weakSelf performSelectorOnMainThread:@selector(verify:) withObject:@"0" waitUntilDone:YES];
        }
    } failed:^(NSError *error) {
        [weakSelf requestError];
    }];
}

- (IBAction)registerBtnClick:(id)sender {
    if (self.passwordTF.text.length<6) {
        [self showToastWithMessage:@"请输入6-18位密码"];
        return;
    }
    if (self.inviteTf.text.length < 1) {
        [self showToastWithMessage:@"请输入邀请码"];
        return;
    }
    if (self.phoneNumberTF.text.length<1) {
        [self showToastWithMessage:@"请完善信息"];
        return;
    }
    if (self.inviteTf.text.length<6&&self.inviteTf.text.length>0) {
        [self showToastWithMessage:@"请完善信息"];
        return;
    }
    [self request];
}

- (void) verifyPass
{
    CaptchaViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CaptchaVC"];
    vc.phoneNum = [NSString stringWithFormat:@"%@ %@", self.AreaCodeLabel.text, self.phoneNumberTF.text];
    vc.phone = self.phoneNumberTF.text;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)agreeBtnClick:(id)sender {
    ServiceExplainViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ServiceExplainVC"];
    vc.UrlString = [NSString stringWithFormat:@"%@%@", REQUEST_URL_STRING,@"register_protocol.html"];
    [self presentViewController:vc animated:YES completion:nil];
}
- (IBAction)reSendBtnClick:(id)sender {
    if (self.phoneNumberTF.text.length>0) {
        if (self.isFindID){
            [self Countdown];
            [self sendCode];
        }else{
            [self requestCheckPhoneIsRegister];
        }
        
        
    } else {
        [self showToastWithMessage:@"请输入手机号"];
    }
}

- (void) Countdown
{
    _secondsCountDown = 120;
    _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES]; //启动倒计时后会每秒钟调用一次方法 timeFireMethod
    [self.sendBtn setTitle:@"120秒重新发送" forState:UIControlStateNormal];
}

-(void)timeFireMethod{
    _secondsCountDown--;
    if(_secondsCountDown==0){
        [_countDownTimer invalidate];
        _countDownTimer = nil;
        [self.sendBtn setTitle:[NSString stringWithFormat:@"发送验证码"] forState:UIControlStateNormal];
        return;
    }
    [self changeTipLabel];
}

- (void) changeTipLabel
{
    [self.sendBtn setTitle:[NSString stringWithFormat:@"%d秒重新发送", _secondsCountDown] forState:UIControlStateNormal];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField == self.codeTF) {
        if (textField.text.length == 6) {
            [self requestCode:textField.text];
        }
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{  //string就是此时输入的那个字符 textField就是此时正在输入的那个输入框 返回YES就是可以改变输入框的值 NO相反
    
    if ([string isEqualToString:@"\n"])  //按会车可以改变
    {
        return YES;
    }
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    
    if (self.codeTF == textField)  //判断是否时我们想要限定的那个输入框
    {
        if ([toBeString length] > 6) { //如果输入框内容大于20则弹出警告
            return NO;
        }
    }
    return YES;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.phoneNumberTF resignFirstResponder];
    [self.codeTF resignFirstResponder];
    [self.passwordTF resignFirstResponder];
    [self.inviteTf resignFirstResponder];
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
