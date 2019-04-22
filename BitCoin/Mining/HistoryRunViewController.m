//
//  HistoryRunViewController.m
//  BitCoin
//
//  Created by LBH on 2018/8/11.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "HistoryRunViewController.h"
#import "runShareView.h"

// 弹出分享菜单需要导入的头文件
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
// 自定义分享菜单栏需要导入的头文件
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIEditorViewStyle.h>

@interface HistoryRunViewController () {
    NSString *_code;
    runShareView *_runShareView;
    UIImageView *shareImageView;
}

@end

@implementation HistoryRunViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setBarBlackColor:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (@available(iOS 11.0, *)) {
        [self.tableView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _code = @"";
    [self request];
    [self requestHistroy];
    _runShareView = [[runShareView alloc] initWithFrame:CGRectMake(0, 0, 517, 517)];
    [self.view addSubview:_runShareView];
    [self.view sendSubviewToBack:_runShareView];
}

- (void) creatView
{
    double Coin = 0, Count = 0, Step = 0, KM = 0, KCal = 0;
    for (int i = 0; i < self.dataArray.count; i++) {
        Coin += [[[self.dataArray objectAtIndex:i] objectForKey:@"inCome"] doubleValue];
        Count ++;
        Step += [[[self.dataArray objectAtIndex:i] objectForKey:@"setps"] doubleValue];
        KM += [[[self.dataArray objectAtIndex:i] objectForKey:@"kmcount"] doubleValue];
        KCal += [[[self.dataArray objectAtIndex:i] objectForKey:@"cal"] doubleValue];
    }
    self.allCoinLabel.text = [NSString stringWithFormat:@"%.2lf", Coin];
    self.allCountLabel.text = [NSString stringWithFormat:@"%.0lf", Count];
    self.allStepLabel.text = [NSString stringWithFormat:@"%.0lf", Step];
    self.allKMLabel.text = [NSString stringWithFormat:@"%.2lf", KM];
    self.allKCalLabel.text = [NSString stringWithFormat:@"%.0lf", KCal];
}

- (void) request
{
    __weak __typeof(self) weakSelf = self;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *phoneNum = [defaults objectForKey:@"phoneNum"];
    if (phoneNum.length) {
        NSDictionary *d = @{@"phone":phoneNum};
        [[NetworkTool sharedTool] requestWithURLString:@"UserRegister/shareRegister" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
            NSLog(@"%@      ------------- %@", stringData, JSON );
            NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
            if ([code isEqualToString:@"1"]) {
                NSLog(@"");
                _code = [JSON objectForKey:@"Data"];
            } else {
                
            }
        } failed:^(NSError *error) {
            //        [weakSelf requestError];
        }];
    }
}

- (void) requestHistroy
{
    __weak __typeof(self) weakSelf = self;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uid = [defaults objectForKey:@"uid"];
    
    if (uid.length) {
        NSDictionary *d = @{@"uid":uid};
        [[NetworkTool sharedTool] requestWithURLString:@"blue/sportIncomeHistory" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
            NSLog(@"%@      ------------- %@", stringData, JSON );
            NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
            if ([code isEqualToString:@"1"]) {
                NSArray *array = [NSArray arrayWithArray:[JSON objectForKey:@"Data"]];
                NSEnumerator *enumerator = [array reverseObjectEnumerator];
                NSArray *arr = [enumerator allObjects];
                self.dataArray = [NSArray arrayWithArray:arr];
                [weakSelf.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
                [weakSelf performSelectorOnMainThread:@selector(creatView) withObject:nil waitUntilDone:YES];
            } else {
            }
        } failed:^(NSError *error) {
        }];
    } else {
        
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"history" forIndexPath:indexPath];
    
    UILabel *day = (UILabel *)[cell viewWithTag:1];
    NSArray *array = [[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"date"] componentsSeparatedByString:@"-"];
    day.text = [NSString stringWithFormat:@"%d月%d日", [[array objectAtIndex:1] intValue], [[array objectAtIndex:2] intValue]];

    UILabel *time = (UILabel *)[cell viewWithTag:2];
    time.text = [NSString stringWithFormat:@"%@结算", [[[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"time"] componentsSeparatedByString:@"-"] componentsJoinedByString:@":"]];
    
    UILabel *inCome = (UILabel *)[cell viewWithTag:3];
    inCome.text = [NSString stringWithFormat:@"%.2lf", [[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"inCome"] doubleValue]];
    
    UILabel *step = (UILabel *)[cell viewWithTag:4];
    step.text = [NSString stringWithFormat:@"%.0lf", [[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"setps"] doubleValue]];

    UILabel *KM = (UILabel *)[cell viewWithTag:5];
    KM.text = [NSString stringWithFormat:@"%.2lf", [[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"kmcount"] doubleValue]];
    
    UILabel *KCal = (UILabel *)[cell viewWithTag:6];
    KCal.text = [NSString stringWithFormat:@"%.2lf", [[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"cal"] doubleValue]];
    UIView *view = (UIView *) [cell.contentView.subviews firstObject];
    UIButton *shareBtn = (UIButton *) [view.subviews lastObject];
    shareBtn.tag = indexPath.row+100000;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140*kScaleH;
}

- (IBAction)shareBtnClick:(id)sender {
    NSInteger x = [sender tag]-100000;
    NSArray *array = [[[self.dataArray objectAtIndex:x] objectForKey:@"date"] componentsSeparatedByString:@"-"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *phoneNum = [defaults objectForKey:@"phoneNum"];
    NSDictionary *dic = @{@"phone":phoneNum, @"date": [NSString stringWithFormat:@"%d月%d日", [[array objectAtIndex:1] intValue], [[array objectAtIndex:2] intValue]], @"KM": [NSString stringWithFormat:@"%.2lf", [[[self.dataArray objectAtIndex:x] objectForKey:@"kmcount"] doubleValue]], @"step":[NSString stringWithFormat:@"%.0lf", [[[self.dataArray objectAtIndex:x] objectForKey:@"setps"] doubleValue]], @"coin":[NSString stringWithFormat:@"%.2lf", [[[self.dataArray objectAtIndex:x] objectForKey:@"inCome"] doubleValue]], @"code":_code};
    [_runShareView creatInfoWithDic:dic];
    
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[[self makeImageWithView:_runShareView withSize:_runShareView.frame.size]];
    [shareParams SSDKSetupShareParamsByText:@""
                                     images:imageArray
                                        url:nil
                                      title:@""
                                       type:SSDKContentTypeImage];
    //有的平台要客户端分享需要加此方法，例如微博
    [shareParams SSDKEnableUseClientShare];
    
    //2、分享（可以弹出我们的分享菜单和编辑界面）
    [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                             items:nil
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state) {
                       case SSDKResponseStateSuccess:
                       {
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                           break;
                       }
                       case SSDKResponseStateFail:
                       {
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                           message:[NSString stringWithFormat:@"%@",error]
                                                                          delegate:nil
                                                                 cancelButtonTitle:@"OK"
                                                                 otherButtonTitles:nil, nil];
                           [alert show];
                           break;
                       }
                       default:
                           break;
                   }
               }
     ];
    
}

- (UIImage *)makeImageWithView:(UIView *)view withSize:(CGSize)size
{
    // 第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，关键就是第三个参数 [UIScreen mainScreen].scale。
    UIGraphicsBeginImageContextWithOptions(size, YES, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
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
