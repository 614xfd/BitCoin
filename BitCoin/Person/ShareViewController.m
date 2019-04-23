//
//  ShareViewController.m
//  BitCoin
//
//  Created by LBH on 2018/5/22.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "ShareViewController.h"
//#import <ShareSDK/ShareSDK.h>
//#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "CreatQRCode.h"

@interface ShareViewController ()

@end

@implementation ShareViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setBarBlackColor:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tipLabel.layer.cornerRadius = 4;
    [self.tipLabel.layer setMasksToBounds:YES];
    self.numLabel.layer.cornerRadius = 2;
    [self.numLabel.layer setMasksToBounds:YES];
    self.codeImageView.image = [CreatQRCode qrImageForString:[NSString stringWithFormat:@"http://www.bitboss.vg/regist.html?code=%@", _code] imageSize:self.codeImageView.frame.size.width logoImageSize:0];
    self.codeLabel.text = self.code;
    self.numLabel.text = [NSString stringWithFormat:@"您已邀请次数%@次", self.number];
    
}

- (IBAction)copyBtnClick:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.code;
    [self performSelectorOnMainThread:@selector(showToastWithMessage:) withObject:@"复制成功！" waitUntilDone:YES];
}

- (IBAction)shareBtnClick:(id)sender {
    //1、创建分享参数
//    NSArray* imageArray = @[[UIImage imageNamed:@"BTC.png"]];
    //    （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传image参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
//    if (imageArray) {
    
//        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//        [shareParams SSDKSetupShareParamsByText:@"注册成功立享15BBC"
//                                         images:@[[@"http://img.bitboss.cn/share.jpg" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
//                                            url:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.bitboss.vg/regist.html?code=%@", _code]]
//                                          title:@"BitBoss"
//                                           type:SSDKContentTypeAuto];
//        //有的平台要客户端分享需要加此方法，例如微博
//        [shareParams SSDKEnableUseClientShare];
        //        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        //        [shareParams SSDKSetupShareParamsByText:@"1"
        //                                         images:imageArray
        //                                            url:nil
        //                                          title:@"2"
        //                                           type:SSDKContentTypeAuto];
        ////        [shareParams SSDKSetupSinaWeiboShareParamsByText:@"3" title:nil image:nil url:nil latitude:0 longitude:0 objectID:nil type:SSDKContentTypeAuto];
        //
        //        [shareParams SSDKSetupWeChatParamsByText:@"3" title:nil url:nil thumbImage:nil image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeWechatSession];
        //        [shareParams SSDKSetupWeChatParamsByText:@"4" title:nil url:nil thumbImage:nil image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
        //        [shareParams SSDKSetupWeChatParamsByText:@"5" title:nil url:nil thumbImage:nil image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeWechatFav];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
//        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
//                                 items:nil
//                           shareParams:shareParams
//                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//
//                       switch (state) {
//                           case SSDKResponseStateSuccess:
//                           {
//                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                                   message:nil
//                                                                                  delegate:nil
//                                                                         cancelButtonTitle:@"确定"
//                                                                         otherButtonTitles:nil];
//                               [alertView show];
//                               break;
//                           }
//                           case SSDKResponseStateFail:
//                           {
//                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                               message:[NSString stringWithFormat:@"%@",error]
//                                                                              delegate:nil
//                                                                     cancelButtonTitle:@"OK"
//                                                                     otherButtonTitles:nil, nil];
//                               [alert show];
//                               break;
//                           }
//                           default:
//                               break;
//                       }
//                   }
//         ];
//
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
