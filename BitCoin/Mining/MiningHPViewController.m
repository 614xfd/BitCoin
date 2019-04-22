//
//  MiningHPViewController.m
//  BitCoin
//
//  Created by LBH on 2017/9/29.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import "MiningHPViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import "MonitoringViewController.h"
#import "XZMPieView.h"
#import "LoginViewController.h"
#import "PooledMiningViewController.h"

@interface MiningHPViewController () {
    UIImageView *_imageView;
    CGFloat _x;
    UIColor *_color;
    UIColor *_color2;
    XZMPieView *_pieView;
    XZMPieView *_pieView1;
    BOOL _isLimit;
    NSString *_msg;
}
@property (weak, nonatomic) IBOutlet UILabel *blueLine;
@property (weak, nonatomic) IBOutlet UILabel *nowLabel;
@property (weak, nonatomic) IBOutlet UILabel *onceLabel;
@property (weak, nonatomic) IBOutlet UIView *SLView;
@property (weak, nonatomic) IBOutlet UIView *SLView2;
@property (weak, nonatomic) IBOutlet UILabel *difficultyLabel1;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel1;
@property (weak, nonatomic) IBOutlet UILabel *sumLabel1;
@property (weak, nonatomic) IBOutlet UILabel *validLabel1;


@end

@implementation MiningHPViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self request];

    if (_pieView) {
        [_pieView removeFromSuperview];
        [_pieView1 removeFromSuperview];

        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i < 10; i++) {
            UILabel *label = (UILabel *)[self.view viewWithTag:i+10];
            UIColor *color = label.backgroundColor;
            [array addObject:color];
        }
        [array insertObject:[array objectAtIndex:9] atIndex:1];
        [array removeObjectAtIndex:10];
        NSArray *arr = @[@"1860", @"1742", @"1548", @"1098", @"1097", @"323", @"258", @"131", @"129", @"1814"];
        _pieView = [[XZMPieView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
        [self.SLView addSubview:_pieView];
        [_pieView setDatas:arr colors:[NSArray arrayWithArray:array]];
        [_pieView stroke];
        
        _pieView1 = [[XZMPieView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
        [self.SLView2 addSubview:_pieView1];
        [_pieView1 setDatas:arr colors:[NSArray arrayWithArray:array]];
        [_pieView1 stroke];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

//    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-200)/2, 180, 200, 200)];
//    [self.view addSubview:_imageView];
//    [self creat];
    
//    [self.bgView.layer setMasksToBounds:YES];
//    self.bgView.layer.cornerRadius = 8;
    _isLimit = NO;
    _msg = @"抱歉，该权限只为托管用户开放。";

    self.scroll.contentSize = CGSizeMake(self.view.frame.size.width*2, self.scroll.frame.size.height);
    self.scroll.pagingEnabled = YES;
    
    _x = self.blueLine.frame.origin.x;
    _color = _nowLabel.textColor;
    _color2 = _onceLabel.textColor;
    
    [self.playBtn.layer setMasksToBounds:YES];
    self.playBtn.layer.cornerRadius = 2;
    [self.playBtn setBackgroundImage:[UIImage imageNamed:@"挖矿_03.png"] forState:UIControlStateNormal];
    
    NSString *idstring = @"LLacount1";
    NSString* key = @"a7dc3ba6d2e84e16a8b2301924f566a6";

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyyMMddHHMMss"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:1296035591];
    NSLog(@"1296035591  = %@",confromTimesp);
    NSString *date = [formatter stringFromDate:confromTimesp];
    NSLog(@"data =  %@",date);
    NSString *data = [NSString stringWithFormat:@"%@%@%@", idstring, key, date];
    key = @"a674d63f8e0048e6bb562ac1c3d0bf22";
    NSString *s = [self hmac:data withKey:key];
    s = [s uppercaseString];
    key = @"a7dc3ba6d2e84e16a8b2301924f566a6";
    NSDictionary *dic = @{@"key":key, @"nonce":date, @"signature":s, @"coin":@"BTC"};
    [self requsetBTCWithDic:dic];
    dic = @{@"key":key, @"nonce":date, @"signature":s, @"coin":@"DASH"};
    [self requsetDASHWithDic:dic];
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        UILabel *label = (UILabel *)[self.view viewWithTag:i+10];
        UIColor *color = label.backgroundColor;
        [array addObject:color];
    }
    [array insertObject:[array objectAtIndex:9] atIndex:1];
    [array removeObjectAtIndex:10];
    NSArray *arr = @[@"1979", @"1789", @"1554", @"1081", @"1014", @"338", @"275", @"136", @"135", @"1699"];
    _pieView = [[XZMPieView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
    
    [self.SLView addSubview:_pieView];
    [_pieView setDatas:arr colors:[NSArray arrayWithArray:array]];
    [_pieView stroke];
    
    _pieView1 = [[XZMPieView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
    
    [self.SLView2 addSubview:_pieView1];
    [_pieView1 setDatas:arr colors:[NSArray arrayWithArray:array]];
    [_pieView1 stroke];
    
}

- (void) requsetBTCWithDic : (NSDictionary *)dic
{
    __weak __typeof(self) weakSelf = self;
    [[NetworkTool sharedTool] requestWithHPURLString:@"https://antpool.com/api/poolStats.htm" parameters:dic method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@", stringData, JSON );
        NSDictionary *d = [JSON objectForKey:@"data"];
        [weakSelf performSelectorOnMainThread:@selector(showBTCDataWithDic:) withObject:d waitUntilDone:YES];
    } failed:^(NSError *error) {
        //        [weakSelf requestError];
    }];
}

- (void) requsetDASHWithDic : (NSDictionary *)dic
{
    __weak __typeof(self) weakSelf = self;
    [[NetworkTool sharedTool] requestWithHPURLString:@"https://antpool.com/api/poolStats.htm" parameters:dic method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@", stringData, JSON );
        NSDictionary *d = [JSON objectForKey:@"data"];
        [weakSelf performSelectorOnMainThread:@selector(showDASHDataWithDic:) withObject:d waitUntilDone:YES];
    } failed:^(NSError *error) {
        //        [weakSelf requestError];
    }];
}

- (void) request
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *phoneNum = [defaults objectForKey:@"phoneNum"];
    if (!phoneNum.length) {
        _isLimit = NO;
        return;
    }
    NSDictionary *dic = @{@"phone":phoneNum};
    [[NetworkTool sharedTool] requestWithURLString:@"AntsPool/findUserTrusteeship" parameters:dic method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@", stringData, JSON );
        //        NSString *isError = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            //                        [weakSelf verifyPass];
            _isLimit = YES;
        } else {
            _isLimit = NO;
            _msg = [JSON objectForKey:@"msg"];
        }
    } failed:^(NSError *error) {
        //        [weakSelf requestError];
    }];
}

- (void) showDASHDataWithDic : (NSDictionary *) dic
{
    double s = [[dic objectForKey:@"poolHashrate"] doubleValue];
    self.difficultyLabel1.text = [NSString stringWithFormat:@"%@ PH/s", [dic objectForKey:@"networkDiff"]];
    self.timeLabel1.text = [NSString stringWithFormat:@"%.2lf MH/s", s];
    self.sumLabel1.text = [dic objectForKey:@"totalBlockNumber"];
    self.validLabel1.text = [dic objectForKey:@"activeWorkerNumber"];
}

- (void) showBTCDataWithDic : (NSDictionary *) dic
{
    double s = [[dic objectForKey:@"poolHashrate"] doubleValue];
    self.difficultyLabel.text = [NSString stringWithFormat:@"%@ PH/s", [dic objectForKey:@"networkDiff"]];
    self.timeLabel.text = [NSString stringWithFormat:@"%.2lf MH/s", s];
    self.sumLabel.text = [dic objectForKey:@"totalBlockNumber"];
    self.validLabel.text = [dic objectForKey:@"activeWorkerNumber"];

}

- (NSString *)hmac:(NSString *)plaintext withKey:(NSString *)key
{
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [plaintext cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *HMACData = [NSData dataWithBytes:cHMAC length:sizeof(cHMAC)];
    const unsigned char *buffer = (const unsigned char *)[HMACData bytes];
    NSMutableString *HMAC = [NSMutableString stringWithCapacity:HMACData.length * 2];
    for (int i = 0; i < HMACData.length; ++i){
        [HMAC appendFormat:@"%02x", buffer[i]];
    }
    
    return HMAC;
}

- (IBAction)playBtnClick:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *value = [defaults objectForKey:@"isLogin"];
    if (![value isEqualToString:@"YES"]) {
        LoginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
//
//    MonitoringViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MonitoringVC"];
//    [self.navigationController pushViewController:vc animated:YES];
    if (!_isLimit) {
        [self showToastWithMessage:_msg];
        return;
    }
    PooledMiningViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PooledMiningVC"];
    [self.navigationController pushViewController:vc animated:YES];

}

- (IBAction)btnClick:(id)sender {
    int tag = (int)[(UIButton *)sender tag];
    if (tag == 10) {
        tag = 0;
    } else {
        tag = 1;
    }
    [self.scroll scrollRectToVisible:CGRectMake(self.view.frame.size.width*tag, 0, self.view.frame.size.width, self.scroll.frame.size.height) animated:YES];
    if (tag == 0) {
        _nowLabel.textColor = _color;
        _onceLabel.textColor = _color2;
    } else {
        _nowLabel.textColor = _color2;
        _onceLabel.textColor = _color;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x != 0 && scrollView == self.scroll) {
        CGRect frame = self.blueLine.frame;
        NSInteger x = 2;
        frame.origin.x = scrollView.contentOffset.x/x+_x;
        self.blueLine.frame = frame;
    }
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat f = scrollView.contentOffset.x/self.view.frame.size.width;
    if (f == 0) {
        _nowLabel.textColor = _color;
        _onceLabel.textColor = _color2;
    } else {
        _nowLabel.textColor = _color2;
        _onceLabel.textColor = _color;
    }
//    CGFloat pagewidth = self.view.frame.size.width;
//    int currentPage = floor((self.scroll.contentOffset.x - pagewidth/ 2) / pagewidth) + 1;
    //    int currentPage_ = (int)self.scrollView.contentOffset.x/320; // 和上面两行效果一样
//    if (currentPage==0) {
//        [self.scroll scrollRectToVisible:CGRectMake(self.view.frame.size.width * [self.dataArr count], 0, VIEWWIDTH, VIEWHEIGHT) animated:NO]; // 序号0 最后1页
//    } else if (currentPage==([self.dataArr count]+1)) {
//        [self.scroll scrollRectToVisible:CGRectMake(VIEWWIDTH, 0, VIEWWIDTH, VIEWHEIGHT) animated:NO]; // 最后+1,循环第1页
//    }
    

}

- (UIColor *) colorWithHexString: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];//字符串处理
    //例子，stringToConvert #ffffff
    if ([cString length] < 6)
        return [UIColor colorWithRed:((float) 0 / 255.0f)
                               green:((float) 0 / 255.0f)
                                blue:((float) 0 / 255.0f)
                               alpha:1.0f];//如果非十六进制，返回白色
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];//去掉头
    if ([cString length] != 6)//去头非十六进制，返回白色
        return [UIColor colorWithRed:((float) 0 / 255.0f)
                               green:((float) 0 / 255.0f)
                                blue:((float) 0 / 255.0f)
                               alpha:1.0f];
    //分别取RGB的值
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    //NSScanner把扫描出的制定的字符串转换成Int类型
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    //转换为UIColor
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

//  生成二维码
//- (void) creat
//{
//    UIImage *image = [CreatQRCode qrImageForString:self.textTF.text imageSize:200 logoImageSize:0];
//    _imageView.image = image;
//}

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

