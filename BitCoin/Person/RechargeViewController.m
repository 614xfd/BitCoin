//
//  RechargeViewController.m
//  BitCoin
//
//  Created by LBH on 2018/5/22.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "RechargeViewController.h"
#import "HowViewController.h"

@interface RechargeViewController ()

@end

@implementation RechargeViewController

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
    self.scroll.contentSize = CGSizeMake(self.view.frame.size.width, 547*kScaleH);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenTV)];
    [self.scroll addGestureRecognizer:tap];
    [self request];
    self.titleLabel.text = [NSString stringWithFormat:@"%@转入", self.coinName];
    self.tipLabel.text = [NSString stringWithFormat:@"请将%@转入下面地址", self.coinName];
//    [self.textView.layer setBorderWidth:1.0];
//    [self.textView.layer setBorderColor:[UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1].CGColor];
}

- (void) setAddress:(NSArray *)array
{
    for (int i = 0; i < array.count; i++) {
        NSString *string = [[array objectAtIndex:i] objectForKey:@"type"];
        if ([string caseInsensitiveCompare:self.coinName] == NSOrderedSame) {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", IMAGE_URL, [[array objectAtIndex:i] objectForKey:@"img"]]];
            [self.addressImage sd_setImageWithURL:url];
            self.addressLabel.text = [NSString stringWithFormat:@"%@", [[array objectAtIndex:i] objectForKey:@"path"]];
        }
    }
}

- (void) request
{
    __weak __typeof(self) weakSelf = self;
    [[NetworkTool sharedTool] requestWithURLString:@"UserAccount/newFindAllPath" parameters:nil method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@", stringData, JSON );
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            [weakSelf performSelectorOnMainThread:@selector(setAddress:) withObject:[JSON objectForKey:@"Data"] waitUntilDone:YES];
        } else {

        }
    } failed:^(NSError *error) {
        //        [weakSelf requestError];
    }];
//    [[NetworkTool sharedTool] requestWithHPURLString:@"http://192.168.0.109:8080/Bitboss/UserAccount/newFindAllPath" parameters:nil method:@"POST" completed:^(id JSON, NSString *stringData) {
//        NSLog(@"%@      ------------- %@", stringData, JSON );
//        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
//        if ([code isEqualToString:@"1"]) {
//            [weakSelf performSelectorOnMainThread:@selector(setAddress:) withObject:[JSON objectForKey:@"Data"] waitUntilDone:YES];
//        } else {
//
//        }
//    } failed:^(NSError *error) {
//        //        [weakSelf requestError];
//    }];
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length>0) {
        self.tipLabel.hidden = YES;
    } else {
        self.tipLabel.hidden = NO;
    }
    ///> 计算文字高度
    CGFloat height = ceilf([textView sizeThatFits:CGSizeMake(textView.frame.size.width, MAXFLOAT)].height);
    if (height >= 100) {
        textView.scrollEnabled = YES;   ///> 当textView高度大于等于最大高度的时候让其可以滚动
        height = 100;                   ///> 设置最大高度
    }
    ///> 重新设置frame, textView往上增长高度

    [UIView animateWithDuration:0.3 animations:^{
        textView.frame = CGRectMake(textView.frame.origin.x, CGRectGetMaxY(textView.frame) - height, textView.frame.size.width, height);
        [textView layoutIfNeeded];
        
    }];

}

- (void) success
{
    [self showToastWithMessage:@"已提交审核，请耐心等待"];
    double delayInSeconds = 2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_global_queue(0,0), ^(void){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    });
}

- (IBAction)copyBtnClick:(id)sender {
}

- (IBAction)finishBtnClick:(id)sender {
    if (self.textView.text.length>0) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *uid = [defaults objectForKey:@"uid"];
        __weak __typeof(self) weakSelf = self;
        NSDictionary *d = @{@"id":uid,@"path":self.textView.text};
        [[NetworkTool sharedTool] requestWithURLString:@"UserAccount/rechargeBBC" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
            NSLog(@"%@      ------------- %@", stringData, JSON );
            NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
            if ([code isEqualToString:@"1"]) {
                [weakSelf performSelectorOnMainThread:@selector(success) withObject:nil waitUntilDone:YES];
            } else {

            }
        } failed:^(NSError *error) {
            //        [weakSelf requestError];
        }];
//        [[NetworkTool sharedTool] requestWithHPURLString:@"http://192.168.0.109:8080/Bitboss/UserAccount/rechargeETH" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
//            NSLog(@"%@      ------------- %@", stringData, JSON );
//            NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
//            if ([code isEqualToString:@"1"]) {
//                [weakSelf performSelectorOnMainThread:@selector(success) withObject:nil waitUntilDone:YES];
//            } else {
//
//            }
//        } failed:^(NSError *error) {
//            //        [weakSelf requestError];
//        }];
//
    } else {
        [self showToastWithMessage:@"请输入交易ID"];
    }
    
}

- (IBAction)call:(id)sender {
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"075589301180"];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

- (IBAction)howBtnClick:(id)sender {
    HowViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HowVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) hiddenTV
{
    [self.textView resignFirstResponder];
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.textView resignFirstResponder];
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
