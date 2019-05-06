//
//  BaseViewController.m
//  BitCoin
//
//  Created by LBH on 2017/9/27.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import "BaseViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareSheetConfiguration.h>
#import "YWUnlockView.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *str = [NSString stringWithFormat:@"%@", NSStringFromClass([self class])];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    NSArray *array = [NSArray arrayWithObjects:@"MarketViewController", @"MoneyHPViewController", @"StoreHPViewController", @"MiningHPViewController", @"PersonHomeViewController", @"MonitoringViewController", @"RunHPViewController", @"NewsViewController", @"NewMiningHPViewController", @"NewStoreHPViewController", @"NewNewsViewController", @"NewPersonHomeViewController", nil];
    
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
    [YWUnlockView deleteGesturesPassword];

    [defaults synchronize];
    [self showToastWithMessage:@"登录身份过期"];
    NSArray <UIViewController *> *childViewControllers = self.navigationController.childViewControllers;
    if (childViewControllers.count>=2) {
        double delayInSeconds = 3;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_global_queue(0,0), ^(void){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        });
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
-(NSString *)getTimeTimestamp{
    
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval a=[dat timeIntervalSince1970];
    
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    
    ;
    
    return timeString;
    
}

- (void) showService
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"联系客服微信号：TAF-GTSE" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"复制" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
        pastboard.string = @"TAF-GTSE";
        [self showToastWithMessage:@"复制成功"];
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void) shareImageViewWithView:(UIView *)view
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params SSDKSetupShareParamsByText:nil images:@[[self makeImageWithView:view withSize:view.frame.size]] url:nil title:nil type:SSDKContentTypeImage];
    
    NSArray *items = nil;
        items = @[
                  @(SSDKPlatformTypeQQ),
                  @(SSDKPlatformTypeWechat),
                  @(SSDKPlatformSubTypeWechatTimeline),
                  @(SSDKPlatformSubTypeWechatSession),
                  @(SSDKPlatformSubTypeQQFriend),
                  @(SSDKPlatformSubTypeQZone)
                  ];
    SSUIShareSheetConfiguration *config = [[SSUIShareSheetConfiguration alloc] init];
    [ShareSDK showShareActionSheet:nil customItems:items shareParams:params sheetConfiguration:config onStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
        switch (state) {
            case SSDKResponseStateUpload:
                // 分享视频的时候上传回调，进度信息在 userData
                break;
            case SSDKResponseStateSuccess:
                //成功
                [self showToastWithMessage:@"分享成功！"];
                break;
            case SSDKResponseStateFail:
            {
                NSLog(@"--%@",error.description);
                //失败
                [self showToastWithMessage:@"分享失败！"];
                break;
            }
            case SSDKResponseStateCancel:
                //取消
                [self showToastWithMessage:@"已取消分享！"];
                break;
            default:
                break;
        }
    }];
    /*
    [ShareSDK share:SSDKPlatformTypeQQ parameters:params onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        switch (state) {
            case SSDKResponseStateUpload:
                // 分享视频的时候上传回调，进度信息在 userData
                break;
            case SSDKResponseStateSuccess:
                //成功
                [self showToastWithMessage:@"分享成功！"];
                break;
            case SSDKResponseStateFail:
            {
                NSLog(@"--%@",error.description);
                //失败
                [self showToastWithMessage:@"分享失败！"];
                break;
            }
            case SSDKResponseStateCancel:
                //取消
                [self showToastWithMessage:@"已取消分享！"];
                break;
            default:
                break;
        }
    }];
     */
}


- (UIImage *)makeImageWithView:(UIView *)view withSize:(CGSize)size
{
    // 第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，关键就是第三个参数 [UIScreen mainScreen].scale。
//    UIGraphicsBeginImageContextWithOptions(size, YES, [UIScreen mainScreen].scale);
//    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
//    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
//    size = CGSizeMake(100, 100);
    UIView *v = view;
    UIGraphicsBeginImageContext(size);
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

- (void)inputPayPasswordWithPayTip:(NSString *)tip andPrice:(NSString *)price
{
    payPasswordView *view = [[payPasswordView alloc] initWithFrame:self.view.bounds];
    view.delegate =self;
    [self.view addSubview:view];
    view.payNameLabel.text = tip;
    view.payNumLabel.text = [NSString stringWithFormat:@"%.2lf GTSE", [price doubleValue]];
    [view.firstTV becomeFirstResponder];
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
