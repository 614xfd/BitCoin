//
//  BaseViewController.m
//  BitCoin
//
//  Created by LBH on 2017/9/27.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *str = [NSString stringWithFormat:@"%@", NSStringFromClass([self class])];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    NSArray *array = [NSArray arrayWithObjects:@"MarketViewController", @"MoneyHPViewController", @"StoreHPViewController", @"MiningHPViewController", @"PersonHomeViewController", @"MonitoringViewController", @"RunHPViewController", @"NewsViewController", @"NewMiningHPViewController", @"NewStoreHPViewController", @"NewNewsViewController", nil];
    
    BOOL _isHomePage = NO;
    for (NSString *s in array) {
        if ([s isEqualToString:str]) {
            _isHomePage = YES;
            if ([str isEqualToString:@"RunHPViewController"]) {
                [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
            }
        }
    }
    [self setNeedsStatusBarAppearanceUpdate];
    if (_isHomePage) {
        self.tabBarController.tabBar.hidden = YES;
        
        NSArray *arrayView=self.tabBarController.view.subviews;
        for (UIView *view in arrayView) {
            if (view.tag == 10086) {
                view.hidden = NO;
            }
        }
    } else {
        self.tabBarController.tabBar.hidden = YES;
        NSArray *arrayView=self.tabBarController.view.subviews;
        for (UIView *view in arrayView) {
            if (view.tag == 10086) {
                view.hidden = YES;
            }
        }
    }
    //    [self showTitle];
}

- (void) setBarBlackColor:(BOOL)isBlack
{
    if (isBlack) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    } else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    //    self.scale = 1.0;
    //    if ([UIScreen mainScreen].bounds.size.height == 736) {
    //        self.scale = 1.103;
    //    } else if ([UIScreen mainScreen].bounds.size.height == 480) {
    //        self.scale = 0.7196;
    //    } else if ([UIScreen mainScreen].bounds.size.height == 568) {
    //        self.scale = 0.851;
    //    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenError)name:@"TOKEN_ERROR" object:nil];
}

//MD5加密
- (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (void) requestError
{
    ToastView *tv = [[ToastView alloc] initWithFrame:self.view.bounds WithMessage:@"请求超时，请检查网络！"];
    [self.view addSubview:tv];
}

- (void) showToastWithMessage:(NSString *)string
{
    ToastView *tv = [[ToastView alloc] initWithFrame:self.view.bounds WithMessage:string];
    [self.view addSubview:tv];
}

- (void) tokenError
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"isLogin"];
    [defaults removeObjectForKey:@"phoneNum"];
    [defaults removeObjectForKey:@"uid"];
    [defaults removeObjectForKey:@"authenticationStatus"];
    [defaults removeObjectForKey:@"paymentPasswordStatus"];
    [defaults removeObjectForKey:@"token"];
    [defaults synchronize];
    [self showToastWithMessage:@"登录身份过期"];
    NSArray <UIViewController *> *childViewControllers = self.navigationController.childViewControllers;
    if (childViewControllers.count>2) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (BOOL)inputShouldNumber:(NSString *)inputString {
    if (inputString.length == 0) return NO;
    NSString *regex =@"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:inputString];
}

- (BOOL)inputShouldLetter:(NSString *)inputString {
    if (inputString.length == 0) return NO;
    NSString *regex =@"[a-zA-Z]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:inputString];
}

//  判断是否纯汉字
//- (BOOL)inputShouldChinese:(NSString *)inputString {
//    if (inputString.length == 0) return NO;
//    NSString *regex = @"[\u4e00-\u9fa5]+";
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
//    return [pred evaluateWithObject:inputString];
//}

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
