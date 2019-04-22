//
//  CalculatorViewController.m
//  BitCoin
//
//  Created by LBH on 2018/5/22.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "CalculatorViewController.h"
#define Color [UIColor colorWithRed:193/255.0 green:169/255.0 blue:107/255.0 alpha:1]
#define wColor [UIColor whiteColor]
@interface CalculatorViewController () {
    BOOL _isDay;
}

@property (nonatomic, assign) BOOL isHaveDian;
@end

@implementation CalculatorViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setBarBlackColor:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSDate *date=[NSDate date];
    NSDateFormatter *format1=[[NSDateFormatter alloc] init];
    [format1 setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *dateStr=[[[format1 stringFromDate:date] componentsSeparatedByString:@" "] firstObject];
    self.nowDayLabel.text = dateStr;
    _isDay = YES;
    [self.btnBGView.layer setBorderWidth:1.0];
    [self.btnBGView.layer setBorderColor:Color.CGColor];
    [self.btnBGView.layer setMasksToBounds:YES];
    self.btnBGView.layer.cornerRadius = 4;

    [self.yBtn.layer setMasksToBounds:YES];
    self.yBtn.layer.cornerRadius = 4;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEditChanged:) name:UITextFieldTextDidChangeNotification object:self.rateTF];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEditChanged:) name:UITextFieldTextDidChangeNotification object:self.dayTF];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEditChanged:) name:UITextFieldTextDidChangeNotification object:self.moneyTF];

}

-(void)textFieldEditChanged:(NSNotification *)obj
{
    UITextField *tf = obj.object;
    if (tf == self.rateTF) {
        self.rateLabel.text = [NSString stringWithFormat:@"%.2lf", [self.rateTF.text doubleValue]];
    }
    if (self.rateTF.text.length > 0 || self.dayTF.text.length > 0 || self.moneyTF.text.length > 0) {
        double a = [self.moneyTF.text doubleValue];
        double b = [self.rateTF.text doubleValue];
        double c = [self.dayTF.text doubleValue];
        if (!_isDay) {
            c *= 30;
        }
        double s = a*b/100*c/365.0;
        self.earningsLabel.text = [NSString stringWithFormat:@"%.2lf", s];
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

- (IBAction)changeBtnClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 1) {
        self.dBtn.backgroundColor = wColor;
        [self.dBtn setTitleColor:Color forState:UIControlStateNormal];
        _isDay = NO;

    } else if (btn.tag == 2) {
        self.mBtn.backgroundColor = wColor;
        [self.mBtn setTitleColor:Color forState:UIControlStateNormal];
        _isDay = YES;
    }
    btn.backgroundColor = Color;
    [btn setTitleColor:wColor forState:UIControlStateNormal];
    self.dayTF.text = @"";
    [self.dayTF becomeFirstResponder];
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
