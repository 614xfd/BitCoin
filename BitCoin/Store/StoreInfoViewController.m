//
//  StoreInfoViewController.m
//  BitCoin
//
//  Created by LBH on 2017/10/12.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import "StoreInfoViewController.h"
#import "OrderViewController.h"
#import "LoginViewController.h"

@interface StoreInfoViewController () {
    NSArray *_dataArray;
    ImagesScrollView *_adsScrollView;
    NSMutableArray *_adsArray;
    NSString *_carriage;
    NSString *_sIconImageString;
    int _x;//数量
    UIButton *_lineBTN;
    BOOL _isKeyBoardShow;
    NSString *_stock;
}

@end

@implementation StoreInfoViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setBarBlackColor:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _adsArray = [NSMutableArray array];
    _dataArray = [NSArray array];
    if (@available(iOS 11.0, *)) {
        [self.scroll setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.storeTitleLabel.text = [self.dic objectForKey:@"productsName"];
    _x = 1;
    _isKeyBoardShow = NO;
    NSString *str = [self.dic objectForKey:@"titleImage"];
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",str]]];
    self.nameLabel.text = [self.dic objectForKey:@"title"];
    NSString *string = [self.dic objectForKey:@"price"];
    double s = [string doubleValue];
    self.priceLabel.text = [NSString stringWithFormat:@"%.2lf GTSE", s];
    
    self.storeView.frame = CGRectMake(0, self.storeView.frame.size.height, self.view.frame.size.width, self.storeView.frame.size.height);
    self.bgLabel.hidden = YES;
    self.trusteeshipView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.trusteeshipView.frame.size.height);

    self.scroll.contentSize = CGSizeMake(self.view.frame.size.width, 502*kScaleH);
    self.sNumberTF.keyboardType = UIKeyboardTypeNumberPad;
    
    [self.rimLabel.layer setMasksToBounds:YES];
    self.rimLabel.layer.cornerRadius = 3;
    [self.rimLabel.layer setBorderWidth:0.5];
    [self.rimLabel.layer setBorderColor:[UIColor colorWithRed:227/255.0 green:227/255.0 blue:230/255.0 alpha:1].CGColor];
    self.sPriceLabel.text = [NSString stringWithFormat:@"%@ USDT", [self.dic objectForKey:@"productsPrice"]];
    self.sInventoryLabel.text = [NSString stringWithFormat:@"库存：%@", [self.dic objectForKey:@"productsNumber"]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self request];
//    [self requestTrusteeship];
//    [self requestInfo];
}

- (void) request
{
    __weak __typeof(self) weakSelf = self;
    NSDictionary *dic = @{@"id":[self.dic objectForKey:@"id"]};
    [[NetworkTool sharedTool] requestWithURLString:@"mall/goods/getById" parameters:dic method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@", stringData, JSON );
        //        NSString *isError = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            //            [weakSelf verifyPass];
//            NSArray *array = [JSON objectForKey:@"data"];
//            if (array) {
//                if ([[[[array objectAtIndex:0] objectAtIndex:0] allKeys]  containsObject: @"path"]) {
//                    _dataArray = [array objectAtIndex:0];
//                    [weakSelf performSelectorOnMainThread:@selector(creatImage) withObject:nil waitUntilDone:YES];
//                }
//                if ([[[[array objectAtIndex:1] objectAtIndex:0] allKeys]  containsObject: @"productImg"]) {
//                    NSArray *arr = [array objectAtIndex:1];
//                    for (int i = 0; i < arr.count; i++) {
//                        [_adsArray addObject:[[arr objectAtIndex:i] objectForKey:@"productImg"]];
//                    }
//                    [weakSelf performSelectorOnMainThread:@selector(creatImageScroll) withObject:nil waitUntilDone:YES];
//                }
//            }
            NSDictionary *d = [JSON objectForKey:@"data"];
            NSArray *detailsImage = [d objectForKey:@"detailsImage"];
            NSArray *carouseImage = [d objectForKey:@"carouseImage"];
            _stock = [NSString stringWithFormat:@"%@", [d objectForKey:@"stock"]];
            if (carouseImage.count) {
                for (int i = 0; i < carouseImage.count; i++) {
                    [_adsArray addObject:[carouseImage objectAtIndex:i]];
                }
                [weakSelf performSelectorOnMainThread:@selector(creatImageScroll) withObject:nil waitUntilDone:YES];

            }
            if (detailsImage.count) {
                _dataArray = [NSArray arrayWithArray:detailsImage];
                [weakSelf performSelectorOnMainThread:@selector(creatImage) withObject:nil waitUntilDone:YES];
            }
            
        } else {
            [weakSelf performSelectorOnMainThread:@selector(showToastWithMessage:) withObject:[JSON objectForKey:@"msg"] waitUntilDone:YES];
        }
    } failed:^(NSError *error) {
        //        [weakSelf requestError];
    }];
//    dic = @{@"path":@"广东省"};
//    [[NetworkTool sharedTool] requestWithURLString:@"freight/freight" parameters:dic method:@"POST" completed:^(id JSON, NSString *stringData) {
//        NSLog(@"%@      ------------- %@", stringData, JSON );
//        //        NSString *isError = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
//        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
//        if ([code isEqualToString:@"1"]) {
//            _carriage = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"Data"]];
//            [weakSelf performSelectorOnMainThread:@selector(setCarriage) withObject:nil waitUntilDone:YES];
//        } else {
//            [weakSelf showToastWithMessage:[JSON objectForKey:@"msg"]];
//        }
//    } failed:^(NSError *error) {
//        //        [weakSelf requestError];
//    }];
}

//- (void) requestTrusteeship
//{
//    __weak __typeof(self) weakSelf = self;
//    NSDictionary *dic = @{};
//    [[NetworkTool sharedTool] requestWithURLString:@"product/Trusteeship" parameters:dic method:@"POST" completed:^(id JSON, NSString *stringData) {
//        NSLog(@"%@      ------------- %@", stringData, JSON );
//        //        NSString *isError = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
//        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
//        if ([code isEqualToString:@"1"]) {
//            //            [weakSelf verifyPass];
//
//        } else {
//            [weakSelf performSelectorOnMainThread:@selector(showToastWithMessage:) withObject:[JSON objectForKey:@"msg"] waitUntilDone:YES];
//        }
//    } failed:^(NSError *error) {
//        //        [weakSelf requestError];
//    }];
//}

//- (void) requestInfo
//{
//    __weak __typeof(self) weakSelf = self;
//    NSDictionary *dic = @{};
//    [[NetworkTool sharedTool] requestWithURLString:@"product/Trusteeship" parameters:dic method:@"POST" completed:^(id JSON, NSString *stringData) {
//        NSLog(@"%@      ------------- %@", stringData, JSON );
//        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
//        if ([code isEqualToString:@"1"]) {
//            [weakSelf performSelectorOnMainThread:@selector(setInfo:) withObject:[JSON objectForKey:@"Data"] waitUntilDone:YES];
//        } else {
////            [weakSelf showToastWithMessage:[JSON objectForKey:@"msg"]];
//            [weakSelf performSelectorOnMainThread:@selector(showToastWithMessage:) withObject:[JSON objectForKey:@"msg"] waitUntilDone:YES];
//        }
//    } failed:^(NSError *error) {
//    }];
//}

- (void) setInfo : (NSDictionary *)dic
{
    self.infoLabel.text = [dic objectForKey:@"TrusteeshipData"];
    self.infoPhoneLabel.text = [dic objectForKey:@"TrusteeshipPhone"];
}

//- (void) setCarriage
//{
//    self.carriageLabel.text = _carriage;
//}

- (void) creatImage
{
    CGFloat s = self.infoVIew.frame.size.height+self.infoVIew.frame.origin.y;
    for (int i = 0; i < _dataArray.count; i++) {
        double imgHeight = [[[_dataArray objectAtIndex:i] objectForKey:@"height"] doubleValue];
        double imgWidth = [[[_dataArray objectAtIndex:i] objectForKey:@"width"] doubleValue];
        double x = self.view.frame.size.width/imgWidth;
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, s, self.view.frame.size.width, imgHeight*x)];
        NSString *string = [NSString stringWithFormat:@"%@", [[_dataArray objectAtIndex:i] objectForKey:@"url"]];
        [image sd_setImageWithURL:[NSURL URLWithString:string]];
        [self.scroll addSubview:image];
        
        s+=image.frame.size.height;
        CGSize size = self.scroll.contentSize;
        size = CGSizeMake(size.width, size.height+image.frame.size.height);
        self.scroll.contentSize = size;
    }
}

- (void) creatImageScroll
{
    _adsScrollView = [[ImagesScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width/800*626) withImagesArray:_adsArray isRound:NO withImageWidth:self.view.frame.size.width/800*626 withImageHeight:self.view.frame.size.width isSmall : NO time:5.0 tag:100];
    _adsScrollView.tag = 100;
    _adsScrollView.delegate = self;

    [self.scroll addSubview:_adsScrollView];
    
    _sIconImageString = [NSString stringWithFormat:@"%@%@", IMAGE_URL, [_adsArray objectAtIndex:0]];
    [self.sIconImage sd_setImageWithURL:[NSURL URLWithString:_sIconImageString]];
    
    self.nInventoryLabel.text = [NSString stringWithFormat:@"库存：%@", _stock];
    self.infoVIew.frame = CGRectMake(self.infoVIew.frame.origin.x, _adsScrollView.frame.size.height, self.infoVIew.frame.size.width, self.infoVIew.frame.size.height);
}

- (IBAction)buyBtnClick:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *value = [defaults objectForKey:@"isLogin"];
    if (![value isEqualToString:@"YES"]) {
        LoginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    OrderViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderVC"];
    vc.dic = self.dic;
    vc.imageString = _sIconImageString;
    vc.storeNum = self.numTF.text;
    [self.navigationController pushViewController:vc animated:YES];
//    self.storeView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.storeView.frame.size.height);
//    self.bgLabel.hidden = NO;
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"暂未开放,请移至官网查看最新消息。"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//    [alert show];
}

- (IBAction)intoOrder:(id)sender {
    
    
    
    OrderViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderVC"];
    vc.dic = self.dic;
    vc.imageString = _sIconImageString;
    vc.storeNum = self.numTF.text;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)subtractBtnClick:(id)sender {
    _x = [self.sNumberTF.text intValue];
    if (_x == 1) {
        return;
    } else {
        _x -= 1;
        self.sNumberTF.text = [NSString stringWithFormat:@"%d", _x];
        self.sNumberTF.text = [NSString stringWithFormat:@"%d", _x];
    }
}
- (IBAction)showTrusteeship:(id)sender {
    self.bgLabel.hidden = NO;
    self.trusteeshipView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.trusteeshipView.frame.size.height);
}

- (IBAction)addBtnClick:(id)sender {
    _x = [self.sNumberTF.text intValue];
    int s = [[self.dic objectForKey:@"productsNumber"] intValue];
    if (_x<s) {
        _x += 1;
        self.sNumberTF.text = [NSString stringWithFormat:@"%d", _x];
        self.sNumberTF.text = [NSString stringWithFormat:@"%d", _x];
    }
}

- (IBAction)payPhone:(id)sender {
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"13680757389"];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
    
//    NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"13680757389"];
//    // NSLog(@"str======%@",str);
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (IBAction)hiddenStoreView:(id)sender {
    if (_isKeyBoardShow) {
        [self.sNumberTF resignFirstResponder];
        return;
    }
    self.storeView.frame = CGRectMake(0, self.storeView.frame.size.height, self.view.frame.size.width, self.storeView.frame.size.height);
    self.bgLabel.hidden = YES;
    self.trusteeshipView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.trusteeshipView.frame.size.height);
}

//键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
    
//    _lineBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    _isKeyBoardShow = YES;

    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;

    CGFloat offset = (self.view.frame.size.height - kbHeight);
    if(offset > 0) {
        //        self.tableView.frame = CGRectMake(0.0f, -55*5, self.view.frame.size.width, self.view.frame.size.height);
        self.view.frame = CGRectMake(0, -kbHeight, self.view.frame.size.width, self.view.frame.size.height);
    }
}



//键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {
    _isKeyBoardShow = NO;

    //    self.tableView.frame = CGRectMake(0, 0, _bgView.frame.size.width, _bgView.frame.size.height);
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.sNumberTF resignFirstResponder];
}
- (IBAction)nAddBtnClick:(id)sender {
    if ([self.numTF.text intValue] < [_stock intValue]) {
        self.numTF.text  = [NSString stringWithFormat:@"%d", [self.numTF.text intValue]+1];
    } else {
        self.numTF.text  = [NSString stringWithFormat:@"%@", _stock];
    }
}

- (IBAction)nSubtractBtnClick:(id)sender {
    if ([self.numTF.text intValue] > 1) {
        self.numTF.text  = [NSString stringWithFormat:@"%d", [self.numTF.text intValue]-1];
    } else {
        self.numTF.text  = @"1";
    }
}



#pragma mark  循环scroll广告点击事件跳转
- (void) index:(unsigned long)index tag:(unsigned long)tag
{
    NSString *string;
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
