//
//  CoinInComeViewController.m
//  BitCoin
//
//  Created by LBH on 2018/9/18.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "CoinInComeViewController.h"
#import "CreatQRCode.h"
#import "RSAEncryptor.h"
#import "CoinInfoViewController.h"

@interface CoinInComeViewController ()

@end

@implementation CoinInComeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.bgView.layer setMasksToBounds:YES];
    self.bgView.layer.cornerRadius = 4;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [defaults objectForKey:@"phoneNum"];
    NSString *originalString = [NSString stringWithFormat:@"%@xiaomayi", string];
    //    使用.der和.p12中的公钥私钥加密解密
    NSString *public_key_path = [[NSBundle mainBundle] pathForResource:@"public_key.der" ofType:nil];
//    NSString *private_key_path = [[NSBundle mainBundle] pathForResource:@"private_key.p12" ofType:nil];
    
    NSString *encryptStr = [RSAEncryptor encryptString:originalString publicKeyWithContentsOfFile:public_key_path];
//    NSLog(@"加密前:%@", originalString);
//    NSLog(@"加密后:%@", encryptStr);
//    NSLog(@"解密后:%@", [RSAEncryptor decryptString:@"QDIAucbvTOK82PmmtRsX2+1w6h/JnHkKzLLo6d2hFwTbwXrDi+xExmMWgARf7ezJt4WwJpUw/i43crUSsoXfWWexzPDlwIoNmY2h6N9fSrmMMo0phO0/FOoJSqD0Qhz4N1pm0I1Tqbixu5/Y2ofDLhjCAqri9N4SDsGlDO1tyBI=" privateKeyWithContentsOfFile:private_key_path password:@""]);

    self.QRCodeImage.image = [CreatQRCode qrImageForString:encryptStr imageSize:356 logoImageSize:0];
}

- (IBAction)saveImageBtnClick:(id)sender {
//    self.view.backgroundColor= [UIColor greenColor];
    
    UIWindow*screenWindow = [[UIApplication sharedApplication]keyWindow];
    
//    UIGraphicsBeginImageContext(screenWindow.frame.size);
    UIGraphicsBeginImageContextWithOptions(screenWindow.frame.size, NO, 0.0); //currentView 当前的view  创建一个基于位图的图形上下文并指定大小为

    [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];//renderInContext呈现接受者及其子范围到指定的上下文
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();//返回一个基于当前图形上下文的图片
    UIGraphicsEndImageContext();//移除栈顶的基于当前位图的图形上下文
    UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);//然后将该图片保存到图片图
    
    [self showToastWithMessage:@"保存成功"];
}

- (IBAction)recordBtnClick:(id)sender {
    CoinInfoViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CoinInfoVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
