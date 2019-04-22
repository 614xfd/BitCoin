////
////  PlayMonitoringViewController.m
////  BitCoin
////
////  Created by LBH on 2017/12/28.
////  Copyright © 2017年 LBH. All rights reserved.
////
//
//#import "PlayMonitoringViewController.h"
//#import "EZUIKit.h"
//#import "EZUIPlayer.h"
//#import "EZUIError.h"
//
//@interface PlayMonitoringViewController () <EZUIPlayerDelegate> {
//    EZUIPlayer *_player;
//}
//
//@end
//
//@implementation PlayMonitoringViewController
//
//- (void) viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [_player startPlay];
//
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//
//    [EZUIKit initWithAppKey:@"e3149c8746cc4106b26abdee8d2fc535"];
//    [EZUIKit setAccessToken:self.accessToken];
//
//    _player = [EZUIPlayer createPlayerWithUrl:self.urlString];
//    _player.mDelegate = self;
//    _player.previewView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
//    [self.view addSubview:_player.previewView];
//    [_player startPlay];
//    [self.view sendSubviewToBack:_player.previewView];
//}
//- (IBAction)goBack:(id)sender {
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/
//
//@end
//
//
//
//
//
//
//
//
//
//
//
