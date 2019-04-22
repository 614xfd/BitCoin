//
//  ServiceExplainViewController.m
//  BitCoin
//
//  Created by LBH on 2018/8/6.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "ServiceExplainViewController.h"

@interface ServiceExplainViewController ()

@end

@implementation ServiceExplainViewController
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setBarBlackColor:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.titleStr.length) {
        self.titleLab.text = self.titleStr;
    }
    self.wkWebview = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    [self.wkWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.UrlString]]];
    [self.view addSubview:self.wkWebview];
    [self.wkWebview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
//    [self.wkWebview addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    
}

#pragma mark 加载进度条
- (UIProgressView *)progress
{
    if (_progress == nil)
    {
        _progress = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 2)];
        _progress.tintColor = [UIColor blueColor];
        _progress.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:_progress];
    }
    return _progress;
}

#pragma mark KVO的监听代理
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    //加载进度值
    if ([keyPath isEqualToString:@"estimatedProgress"])
    {
        if (object == self.wkWebview)
        {
            [self.progress setAlpha:1.0f];
            [self.progress setProgress:self.wkWebview.estimatedProgress animated:YES];
            if(self.wkWebview.estimatedProgress >= 1.0f)
            {
                [UIView animateWithDuration:0.5f
                                      delay:0.3f
                                    options:UIViewAnimationOptionCurveEaseOut
                                 animations:^{
                                     [self.progress setAlpha:0.0f];
                                 }
                                 completion:^(BOOL finished) {
                                     [self.progress setProgress:0.0f animated:NO];
                                 }];
            }
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
    //网页title
//    else if ([keyPath isEqualToString:@"title"])
//    {
//        if (object == self.wkWebview)
//        {
////            self.titleLabel.text = self.wkWebview.title;
//        }
//        else
//        {
//            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//        }
//    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 移除观察者
- (void)dealloc
{
    [self.wkWebview removeObserver:self forKeyPath:@"estimatedProgress"];
//    [self.wkWebview removeObserver:self forKeyPath:@"title"];
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
