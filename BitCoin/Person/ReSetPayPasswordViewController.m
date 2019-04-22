//
//  ReSetPayPasswordViewController.m
//  BitCoin
//
//  Created by mac on 2019/4/23.
//  Copyright © 2019 LBH. All rights reserved.
//

#import "ReSetPayPasswordViewController.h"

@interface ReSetPayPasswordViewController (){
    int _secondsCountDown;
    NSTimer *_countDownTimer;
}

@end

@implementation ReSetPayPasswordViewController
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestSMS];
    [self.timeBtn setEnabled:NO];
}

- (IBAction)timeBtn:(id)sender {
    [self requestSMS];
}


-(void)requestSMS{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    NSString *phone = [defaults objectForKey:@"phoneNum"];
    
    __weak __typeof(self) weakSelf = self;
    
    
    
    NSDictionary *dic = @{@"phone": phone, @"timestamp":[self getTimeTimestamp], @"auth":@"minant", @"q":@"q"};
    
    [[NetworkTool sharedTool] requestWithURLString:@"/sms/sendSmsCode" parameters:dic method:@"POST" completed:^(id JSON, NSString *stringData) {
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

- (void) Countdown
{
    _secondsCountDown = 120;
    _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES]; //启动倒计时后会每秒钟调用一次方法 timeFireMethod
    [self.timeBtn setTitle:@"120秒重新发送" forState:UIControlStateNormal];
}

-(void)timeFireMethod{
    _secondsCountDown--;
    if(_secondsCountDown==0){
        [_countDownTimer invalidate];
        _countDownTimer = nil;
        [self.timeBtn setTitle:[NSString stringWithFormat:@"发送验证码"] forState:UIControlStateNormal];
        [self.timeBtn setEnabled:YES];
        return;
    }
    [self.timeBtn setTitle:[NSString stringWithFormat:@"%d秒重新发送",_secondsCountDown] forState:UIControlStateNormal];
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"adadfas");
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSLog(@"text:%@---%@",string,textField.text);
    return YES;
}


@end
