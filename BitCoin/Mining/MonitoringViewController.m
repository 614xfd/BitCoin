////
////  MonitoringViewController.m
////  BitCoin
////
////  Created by LBH on 2017/11/9.
////  Copyright © 2017年 LBH. All rights reserved.
////
//
//#import "MonitoringViewController.h"
//#import "EZUIKit.h"
//#import "EZUIPlayer.h"
//#import "EZUIError.h"
//#import "PlayMonitoringViewController.h"
//#import "LoginViewController.h"
//
//@interface MonitoringViewController () <EZUIPlayerDelegate> {
//    NSTimer *_timer;
////    NSMutableArray *_arr;
//    NSString *_token;
//    NSArray *_publicUrlArray;
//    NSArray *_privateUrlArray;
//    NSMutableArray *_publicPlayerArray;
//    NSMutableArray *_privatePlayerArray;
//    NSString *_accessToken;
//    BOOL _isRequest;
//    
//}
//@property (nonatomic,strong) EZUIPlayer *mPlayer;
//
//@end
//
//@implementation MonitoringViewController
//
//- (void) viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//
//}
//
//- (void) viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *value = [defaults objectForKey:@"isLogin"];
//    
//    if (![value isEqualToString:@"YES"]) {
//        LoginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
//        vc.isMonitoring = YES;
//        [self.navigationController pushViewController:vc animated:YES];
//    } else {
//        if (_isRequest) {
//            return;
//        }
//        value = [defaults objectForKey:@"expireTime"];
//        if (value.length && [self getDifferenceByDate:value] < 6) {
//            _accessToken = [defaults objectForKey:@"accessToken"];
//            [EZUIKit setAccessToken:_accessToken];
//            [self request];
//        } else {
//            [self requestToken];
//        }
//    }
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    [EZUIKit initWithAppKey:@"e3149c8746cc4106b26abdee8d2fc535"];
//    _isRequest = NO;
//    _publicUrlArray = [NSArray array];
//    _privateUrlArray = [NSArray array];
//    
//    UIView *view = self.tableView.tableHeaderView;
//    self.publicView = [view viewWithTag:1];
//    self.publicView.clipsToBounds = YES;
//    self.tableView.tableFooterView = [[UIView alloc] init];
//
//    _publicPlayerArray = [NSMutableArray array];
//    _privatePlayerArray = [NSMutableArray array];
//    
//
//
//
//}
//
//- (void) setAccessToken : (NSDictionary *)dic
//{
//    _accessToken = [dic objectForKey:@"accessToken"];
//    NSString *date = [NSString stringWithFormat:@"%@", [dic objectForKey:@"expireTime"]];
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:_accessToken forKey:@"accessToken"];
//    [defaults setObject:date forKey:@"expireTime"];
//    [defaults synchronize];
//    [EZUIKit setAccessToken:_accessToken];
//    [self request];
//}
//
//- (void) requestToken
//{
//    _isRequest = YES;
//    NSDictionary *dic = @{@"appKey":@"e3149c8746cc4106b26abdee8d2fc535", @"appSecret":@"ce7ddfeb74e23b6c421da8cc28a8d64d"};
//    __weak __typeof(self) weakSelf = self;
//    [[NetworkTool sharedTool] requestWithHPURLString:@"https://open.ys7.com/api/lapp/token/get" parameters:dic method:@"POST" completed:^(id JSON, NSString *stringData) {
//        NSLog(@"%@      ------------- %@", stringData, JSON );
//        if ([[NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]] isEqualToString:@"200"]) {
//            [weakSelf performSelectorOnMainThread:@selector(setAccessToken:) withObject:[JSON objectForKey:@"data"] waitUntilDone:YES];
//        }
//    } failed:^(NSError *error) {
//        //        [weakSelf requestError];
//    }];
//}
//
//- (void) request
//{
//    _isRequest = YES;
//    __weak __typeof(self) weakSelf = self;
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *phoneNum = [defaults objectForKey:@"phoneNum"];
//    NSDictionary *dic;
//    dic = @{@"phone":phoneNum};
//    [[NetworkTool sharedTool] requestWithURLString:@"video/findVideo" parameters:dic method:@"POST" completed:^(id JSON, NSString *stringData) {
//        NSLog(@"%@      ------------- %@", stringData, JSON );
//        //        NSString *isError = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
//        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
//        if ([code isEqualToString:@"1"]) {
////            if (isPri) {
////                _publicUrlArray = [[JSON objectForKey:@"Data"] objectForKey:@"findPublic"];
////                _privateUrlArray = [[JSON objectForKey:@"Data"] objectForKey:@"findUser"];
////            } else {
////                _publicUrlArray = [JSON objectForKey:@"Data"];
////            }
//            NSMutableArray *array = [NSMutableArray array];
//            NSMutableArray *array1 = [NSMutableArray array];
//            for (int i = 0; i < [[JSON objectForKey:@"Data"] count]; i++) {
//                NSString *string = [NSString stringWithFormat:@"%@", [[[JSON objectForKey:@"Data"] objectAtIndex:i] objectForKey:@"state"]];
//                if ([string isEqualToString:@"1"]) {
//                    [array addObject:[[JSON objectForKey:@"Data"] objectAtIndex:i]];
//                } else {
//                    [array1 addObject:[[JSON objectForKey:@"Data"] objectAtIndex:i]];
//                }
//            }
//            _publicUrlArray = [NSArray arrayWithArray:array];
//            _privateUrlArray = [NSArray arrayWithArray:array1];
//            [weakSelf performSelectorOnMainThread:@selector(creatPlayer) withObject:nil waitUntilDone:YES];
//        } else {
//            [weakSelf showToastWithMessage:[JSON objectForKey:@"msg"]];
//        }
//    } failed:^(NSError *error) {
//        //        [weakSelf requestError];
//    }];
//}
//
//- (void) creatPlayer
//{
//    for (int i = 0; i < 1; i++) {
//        EZUIPlayer *player = [EZUIPlayer createPlayerWithUrl:[[_publicUrlArray objectAtIndex:i] objectForKey:@"HD"]];
//        player.mDelegate = self;
//        player.previewView.frame = CGRectMake(0, 0, self.publicView.frame.size.width, self.publicView.frame.size.height);
//        [self.publicView addSubview:player.previewView];
//        [player startPlay];
//        [_publicPlayerArray addObject:player];
//    }
////    UIView *view = self.tableView.tableHeaderView;
////    UILabel *shebei = [view viewWithTag:2];
////    shebei.text = [NSString stringWithFormat:@"我的设备: %d 台", (int)_privateUrlArray.count];
////    UILabel *name = [view viewWithTag:3];
////    name.text = [[_publicUrlArray objectAtIndex:0] objectForKey:@"video_name"];
////    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(playEZ) userInfo:nil repeats:NO];
//    
////    for (int i = 0; i < _privateUrlArray.count; i++) {
////        EZUIPlayer *player = [EZUIPlayer createPlayerWithUrl:[[_privateUrlArray objectAtIndex:i] objectForKey:@"HD"]];
////        player.mDelegate = self;
////        player.previewView.frame = CGRectMake(0, 0, self.publicView.frame.size.width, self.publicView.frame.size.height);
//////        [player startPlay];
////        [_privatePlayerArray addObject:player];
////    }
//    [self.tableView reloadData];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
// 
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"playCell" forIndexPath:indexPath];
//    UIView *view = [cell viewWithTag:10];
//    view.clipsToBounds = YES;
//    [view.layer setMasksToBounds:YES];
//    view.layer.cornerRadius = 4;
////    BOOL isHave = NO;
////    for (id v in view.subviews) {
////        if ([v isKindOfClass:[EZUIPlayer class]]) {
////            isHave = YES;
////        }
////    }
////    if (!isHave) {
////        EZUIPlayer *player = (EZUIPlayer *)[_privatePlayerArray objectAtIndex:indexPath.row];
////        [view addSubview:player.previewView];
////        [player startPlay];
////    }
//    UILabel *nameLabel = [cell viewWithTag:11];
//    nameLabel.text = [[_privateUrlArray objectAtIndex:indexPath.row] objectForKey:@"video_name"];
//    
////    UILabel *shebei = [cell viewWithTag:12];
////    shebei.text = [NSString stringWithFormat:@"设备%d", (int)indexPath.row+1];
////
////    UIButton *btn = [cell viewWithTag:13];
////    [btn addTarget:self action:@selector(changeName) forControlEvents:UIControlEventTouchUpInside];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//
//    return cell;
//}
//
//- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return _privateUrlArray.count;
//}
//
//- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 80;
//}
//
////- (void)changeName
////{
////    NSLog(@"8723648216489126461378956135");
////}
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"asdgasrgopnshoudhgiqehgpq");
//    
//    NSString *videoID = [[_privateUrlArray objectAtIndex:indexPath.row] objectForKey:@"id"];
//    [self requestJurisdiction:videoID];
//    
////    [self requestChangeName:[[_privateUrlArray objectAtIndex:indexPath.row] objectForKey:@"id"]];
//}
//
//- (void) requestJurisdiction : (NSString *)videoID
//{
//    __weak __typeof(self) weakSelf = self;
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *phoneNum = [defaults objectForKey:@"phoneNum"];
//    NSDictionary *dic;
//    dic = @{@"phone":phoneNum, @"videoID":videoID};
//    [[NetworkTool sharedTool] requestWithURLString:@"video/findVideoID" parameters:dic method:@"POST" completed:^(id JSON, NSString *stringData) {
//        NSLog(@"%@      ------------- %@", stringData, JSON );
//        //        NSString *isError = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
//        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
//        if ([code isEqualToString:@"1"]) {
//            code = [NSString stringWithFormat:@"%@", [[[JSON objectForKey:@"Data"] objectAtIndex:0] objectForKey:@"code"]];
//            if ([code isEqualToString:@"1"] || [code isEqualToString:@"(null)"]) {
//                NSString *HD = [[[JSON objectForKey:@"Data"] objectAtIndex:0] objectForKey:@"HD"];
//                [weakSelf performSelectorOnMainThread:@selector(playMonitoring:) withObject:HD waitUntilDone:YES];
//            } else {
//                [weakSelf showToastWithMessage:[[[JSON objectForKey:@"Data"] objectAtIndex:0] objectForKey:@"msg"]];
//            }
//        } else {
//            [weakSelf showToastWithMessage:[JSON objectForKey:@"msg"]];
//        }
//    } failed:^(NSError *error) {
//        //        [weakSelf requestError];
//    }];
//}
//
//- (void) playMonitoring:(NSString *)string
//{
////    PlayMonitoringViewController *VC = [PlayMonitoringViewController new];
////    VC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
////    VC.urlString = string;
////    [self presentViewController:VC animated:YES completion:nil];
//    
//    PlayMonitoringViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PlayMonitoringVC"];
//    vc.urlString = string;
//    [self.navigationController pushViewController:vc animated:YES];
//}
//
////- (void) requestChangeName : (NSString *)idString
////{
////    __weak __typeof(self) weakSelf = self;
////    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
////    NSString *phoneNum = [defaults objectForKey:@"phoneNum"];
////    NSDictionary *dic = @{@"phone":phoneNum, @"id":idString, @"name":@"asdfasdf"};
////
////    [[NetworkTool sharedTool] requestWithURLString:@"video/updateName" parameters:dic method:@"POST" completed:^(id JSON, NSString *stringData) {
////        NSLog(@"%@      ------------- %@", stringData, JSON );
////        //        NSString *isError = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
////        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
//////        if ([code isEqualToString:@"1"]) {
//////
//////        } else {
////            [weakSelf showToastWithMessage:[JSON objectForKey:@"msg"]];
//////        }
////    } failed:^(NSError *error) {
////        //        [weakSelf requestError];
////    }];
////}
//
//
//- (void) play
//{
////    if (self.mPlayer)
////    {
////        [self.mPlayer startPlay];
////        return;
////    }
////
////    self.mPlayer = [EZUIPlayer createPlayerWithUrl:@"ezopen://open.ys7.com/792154606/1.hd.live"];
////    self.mPlayer.mDelegate = self;
////    //    self.mPlayer.customIndicatorView = nil;//去除加载动画
////    self.mPlayer.previewView.frame = CGRectMake(0, 64,
////                                                CGRectGetWidth(self.mPlayer.previewView.frame),
////                                                CGRectGetHeight(self.mPlayer.previewView.frame));
////
////    [self.view addSubview:self.mPlayer.previewView];
//
//    //该处去除，调整到prepared回调中执行，如为预览模式也可直接调用startPlay
//    //    [self.mPlayer startPlay];
//}
//
//-  (void) EZUIPlayer:(EZUIPlayer *)player didPlayFailed:(EZUIError *) error
//{
//    //    [self stop];
//    //    self.playBtn.selected = NO;
//    
//    if ([error.errorString isEqualToString:UE_ERROR_INNER_VERIFYCODE_ERROR])
//    {
//        //        [self.view makeToast:[NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"verify_code_wrong", @"验证码错误"),error.errorString] duration:1.5 position:@"center"];
//    }
//    else if ([error.errorString isEqualToString:UE_ERROR_TRANSF_DEVICE_OFFLINE])
//    {
//        //        [self.view makeToast:[NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"device_offline", @"设备不在线"),error.errorString] duration:1.5 position:@"center"];
//    }
//    else if ([error.errorString isEqualToString:UE_ERROR_DEVICE_NOT_EXIST])
//    {
//        //        [self.view makeToast:[NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"device_not_exist", @"设备不存在"),error.errorString] duration:1.5 position:@"center"];
//    }
//    else if ([error.errorString isEqualToString:UE_ERROR_CAMERA_NOT_EXIST])
//    {
//        //        [self.view makeToast:[NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"camera_not_exist", @"通道不存在"),error.errorString] duration:1.5 position:@"center"];
//    }
//    else if ([error.errorString isEqualToString:UE_ERROR_INNER_STREAM_TIMEOUT])
//    {
//        //        [self.view makeToast:[NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"connect_out_time", @"连接超时"),error.errorString] duration:1.5 position:@"center"];
//    }
//    else if ([error.errorString isEqualToString:UE_ERROR_CAS_MSG_PU_NO_RESOURCE])
//    {
//        //        [self.view makeToast:[NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"connect_device_limit", @"设备连接数过大"),error.errorString] duration:1.5 position:@"center"];
//    }
//    else if ([error.errorString isEqualToString:UE_ERROR_NOT_FOUND_RECORD_FILES])
//    {
//        //        [self.view makeToast:[NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"not_find_file", @"未找到录像文件"),error.errorString] duration:1.5 position:@"center"];
//    }
//    else if ([error.errorString isEqualToString:UE_ERROR_PARAM_ERROR])
//    {
//        //        [self.view makeToast:[NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"param_error", @"参数错误"),error.errorString] duration:1.5 position:@"center"];
//    }
//    else if ([error.errorString isEqualToString:UE_ERROR_URL_FORMAT_ERROR])
//    {
//        //        [self.view makeToast:[NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"play_url_format_wrong", @"播放url格式错误"),error.errorString] duration:1.5 position:@"center"];
//    }
//    else
//    {
//        //        [self.view makeToast:[NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"play_fail", @"播放失败"),error.errorString] duration:1.5 position:@"center"];
//    }
//    
//    NSLog(@"play error:%@(%d)",error.errorString,error.internalErrorCode);
//}
//
//- (void) EZUIPlayer:(EZUIPlayer *)player previewWidth:(CGFloat)pWidth previewHeight:(CGFloat)pHeight
//{
//    CGFloat ratio = pWidth/pHeight;
//    
//    CGFloat destWidth = CGRectGetWidth(self.view.bounds);
//    CGFloat destHeight = destWidth/ratio;
//    
//    [player setPreviewFrame:CGRectMake(0, CGRectGetMinY(player.previewView.frame), destWidth, destHeight)];
//}
//
//- (NSInteger)getDifferenceByDate:(NSString *)date {
//    if (date) {
//        //获得当前时间
//        NSDate *now = [NSDate date];
//        //实例化一个NSDateFormatter对象
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        //设定时间格式
//        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//        NSDate *oldDate = [dateFormatter dateFromString:date];
//        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//        unsigned int unitFlags = NSDayCalendarUnit;
//        NSDateComponents *comps = [gregorian components:unitFlags fromDate:oldDate  toDate:now  options:0];
//        return [comps day];
//    }
//    return 7;
//}
//
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

