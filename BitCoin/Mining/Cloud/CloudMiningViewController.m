//
//  CloudMiningViewController.m
//  BitCoin
//
//  Created by LBH on 2018/9/6.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "CloudMiningViewController.h"
#import "NodeMiningViewController.h"
// 弹出分享菜单需要导入的头文件
//#import <ShareSDK/ShareSDK.h>
//#import <ShareSDKUI/ShareSDK+SSUI.h>
//// 自定义分享菜单栏需要导入的头文件
//#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
//#import <ShareSDKUI/SSUIEditorViewStyle.h>
#import "CreatQRCode.h"
#import "LoginViewController.h"
#import "ClounMiningInfoViewController.h"

@interface CloudMiningViewController () {
    BOOL _isUnUseViewShow;
    BOOL _isUseViewShow;
}

@end

@implementation CloudMiningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (@available(iOS 11.0, *)) {
        [self.unUseTableView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        [self.useTableView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.activatBtn.layer setMasksToBounds:YES];
    self.activatBtn.layer.cornerRadius = self.activatBtn.frame.size.height/2;
    [self.unUseTipLael.layer setMasksToBounds:YES];
    self.unUseTipLael.layer.cornerRadius = self.unUseTipLael.frame.size.height/2;
    [self.useTipLabel.layer setMasksToBounds:YES];
    self.useTipLabel.layer.cornerRadius = self.useTipLabel.frame.size.height/2;
    self.cardScroll.contentSize = CGSizeMake(714*kScaleW, self.cardScroll.frame.size.height);
    self.unUseArray = @[];
    self.useArray = @[];
    _isUnUseViewShow = NO;
    _isUseViewShow = NO;
    //    [self.unUseTableView setEditing:YES animated:YES];
    [self request];
    [self requestCode];
}

- (void) setDataInfo
{
    self.accumulatedIncomeLabel.text = [NSString stringWithFormat:@"%.2lf", [[self.dataDic objectForKey:@"accumulatedIncome"] doubleValue]];
    self.anticipatedIncomeLabel.text = [NSString stringWithFormat:@"%@", [self.dataDic objectForKey:@"anticipatedIncome"]];
    self.dayOutputLabel.text = [NSString stringWithFormat:@"%@", [self.dataDic objectForKey:@"dayOutput"]];
    self.surplusDayLabel.text = [NSString stringWithFormat:@"%@", [self.dataDic objectForKey:@"surplusDay"]];
    self.accumulatedIncome1Label.text = [NSString stringWithFormat:@"%.2lfBBC", [[self.dataDic objectForKey:@"accumulatedIncome"] doubleValue]];
    self.unUseTipLael.backgroundColor = [UIColor colorWithRed:252/255.0 green:160/255.0 blue:47/255.0 alpha:1];
    self.useTipLabel.backgroundColor = [UIColor colorWithRed:252/255.0 green:160/255.0 blue:47/255.0 alpha:1];
    self.useTipLabel.text = @"已激活";
    self.unUseTipLael.text = @"已激活";
    self.activatBtn.hidden = YES;
    self.codeDayGetLable.text = @"2个";
    self.codeAllNumLabel.text = @"60个";
    self.dayNumLabel.text = [NSString stringWithFormat:@"%@个", [self.dataDic objectForKey:@"codeBalance"]];
}

- (void) setUnuseNum
{
    self.unUseCodeNumLabel.text = [NSString stringWithFormat:@"%ld个", self.unUseArray.count];
    self.codeNumLabel.text = [NSString stringWithFormat:@"%ld", self.unUseArray.count+self.useArray.count];
}


- (void) request
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uid = [defaults objectForKey:@"uid"];
    if (uid.length) {
        __weak __typeof(self) weakSelf = self;
        NSDictionary *d = @{@"uid":uid};
        [[NetworkTool sharedTool] requestWithURLString:@"cloundMill/getHomeDate" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
            NSLog(@"%@      ------------- %@", stringData, JSON );
            NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
            if ([code isEqualToString:@"1"]) {
                weakSelf.dataDic = [NSDictionary dictionaryWithDictionary:[JSON objectForKey:@"Data"]];
                [weakSelf performSelectorOnMainThread:@selector(setDataInfo) withObject:nil waitUntilDone:YES];
            } else {
            }
            
        } failed:^(NSError *error) {
            //        [weakSelf requestError];
        }];
    }
    
}

- (void) requestNode
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uid = [defaults objectForKey:@"uid"];
    if (uid.length) {
        __weak __typeof(self) weakSelf = self;
        NSDictionary *d = @{@"uid":uid, @"code":self.ACTF.text, @"mac":self.MACTF.text};
        [[NetworkTool sharedTool] requestWithURLString:@"cloundMill/activateMill" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
            NSLog(@"%@      ------------- %@", stringData, JSON );
            NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
            if ([code isEqualToString:@"1"]) {
                [weakSelf performSelectorOnMainThread:@selector(success:) withObject:[JSON objectForKey:@"msg"] waitUntilDone:YES];
            } else {
                [weakSelf performSelectorOnMainThread:@selector(showToastWithMessage:) withObject:[JSON objectForKey:@"msg"] waitUntilDone:YES];
            }
        } failed:^(NSError *error) {
            //        [weakSelf requestError];
        }];
    }
    
}

- (void) requestCode
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uid = [defaults objectForKey:@"uid"];
    if (uid.length) {
        __weak __typeof(self) weakSelf = self;
        NSDictionary *d = @{@"uid":uid};
        [[NetworkTool sharedTool] requestWithURLString:@"cloundMill/getActivation" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
            NSLog(@"%@      ------------- %@", stringData, JSON );
            NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
            if ([code isEqualToString:@"1"]) {
                NSArray *array = [JSON objectForKey:@"Data"];
                NSMutableArray *mArray = [NSMutableArray array];
                NSMutableArray *mArr = [NSMutableArray array];
                for (int i = 0; i < array.count; i++) {
                    NSString *str = [NSString stringWithFormat:@"%@", [[array objectAtIndex:i]objectForKey:@"status"]];
                    if ([str isEqualToString:@"0"]) {
                        [mArray addObject:[[array objectAtIndex:i]objectForKey:@"activationCode"]];
                    } else if ([str isEqualToString:@"1"]){
                        [mArr addObject:[[array objectAtIndex:i]objectForKey:@"activationCode"]];
                    }
                }
                self.unUseArray = [NSArray arrayWithArray:mArray];
                self.useArray = [NSArray arrayWithArray:mArr];
                [weakSelf performSelectorOnMainThread:@selector(setUnuseNum) withObject:nil waitUntilDone:YES];
                [weakSelf.unUseTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            }
            
        } failed:^(NSError *error) {
            //        [weakSelf requestError];
        }];
    }
}

- (void) success : (NSString *)string
{
    [self hiddenActivatView];
    [self showToastWithMessage:string];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    NSArray *array;
    if (tableView == self.unUseTableView) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"unUse" forIndexPath:indexPath];
        array = [NSArray arrayWithArray:self.unUseArray];
        //        UIView *view = (UIView *) [cell.contentView.subviews firstObject];
        //        UIButton *show = (UIButton *) [view.subviews objectAtIndex:2];
        //        show.tag = indexPath.row+100000;
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"use" forIndexPath:indexPath];
        array = [NSArray arrayWithArray:self.useArray];
    }
    UILabel *bgLabel = (UILabel *)[cell viewWithTag:2];
    
    if (array.count) {
        UILabel *code = (UILabel *)[cell viewWithTag:1];
        code.text = [array objectAtIndex:indexPath.row];
        bgLabel.hidden = YES;
        
    } else {
        bgLabel.hidden = NO;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.unUseTableView) {
        if (self.unUseArray.count == 0) {
            return 1;
        }
        return self.unUseArray.count;
    } else {
        if (self.useArray.count == 0) {
            return 1;
        }
        return self.useArray.count;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60*kScaleH;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak __typeof(self) weakSelf = self;
    
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"分享" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath)
                                     {
                                         [weakSelf performSelectorOnMainThread:@selector(share:) withObject: [self.unUseArray objectAtIndex:indexPath.row] waitUntilDone:YES];
                                     }];
    
    action1.backgroundColor = [UIColor colorWithRed:255/255.0 green:46/255.0 blue:0/255.0 alpha:1];
    
    UITableViewRowAction *action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"复制" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath)
                                     {
                                         UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                                         pasteboard.string = [self.unUseArray objectAtIndex:indexPath.row];
                                         [weakSelf performSelectorOnMainThread:@selector(showToastWithMessage:) withObject:@"复制成功！" waitUntilDone:YES];
                                     }];
    
    action2.backgroundColor = [UIColor colorWithRed:41/255.0 green:129/255.0 blue:255/255.0 alpha:1];
    
    return @[action1,action2];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = cell = [tableView cellForRowAtIndexPath:indexPath];
    UIView *view = (UIView *)[cell.contentView.subviews lastObject];
    [UIView animateWithDuration:0.3 animations:^ {
        view.frame = CGRectMake(-120, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
    //    [self tableView:tableView editActionsForRowAtIndexPath:indexPath];
}

- (IBAction)unUseBtnClick:(id)sender {
    if (_isUnUseViewShow) {
        [self hiddenAllView];
        _isUnUseViewShow = NO;
        return;
    }
    CGFloat x = 3.5;
    if (self.unUseArray.count == 0) {
        x = 1;
    } else if (self.unUseArray.count <= 3) {
        x = self.unUseArray.count;
    }
    
    [UIView animateWithDuration:0.3 animations:^ {
        self.unUseView.frame = CGRectMake(self.unUseView.frame.origin.x, self.unUseView.frame.origin.y, self.unUseView.frame.size.width, (70+60*x)*kScaleH);
        self.useView.frame = CGRectMake(self.useView.frame.origin.x, self.unUseView.frame.origin.y+self.unUseView.frame.size.height, self.useView.frame.size.width, 70*kScaleH);
        self.earningsView.frame = CGRectMake(self.earningsView.frame.origin.x, self.useView.frame.origin.y+self.useView.frame.size.height, self.earningsView.frame.size.width, self.earningsView.frame.size.height);
        self.nodeView.frame = CGRectMake(self.nodeView.frame.origin.x, self.earningsView.frame.origin.y+self.earningsView.frame.size.height, self.nodeView.frame.size.width, self.nodeView.frame.size.height);
        self.activatView.frame = CGRectMake(self.activatView.frame.origin.x, self.nodeView.frame.origin.y+self.nodeView.frame.size.height, self.nodeView.frame.size.width, self.activatView.frame.size.height);
        
    } completion:^(BOOL finished) {
        
    }];
    self.scroll.contentSize = CGSizeMake(self.view.frame.size.width, self.scroll.frame.size.height+60*x*kScaleH);
    _isUnUseViewShow = YES;
    _isUseViewShow = NO;
}

- (IBAction)useBtnClick:(id)sender {
    if (_isUseViewShow) {
        [self hiddenAllView];
        _isUseViewShow = NO;
        return;
    }
    CGFloat x = 3.5;
    if (self.useArray.count == 0) {
        x = 1;
    } else if (self.useArray.count <= 3) {
        x = self.useArray.count;
    }
    [UIView animateWithDuration:0.3 animations:^ {
        self.unUseView.frame = CGRectMake(self.unUseView.frame.origin.x, self.unUseView.frame.origin.y, self.unUseView.frame.size.width, 70*kScaleH);
        self.useView.frame = CGRectMake(self.useView.frame.origin.x, self.unUseView.frame.origin.y+self.unUseView.frame.size.height, self.useView.frame.size.width, (70+60*x)*kScaleH);
        self.earningsView.frame = CGRectMake(self.earningsView.frame.origin.x, self.useView.frame.origin.y+self.useView.frame.size.height, self.earningsView.frame.size.width, self.earningsView.frame.size.height);
        self.nodeView.frame = CGRectMake(self.nodeView.frame.origin.x, self.earningsView.frame.origin.y+self.earningsView.frame.size.height, self.nodeView.frame.size.width, self.nodeView.frame.size.height);
        self.activatView.frame = CGRectMake(self.activatView.frame.origin.x, self.nodeView.frame.origin.y+self.nodeView.frame.size.height, self.nodeView.frame.size.width, self.activatView.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
    self.scroll.contentSize = CGSizeMake(self.view.frame.size.width, self.scroll.frame.size.height+60*x*kScaleH);
    _isUseViewShow = YES;
    _isUnUseViewShow = NO;
}

- (IBAction)intoInfoBtnClick:(id)sender {
    ClounMiningInfoViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ClounMiningInfoVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)nodeBtnClick:(id)sender {
    NodeMiningViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"NodeMiningVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)activatBtnClick:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *value = [defaults objectForKey:@"isLogin"];
    if ([value isEqualToString:@"YES"]) {
        self.bgView.hidden = NO;
        self.bgBtn.hidden = NO;
    } else {
        LoginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)resetMessage:(NSString *)string
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *phoneNum = [defaults objectForKey:@"phoneNum"];
    
    __weak __typeof(self) weakSelf = self;
    NSDictionary *dic = @{@"phone":phoneNum};
    [[NetworkTool sharedTool] requestWithURLString:@"Certificates/findSate" parameters:dic method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@", stringData, JSON );
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            NSString *string = [NSString stringWithFormat:@"%@", [[JSON objectForKey:@"Data"] objectForKey:@"AuthenticationStatus"]];
            [defaults setObject:code forKey:@"authenticationStatus"];
            
        } else {
            [weakSelf performSelectorOnMainThread:@selector(showToastWithMessage:) withObject:[JSON objectForKey:@"msg"] waitUntilDone:YES];
        }
    } failed:^(NSError *error) {
    }];
}

- (IBAction)confirmBtnClick:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *s = [defaults objectForKey:@"authenticationStatus"];
    if ([s isEqualToString:@"2"]||[s isEqualToString:@"1"]) {
        if (self.ACTF.text.length > 0&& self.MACTF.text.length > 0) {
            [self requestNode];
        }
    } else{
        RealNameViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RealNameVC"];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (IBAction)cancelBtnClick:(id)sender {
    [self hiddenActivatView];
}

- (void) hiddenActivatView
{
    self.bgView.hidden = YES;
    self.bgBtn.hidden = YES;
}

- (void) hiddenAllView
{
    [UIView animateWithDuration:0.3 animations:^ {
        self.unUseView.frame = CGRectMake(self.unUseView.frame.origin.x, self.unUseView.frame.origin.y, self.unUseView.frame.size.width, 70*kScaleH);
        self.useView.frame = CGRectMake(self.useView.frame.origin.x, self.unUseView.frame.origin.y+self.unUseView.frame.size.height, self.useView.frame.size.width, 70*kScaleH);
        self.earningsView.frame = CGRectMake(self.earningsView.frame.origin.x, self.useView.frame.origin.y+self.useView.frame.size.height, self.earningsView.frame.size.width, self.earningsView.frame.size.height);
        self.nodeView.frame = CGRectMake(self.nodeView.frame.origin.x, self.earningsView.frame.origin.y+self.earningsView.frame.size.height, self.nodeView.frame.size.width, self.nodeView.frame.size.height);
        self.activatView.frame = CGRectMake(self.activatView.frame.origin.x, self.nodeView.frame.origin.y+self.nodeView.frame.size.height, self.nodeView.frame.size.width, self.activatView.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
    self.scroll.contentSize = CGSizeMake(self.view.frame.size.width, self.scroll.frame.size.height);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hiddenAllView];
}

- (void) share:(NSString *)string
{
//    UIImage *image = [CreatQRCode qrImageForString:string imageSize:150 logoImageSize:0];
//    //1、创建分享参数（必要）
//    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//    //    NSArray* imageArray = @[[self makeImageWithView:_runShareView withSize:_runShareView.frame.size]];
//    [shareParams SSDKSetupShareParamsByText:@""
//                                     images: @[image]
//                                        url:nil
//                                      title:@"二维码"
//                                       type:SSDKContentTypeAuto];
//    //有的平台要客户端分享需要加此方法，例如微博
//    [shareParams SSDKEnableUseClientShare];
//    
//    //2、分享（可以弹出我们的分享菜单和编辑界面）
//    [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
//                             items:nil
//                       shareParams:shareParams
//               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//                   
//                   switch (state) {
//                       case SSDKResponseStateSuccess:
//                       {
//                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                               message:nil
//                                                                              delegate:nil
//                                                                     cancelButtonTitle:@"确定"
//                                                                     otherButtonTitles:nil];
//                           [alertView show];
//                           break;
//                       }
//                       case SSDKResponseStateFail:
//                       {
//                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                           message:[NSString stringWithFormat:@"%@",error]
//                                                                          delegate:nil
//                                                                 cancelButtonTitle:@"OK"
//                                                                 otherButtonTitles:nil, nil];
//                           [alert show];
//                           break;
//                       }
//                       default:
//                           break;
//                   }
//               }
//     ];
    
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
