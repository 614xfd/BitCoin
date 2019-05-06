//
//  ViewController.m
//  BitCoin
//
//  Created by LBH on 2017/9/22.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import "MarketViewController.h"
#import "Y_KLineGroupModel.h"
#import "NetWorking.h"
#import "Y_StockChartViewController.h"
#import "Masonry.h"
#import "WebViewController.h"
#import "RSAEncryptor.h"
#import "MoneyInfoViewController.h"
#import "YWUnlockView.h"
#import "CoinInComeViewController.h"
#import "CoinSendViewController.h"
#import "NodeMiningViewController.h"
#import "CloudMiningViewController.h"
#import "AnnouncementViewController.h"
#import "CoinSendInfoViewController.h"
#import "HoldListViewController.h"
#import "NewShareViewController.h"
#import "LoginViewController.h"

#define SCREEN_HEIGHT                      [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH                       [UIScreen mainScreen].bounds.size.width
#define NAVBAR_CHANGE_POINT 0

@interface MarketViewController () {
    NSMutableArray *_coinArray;
    NSMutableArray *_coinNameArray;
    NSString *_rate_90;
    NSString *_rate_180;
    NSString *_rate_365;
    NSString *_id_90;
    NSString *_id_180;
    NSString *_id_365;
    marketHeadView *_mhview;
    NSArray *_rateArray;
    NSDictionary *_defaultDic;
    float _defaultNum;
    BOOL _isOpen;
    BOOL _isLogin;

}

@end

@implementation MarketViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setBarBlackColor:YES];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *value = [defaults objectForKey:@"isLogin"];
    if ([value isEqualToString:@"YES"]) {
        _isLogin = YES;
    } else {
        _isLogin = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    if (@available(iOS 11.0, *)) {
        [self.tableView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
//    NSLog(@"%@", [UIFont familyNames]);
    if ([YWUnlockView haveGesturePassword]) {
        [YWUnlockView showUnlockViewWithType:YWUnlockViewUnlock  andReset:@"验证手势密码" andIsVerify:NO callBack:^(BOOL result) {
            NSLog(@"-->%@",@(result));
        }];
    }
    
//    self.titleLabel.text = @"BitBoss";
//    self.titleLabel.font = [UIFont fontWithName:@"Chap" size:17];
//    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
//    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
//    paraStyle.alignment = NSTextAlignmentCenter;
//    paraStyle.hyphenationFactor = 1.0;
//    paraStyle.firstLineHeadIndent = 0.0;
//    paraStyle.paragraphSpacingBefore = 0.0;
//    paraStyle.headIndent = 0;
//    paraStyle.tailIndent = 0;
//    //设置字间距 NSKernAttributeName:@1.5f
//    NSDictionary *dic = @{NSFontAttributeName:self.titleLabel.font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f};
//    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:@"小蚂蚁" attributes:dic];
//    self.titleLabel.attributedText = attributeStr;
//    
//    CGFloat f = [self getSpaceLabelHeight:str withFont:content.font withWidth:content.frame.size.width];
//    content.frame = CGRectMake(content.frame.origin.x, content.frame.origin.y, content.frame.size.width, f);
    
    self.titleLabel.textColor = [UIColor blackColor];

    _coinArray = [NSMutableArray array];
    _defaultDic = @{@"amount" : @"0", @"coinName" : @"gtse", @"icon" : @"", @"percent" : @"0", @"price" : @"4.0"};
    _defaultNum = 6.8;
    [_coinArray addObject:_defaultDic];
    _rateArray = [NSArray array];
    [self requestGtse];
    
    _mhview = [[marketHeadView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 440)];
    _mhview.delegate = self;
    [self.tableView addSubview:_mhview];

    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, _mhview.frame.size.height+7)];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.bgTitleLabel.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(_mhview.frame.size.height+7, 0, 0, 0);

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestGtse)];
    
    //自动更改透明度
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    //进入刷新状态
    [self.tableView.mj_header beginRefreshing];
    [self requestISOpen];

//    [self inputPayPasswordWithPayTip:@"" andPrice:@""];
}

- (void) returnPayPassword:(NSString *)string
{
    NSLog(@"%@" ,string);
}

- (void) requestISOpen
{
    __weak __typeof(self) weakSelf = self;
    [[NetworkTool sharedTool] requestWithURLString:@"v1/node/get" parameters:nil method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@", stringData, JSON );
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        if ([code isEqualToString:@"1"]) {
            _isOpen = YES;
            [defaults setObject:@"1" forKey:@"isOpen"];
        } else {
            _isOpen = NO;
            [defaults setObject:@"0" forKey:@"isOpen"];
        }
    } failed:^(NSError *error) {
        //        [weakSelf requestError];
    }];
}



- (void) requestMarker
{
    __weak __typeof(self) weakSelf = self;
    [[NetworkTool sharedTool] requestWithURLString:@"market/getData" parameters:nil method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@", stringData, JSON );
        [weakSelf.tableView.mj_header endRefreshing];
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            _coinArray = [NSMutableArray arrayWithArray:[JSON objectForKey:@"data"]];
            [_coinArray insertObject:_defaultDic atIndex:0];
            [weakSelf.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        } else {
            [_coinArray addObject:_defaultDic];
        }
    } failed:^(NSError *error) {
        //        [weakSelf requestError];
    }];
}

- (void) requestGtse
{
    [_coinArray removeAllObjects];
    __weak __typeof(self) weakSelf = self;
    [[NetworkTool sharedTool] requestWithURLString:@"market/gtse" parameters:nil method:@"GET" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@", stringData, JSON );
        [weakSelf performSelectorOnMainThread:@selector(requestMarker) withObject:nil waitUntilDone:YES];
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            NSDictionary *dic = [[JSON objectForKey:@"data"] objectForKey:@"gtse_usdt"];
            _defaultDic = @{@"amount" : dic[@"volume"], @"coinName" : @"gtse", @"icon" : @"", @"percent" : dic[@"change"], @"price" : dic[@"last"]};
            [_coinArray addObject:_defaultDic];
            _defaultNum = 6.8;
            if ([[[JSON objectForKey:@"data"] objectForKey:@"usdt_hbcny"] isKindOfClass:[NSDictionary class]]) {
                dic = [[JSON objectForKey:@"data"] objectForKey:@"usdt_hbcny"];
                _defaultNum = [dic[@"last"] floatValue];
            }
            [weakSelf.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        } else {
            [_coinArray addObject:_defaultDic];
        }

    } failed:^(NSError *error) {
        //        [weakSelf requestError];
    }];
}

- (void) setRateLabel
{
//    self.day90Label.text = _rate_90;
//    self.day180Label.text = _rate_180;
//    self.day365Label.text = _rate_365;
}

//- (void) requestWithString : (NSString *)string andUrl : (NSString *)urlString
//{
//    第一步，创建URL
//    NSURL *url = [NSURL URLWithString:urlString];
//    //第二步，通过URL创建网络请求
//    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
//    //NSURLRequest初始化方法第一个参数：请求访问路径，第二个参数：缓存协议，第三个参数：网络请求超时时间（秒）
//    //第三步，连接服务器
//    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
////    NSString *str = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
//    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:received
//                                                        options:NSJSONReadingMutableContainers
//                                                          error:nil];
//    NSLog(@"%@",dict);
//
//    [_dataArray addObject:[dict objectForKey:@"tick"]];
//    [self.tableView reloadData];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"market" forIndexPath:indexPath];
    
    UIImageView *virtualCoinImage = (UIImageView *)[cell viewWithTag:2];
    if (indexPath.row == 0) {
        virtualCoinImage.image = [UIImage imageNamed:@"gtse.png"];
    } else {
        [virtualCoinImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[_coinArray objectAtIndex:indexPath.row] objectForKey:@"icon"]]]];
    }

    UILabel *virtualCoinLabel = (UILabel *)[cell viewWithTag:3];
    virtualCoinLabel.text = [[[_coinArray objectAtIndex:indexPath.row] objectForKey:@"coinName"] uppercaseString];
    
    UILabel *turnoverLabel = (UILabel *)[cell viewWithTag:4];
    turnoverLabel.text = [NSString stringWithFormat:@"24H量 %d", [[[_coinArray objectAtIndex:indexPath.row] objectForKey: @"amount"] intValue]];
    
    UILabel *priceLabel = (UILabel *)[cell viewWithTag:6];
    NSString *string = [[_coinArray objectAtIndex:indexPath.row] objectForKey:@"price"];
    double s = [string doubleValue];
    priceLabel.text = [NSString stringWithFormat:@"$ %.2lf", s];
    
    UILabel *priceRMBLabel = (UILabel *)[cell viewWithTag:8];
    string = [[_coinArray objectAtIndex:indexPath.row] objectForKey:@"price"];
    s = [string doubleValue];
    priceRMBLabel.text = [NSString stringWithFormat:@"￥ %.2lf", s*_defaultNum];
    
    UILabel *percentage = (UILabel *)[cell viewWithTag:7];
    double x = [[[_coinArray objectAtIndex:indexPath.row] objectForKey:@"percent"] doubleValue];
    NSString *f = @"";
    if (x > 0) {
        f = @"+";
    }
    percentage.text = [NSString stringWithFormat:@"%@%.2lf%%", f, x];
//    [percentage.layer setMasksToBounds:YES];
//    percentage.layer.cornerRadius = 4;
    if ([percentage.text hasPrefix:@"-"]) {
        percentage.textColor = [UIColor colorWithRed:228/255.0 green:108/255.0 blue:65/255.0 alpha:1];
    } else {
        percentage.textColor = [UIColor colorWithRed:5/255.0 green:211/255.0 blue:183/255.0 alpha:1];
    }
    UILabel *line = (UILabel *) [cell viewWithTag:9];
    line.frame = CGRectMake(line.frame.origin.x, line.frame.origin.y, line.frame.size.width, 0.5);
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _coinArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return;
    }
    Y_StockChartViewController *stockChartVC = [Y_StockChartViewController new];
    stockChartVC.coinStr = [NSString stringWithFormat:@"%@usdt", [[_coinArray objectAtIndex:indexPath.row] objectForKey:@"coinName"]];
    stockChartVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:stockChartVC animated:YES completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    UIColor * color = [UIColor whiteColor];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_CHANGE_POINT) {
        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
//        self.titleImage.alpha = alpha;
//        self.littleBtnView.alpha = alpha;
//        self.bigBtnView.alpha = 1-alpha;
        NSLog(@"%lf", alpha);
    } else {
//        self.titleImage.alpha = 0;
        self.littleBtnView.alpha = 0;
        self.bigBtnView.alpha = 1;
    }
    NSLog(@"%lf", offsetY);
    if (offsetY <= 0) {
//        self.titleImage.hidden = NO;
        self.titleLabel.hidden = NO;
        _mhview.frame = CGRectMake(0, offsetY, SCREEN_WIDTH, 305);

    } else {
//        self.titleImage.hidden = YES;
//        self.titleLabel.hidden = YES;
    }

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    CGFloat offsetY = scrollView.contentOffset.y;
    if(offsetY > 0 && offsetY < 81*kScaleH/2){
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:true];
    }
    else if(offsetY >= 81*kScaleH/2 && offsetY < 81*kScaleH){
        [self.tableView setContentOffset:CGPointMake(0, 81*kScaleH) animated:true];
    }
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (IBAction)intoMoneyInfo:(id)sender {
    NSInteger x = [sender tag];
    if (_id_90.length && _id_180.length && _id_365.length) {
        MoneyInfoViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MoneyInfoVC"];
        if (x == 10) {
            vc.day = @"90";
            vc.time = @"三月";
            vc.rate = _rate_90;
            vc.idString = _id_90;
        } else if (x == 11) {
            vc.day = @"180";
            vc.time = @"六月";
            vc.rate = _rate_180;
            vc.idString = _id_180;
        } else if (x == 12) {
            vc.day = @"365";
            vc.time = @"一年";
            vc.rate = _rate_365;
            vc.idString = _id_365;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)returnString:(NSString *)string
{
    NSString *private_key_path = [[NSBundle mainBundle] pathForResource:@"private_key.p12" ofType:nil];
    if ([[RSAEncryptor decryptString:string privateKeyWithContentsOfFile:private_key_path password:@""] containsString:@"xiaomayi"]) {
        CoinSendInfoViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CoinSendInfoVC"];
        vc.phoneString = [[[RSAEncryptor decryptString:string privateKeyWithContentsOfFile:private_key_path password:@""] componentsSeparatedByString:@"xiaomayi"] firstObject];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        if ([string containsString:@"http"]) {
            WebViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WebVC"];
            vc.UrlString = string;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [self showToastWithMessage:string];
        }
    }
}

- (void) intoQRCode {
    QRCodeViewController *qrcodeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"qrcodeview"];
    qrcodeVC.delegate = self;
    [self.navigationController pushViewController:qrcodeVC animated:YES];
}

- (void) intoCoinInCome {
    CoinInComeViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CoinInComeVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) intoCoinSend {
    CoinSendViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CoinSendVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) intoAnnouncement {
    AnnouncementViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AnnouncementVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) intohold {
    if (!_isOpen) {
        [self showToastWithMessage:@"暂未开放"];
        return;
    }
    if (!_isLogin) {
        [self login];
        return;
    }
    HoldListViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HoldListVC"];
    vc.dataArray = _rateArray;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) intoNode {
    if (!_isLogin) {
        [self login];
        return;
    }
    NodeMiningViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"NodeMiningVC"];
    vc.isSuperNode = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) intoCloud {
    if (!_isLogin) {
        [self login];
        return;
    }
    NodeMiningViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"NodeMiningVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) more {
    [self showToastWithMessage:@"暂未开放"];
}

- (void)login{
    LoginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)QRCodeBtnClick:(id)sender {
    [self intoQRCode];
}
- (IBAction)inComeBtnClick:(id)sender {
    if (!_isLogin) {
        [self login];
        return;
    }
    [self intoCoinInCome];
}
- (IBAction)sendBtnClick:(id)sender {
    if (!_isLogin) {
        [self login];
        return;
    }

    [self intoCoinSend];
}
- (IBAction)announcementBtnClick:(id)sender {
    [self intoAnnouncement];
}

- (void) intoWebViewWith:(NSString *)string
{
    WebViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WebVC"];
    vc.UrlString = string;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) intoVC:(NSInteger)index
{
    if (!_isLogin) {
        [self login];
        return;
    }
    if (index == 0) {
        NodeMiningViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"NodeMiningVC"];
        [self.navigationController pushViewController:vc animated:YES];
    } else if(index == 1) {
        NodeMiningViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"NodeMiningVC"];
        vc.isSuperNode = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (index == 2) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NewShareViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"NewShareVC"];
        vc.codeStr = [defaults objectForKey:@"inviteCode"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
