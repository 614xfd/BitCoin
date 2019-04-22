//
//  ServiceExplainViewController.h
//  BitCoin
//
//  Created by LBH on 2018/8/6.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "BaseViewController.h"
#import <WebKit/WebKit.h>

@interface ServiceExplainViewController : BaseViewController <WKNavigationDelegate>

@property (nonatomic, weak) NSString *UrlString;
@property (nonatomic, weak) NSString *titleStr;
@property (nonatomic, strong) WKWebView *wkWebview;
@property (nonatomic,strong) UIProgressView *progress;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end
