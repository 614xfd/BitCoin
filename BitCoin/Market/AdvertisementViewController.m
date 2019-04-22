//
//  AdvertisementViewController.m
//  BitCoin
//
//  Created by LBH on 2018/5/24.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "AdvertisementViewController.h"
#import "YWUnlockView.h"
#import "AppDelegate.h"

@interface AdvertisementViewController () {
    NSTimer *_countDownTimer;
    int _x;
}

@end

@implementation AdvertisementViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setBarBlackColor:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prefersStatusBarHidden];

    [self requestImage];
    [self.bgLabel.layer setMasksToBounds:YES];
    self.bgLabel.layer.cornerRadius = 6;
    [self.skipBtn.layer setMasksToBounds:YES];
    self.skipBtn.layer.cornerRadius = 6;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *image = [defaults objectForKey:@"advImage"];
    if (image.length) {
        [self.advImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMAGE_URL, image]]];
    }
    _x = 5;
    _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdown) userInfo:nil repeats:YES];

}

- (void) setImage : (NSString *)string
{
    [self.advImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMAGE_URL, string]]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:string forKey:@"advImage"];
    [defaults synchronize];
}

- (void) requestImage
{
    __weak __typeof(self) weakSelf = self;
    [[NetworkTool sharedTool] requestWithURLString:@"HomePictuer/findData" parameters:nil method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@", stringData, JSON );
        //        NSString *isError = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            [weakSelf performSelectorOnMainThread:@selector(setImage:) withObject:[[JSON objectForKey:@"Data"] objectForKey:@"home_picture"] waitUntilDone:YES];
        } else {
            
        }
    } failed:^(NSError *error) {
        //        [weakSelf requestError];
    }];
}

- (void) nextViewController
{
    AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
    app.window.rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BaseTabBarVC"];
}
- (IBAction)nextBtnClick:(id)sender {
    [_countDownTimer invalidate];
    _countDownTimer = nil;
    [self nextViewController];
}

- (void) countdown
{
    _x--;
    if (_x == 0) {
        [self nextViewController];
        [_countDownTimer invalidate];
        _countDownTimer = nil;
        return;
    }
    [self.skipBtn setTitle:[NSString stringWithFormat:@"0%d 跳过", _x] forState:UIControlStateNormal];
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
