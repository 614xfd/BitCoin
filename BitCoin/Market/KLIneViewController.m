////
////  KLIneViewController.m
////  BitCoin
////
////  Created by LBH on 2017/11/14.
////  Copyright © 2017年 LBH. All rights reserved.
////
//
//#import "KLIneViewController.h"
//#import "AFHTTPSessionManager.h"
//#import "KlineModel.h"
//#import "KlineView.h"
//#import "lineView.h"
//
//@interface KLIneViewController () <lineDataSource>
//
//@property (nonatomic, strong)NSArray *KlineModels;
//@property (nonatomic, strong)lineView *line;
//@property (nonatomic, assign)NSInteger index;
//
//@end
//
//@implementation KLIneViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    [self requestWithTime:@"60min"];
//}
//
//- (void) requestWithTime : (NSString *)date
//{
//    NSString *urlString = [NSString stringWithFormat:@"https://api.huobi.pro/market/history/kline?symbol=btcusdt&period=%@", date];
//    __weak __typeof(self) weakSelf = self;
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", nil];
//    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
//        responseObject = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
//        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
//        NSLog(@"------------- %@", jsonDict );
//        jsonDict = [weakSelf changeType:jsonDict];
//        [weakSelf performSelectorOnMainThread:@selector(creatKLineView:) withObject:jsonDict waitUntilDone:YES];
//    } failure:^(NSURLSessionTask *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
//}
//
//- (void) creatKLineView : (NSDictionary *)dic
//{
//    
//    KlineModel *model = [KlineModel new];
//    __weak KLIneViewController *selfWeak = self;
//    [model GetModelArray:^(NSArray *dataArray) {
//        __strong KLIneViewController *strongSelf = selfWeak;
//        strongSelf.KlineModels = dataArray;
//    } andDic:dic];
//    
//    KlineView *kline = [[KlineView alloc] initWithFrame:CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, 300) Delegate:self];
//    
//    kline.ShowTrackingCross = YES;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        kline.ShowTrackingCross = NO;
//    });
//    
//    [self.view addSubview:kline];
//}
//
//- (KlineModel *)LineView:(UIView *)view cellAtIndex:(NSInteger)index;{
//    return [self.KlineModels objectAtIndex:index];
//}
//
//
//- (NSInteger)numberOfLineView:(UIView *)view{
//    return self.KlineModels.count;
//}
//
//
//- (IBAction)goBack:(id)sender {
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
////将NSDictionary中的Null类型的项目转化成@""
//-(NSDictionary *)nullDic:(NSDictionary *)myDic
//{
//    NSArray *keyArr = [myDic allKeys];
//    NSMutableDictionary *resDic = [[NSMutableDictionary alloc]init];
//    for (int i = 0; i < keyArr.count; i ++)
//    {
//        id obj = [myDic objectForKey:keyArr[i]];
//        
//        obj = [self changeType:obj];
//        
//        [resDic setObject:obj forKey:keyArr[i]];
//    }
//    return resDic;
//}
//
////将NSDictionary中的Null类型的项目转化成@""
//-(NSArray *)nullArr:(NSArray *)myArr
//{
//    NSMutableArray *resArr = [[NSMutableArray alloc] init];
//    for (int i = 0; i < myArr.count; i ++)
//    {
//        id obj = myArr[i];
//        
//        obj = [self changeType:obj];
//        
//        [resArr addObject:obj];
//    }
//    return resArr;
//}
//
////将NSNumber类型转化NSString
//- (NSString *)numberToString : (NSNumber *)number
//{
//    return [NSString stringWithFormat:@"%@", number];
//}
//
////将NSString类型的原路返回
//-(NSString *)stringToString:(NSString *)string
//{
//    return string;
//}
//
////将Null类型的项目转化成@""
//-(NSString *)nullToString
//{
//    return @"";
//}
//
////类型识别:将所有的NSNull类型转化成@""
//-(id)changeType:(id)myObj
//{
//    if ([myObj isKindOfClass:[NSDictionary class]])
//    {
//        return [self nullDic:myObj];
//    }
//    else if([myObj isKindOfClass:[NSArray class]])
//    {
//        return [self nullArr:myObj];
//    }
//    else if([myObj isKindOfClass:[NSString class]])
//    {
//        if ([myObj isKindOfClass:[NSString class]]) {
//            if (([myObj compare:@"null" options:NSCaseInsensitiveSearch | NSNumericSearch] == NSOrderedSame) || ([myObj compare:@"nil" options:NSCaseInsensitiveSearch | NSNumericSearch] == NSOrderedSame)) {
//                return [self nullToString];
//            }
//        }
//        return [self stringToString:myObj];
//    }
//    else if([myObj isKindOfClass:[NSNull class]])
//    {
//        return [self nullToString];
//    }
//    else if([myObj isKindOfClass:[NSNumber class]]){
//        return [self numberToString:myObj];
//    }
//    else
//    {
//        return myObj;
//    }
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

