//
//  WebViewController.h
//  BitCoin
//
//  Created by LBH on 2017/12/27.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import "BaseViewController.h"
#import <WebKit/WebKit.h>

@interface WebViewController : BaseViewController <WKNavigationDelegate>

@property (nonatomic, weak) NSString *UrlString;
@property (nonatomic, strong) WKWebView *wkWebview;
@property (nonatomic,strong) UIProgressView *progress;

//@property (nonatomic, strong) UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
