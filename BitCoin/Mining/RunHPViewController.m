//
//  RunHPViewController.m
//  BitCoin
//
//  Created by LBH on 2018/7/7.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "RunHPViewController.h"
#import "Round.h"
#import "ServiceExplainViewController.h"
#import "HistoryRunViewController.h"
#import "LoginViewController.h"

@interface RunHPViewController () {
    BOOL _isCanUpData;
    BOOL _isBinding;
    NSString *_bluMac;
    NSString *_activationCode;
    NSArray *_dataArray;
    NSString *_date;
    bluetooth *_bluetooth;
    NSArray *_weakArray;
    Round *_round;
    BOOL _isCan;
    BOOL _isAlloc;
    NSArray *_macArray;
    MacListViewController *_macVC;
    BOOL _isLink;
    BOOL _isClick;
    BOOL _isShow;

}

@end

@implementation RunHPViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setBarBlackColor:NO];
    _macVC = nil;
    _macArray = @[];
    _isCanUpData = [self judgeTimeByStartAndEnd:@"00:00" withExpireTime:@"23:20"];
    if (_isCanUpData) {
        [self.upDataBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"运动挖矿首页-gold_23.png"]] forState:UIControlStateNormal];
    }
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *uid = [defaults objectForKey:@"uid"];
//    if (uid.length) {
//        [self stepNumber:0];
//    }
    [self openBlueTooth];
    [self setBluImageviewAndLabel];
    [self requestUser];
    _isClick = YES;
    if (_isLink) {
        [_bluetooth sendOrder];
    }
    _isShow = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (@available(iOS 11.0, *)) {
        [self.tableView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _dataArray = [NSArray array];
    _weakArray = [NSArray array];
    _isCan = NO;
    _isAlloc = NO;
    _isLink = NO;
    _isClick = YES;
    [self creatDate];
    [self creatDisk];
    
    NSDate *date =[NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:date];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    NSString *dateStr = [formatter stringFromDate:lastDay];
    
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self requestRankWithDate:[[dateStr componentsSeparatedByString:@" "] objectAtIndex:0]];
//    [self requestWithDate:@""];
    _isCanUpData = NO;
    _isBinding = NO;
    _bluMac = @"";

     UIFont *font = [UIFont fontWithName:@"Brandon Grotesque" size:33];
    self.stepLabel.font = font;
    self.calLabel.font = font;
    self.kmLabel.font = font;
    //查看healthKit在设备上是否可用，ipad不支持HealthKit
    if(![HKHealthStore isHealthDataAvailable])
    {
        NSLog(@"设备不支持healthKit");
    }
    
    //创建healthStore实例对象
    self.healthStore = [[HKHealthStore alloc] init];
    
    //设置需要获取的权限这里仅设置了步数
    HKObjectType *stepCount = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    NSSet *healthSet = [NSSet setWithObjects:stepCount, nil];
    
    //从健康应用中获取权限
    [self.healthStore requestAuthorizationToShareTypes:nil readTypes:healthSet completion:^(BOOL success, NSError * _Nullable error) {
        if (success)
        {
            NSLog(@"获取步数权限成功");
            //获取步数后我们调用获取步数的方法
            [self readStepCount];
        }
        else
        {
            NSLog(@"获取步数权限失败");
        }
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setMacListArray:)name:@"MAC_ARRAY" object:nil];

}

- (void) creatDate
{
    NSDate *date =[NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    NSString *dateStr = [formatter stringFromDate:date];
    [formatter setDateFormat:@"yyyy"];
    NSInteger currentYear=[[formatter stringFromDate:date] integerValue];
    [formatter setDateFormat:@"MM"];
    NSInteger currentMonth=[[formatter stringFromDate:date]integerValue];
    [formatter setDateFormat:@"dd"];
    NSInteger currentDay=[[formatter stringFromDate:date] integerValue];
    NSLog(@"currentDate = %@ ,year = %ld ,month=%ld, day=%ld",dateStr,currentYear,currentMonth,currentDay);
    _date = [[dateStr componentsSeparatedByString:@" "] objectAtIndex:0];
    self.dateLabel.text = [NSString stringWithFormat:@"%ld月%ld日", currentMonth, currentDay];
    self.todayLabel.text = [NSString stringWithFormat:@"%ld月%ld日 今天", currentMonth, currentDay];

    NSMutableArray *weakMArray = [NSMutableArray array];
    for (int i = 7; i > 0; i--) {
        NSDate *lastDay = [NSDate dateWithTimeInterval:-(24*60*60*(7-i)) sinceDate:date];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
        NSString *dateStr = [formatter stringFromDate:lastDay];
        NSLog(@"%@", dateStr);
        NSString *week = [self weekdayStringFromDate:lastDay];
        NSLog(@"%@", week);
        UILabel *label = (UILabel *)[self.view viewWithTag:i+10];
        label.text = week;
        UIButton *btn = (UIButton *)[self.view viewWithTag:i+20];
        [btn setTitle:[[[[dateStr componentsSeparatedByString:@" "] firstObject] componentsSeparatedByString:@"-"] lastObject] forState:UIControlStateNormal];
        
        [weakMArray addObject:[[dateStr componentsSeparatedByString:@" "] firstObject]];
    }
    NSEnumerator *enumerator = [weakMArray reverseObjectEnumerator];
    _weakArray = [enumerator allObjects];

}

- (void) creatDisk
{
    _round = [[Round alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 250)];
    
    [self.diskView addSubview:_round];
}

- (void) changeDisk : (NSString *)s
{
    _round.percent =  [s doubleValue] * 0.01;
}

- (void) showHistory : (NSDictionary *)dic
{
    self.stepLabel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"setps"]];
    self.calLabel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"cal"]];
    self.kmLabel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"kmcount"]];
}

- (void) setBluImageviewAndLabel
{
    if (_isBinding) {
        if (!_isLink) {
            self.bluImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", @"运动挖矿首页_18.png"]];
            self.bluStateLabel.textColor = [UIColor colorWithRed:177/255.0 green:178/255.0 blue:179/255.0 alpha:1];
            self.bluStateLabel.text = @"未连接";
            [self.bindingBtn setTitle:@"解绑" forState:UIControlStateNormal];
        } else {
            self.bluImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", @"运动挖矿首页-蓝牙金_18.png"]];
            self.bluStateLabel.textColor = [UIColor colorWithRed:193/255.0 green:169/255.0 blue:107/255.0 alpha:1];
            self.bluStateLabel.text = @"已连接";
        }
        [self openBlueTooth];
        
    } else {
        self.bluImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", @"运动挖矿首页_18.png"]];
        self.bluStateLabel.textColor = [UIColor colorWithRed:177/255.0 green:178/255.0 blue:179/255.0 alpha:1];
        self.bluStateLabel.text = @"未激活";
        [self.bindingBtn setTitle:@"绑定" forState:UIControlStateNormal];
    }
    

}

- (void) openBlueTooth
{
    if (_isAlloc) {
        [_bluetooth resetBluetooth:_bluMac];
        return;
    }
    _bluetooth = [[bluetooth alloc] initWithMac:_bluMac];
    _bluetooth.delegate = self;
    _isCan = YES;
    _isAlloc = YES;
}

- (void)readStepCount
{
    //查询采样信息
    HKSampleType *sampleType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    //NSSortDescriptor来告诉healthStore怎么样将结果排序
    NSSortDescriptor *start = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierStartDate ascending:NO];
    NSSortDescriptor *end = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierEndDate ascending:NO];
    //获取当前时间
    NSDate *now = [NSDate date];
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calender components:unitFlags fromDate:now];
    int hour = (int)[dateComponent hour];
    int minute = (int)[dateComponent minute];
    int second = (int)[dateComponent second];
    NSDate *nowDay = [NSDate dateWithTimeIntervalSinceNow:  - (hour*3600 + minute * 60 + second) ];
    //时间结果与想象中不同是因为它显示的是0区
    NSLog(@"今天%@",nowDay);
    NSDate *nextDay = [NSDate dateWithTimeIntervalSinceNow:  - (hour*3600 + minute * 60 + second)  + 86400];
    NSLog(@"明天%@",nextDay);
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:nowDay endDate:nextDay options:(HKQueryOptionNone)];
    
    /*查询的基类是HKQuery，这是一个抽象类，能够实现每一种查询目标，这里我们需要查询的步数是一个HKSample类所以对应的查询类是HKSampleQuery。下面的limit参数传1表示查询最近一条数据，查询多条数据只要设置limit的参数值就可以了*/
    
    HKSampleQuery *sampleQuery = [[HKSampleQuery alloc]initWithSampleType:sampleType predicate:predicate limit:0 sortDescriptors:@[start,end] resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
        //设置一个int型变量来作为步数统计
        int allStepCount = 0;
        for (int i = 0; i < results.count; i ++) {
            //把结果转换为字符串类型
            HKQuantitySample *result = results[i];
            HKQuantity *quantity = result.quantity;
            NSMutableString *stepCount = (NSMutableString *)quantity;
            NSString *stepStr =[ NSString stringWithFormat:@"%@",stepCount];
            //获取51 count此类字符串前面的数字
            NSString *str = [stepStr componentsSeparatedByString:@" "][0];
            int stepNum = [str intValue];
            NSLog(@"%d",stepNum);
            //把一天中所有时间段中的步数加到一起
            allStepCount = allStepCount + stepNum;
        }
        
        //查询要放在多线程中进行，如果要对UI进行刷新，要回到主线程
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *value = [defaults objectForKey:@"isLogin"];
            if (!_isBinding) {
                [self performSelectorOnMainThread:@selector(stepNumber1:) withObject:[NSString stringWithFormat:@"%d", allStepCount] waitUntilDone:YES];
            }
        }];
    }];
    //执行查询
    [self.healthStore executeQuery:sampleQuery];
}

- (void) requestRankWithDate : (NSString *)string;
{
    _dataArray = [NSArray array];
    __weak __typeof(self) weakSelf = self;
    NSDictionary *d = @{@"date":string};
    [[NetworkTool sharedTool] requestWithURLString:@"blue/dailyIncomeSort" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@", stringData, JSON );
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            _dataArray = [NSArray arrayWithArray:[JSON objectForKey:@"Data"]];
        }
        [weakSelf.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];

    } failed:^(NSError *error) {
        //        [weakSelf requestError];
    }];
}

- (void) requestUser
{
    __weak __typeof(self) weakSelf = self;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uid = [defaults objectForKey:@"uid"];
    
    if (uid.length) {
        NSDictionary *d = @{@"uid":uid};
        [[NetworkTool sharedTool] requestWithURLString:@"blue/checkUserBlue" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
            NSLog(@"%@      ------------- %@", stringData, JSON );
            NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
            if ([code isEqualToString:@"1"]) {
                _bluMac = [NSString stringWithFormat:@"%@",[[[JSON objectForKey:@"Data"] componentsSeparatedByString:@":"]componentsJoinedByString:@""]];
                _isBinding = YES;
                [weakSelf performSelectorOnMainThread:@selector(setBluImageviewAndLabel) withObject:nil waitUntilDone:YES];
            } else {
                [weakSelf performSelectorOnMainThread:@selector(openBlueTooth) withObject:nil waitUntilDone:YES];
                _isBinding = NO;
            }
        } failed:^(NSError *error) {
            //        [weakSelf requestError];
        }];
    } else {
        
    }
}

- (void) requestWithDate : (NSString *) date
{
    __weak __typeof(self) weakSelf = self;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uid = [defaults objectForKey:@"uid"];
    
    if (uid.length) {
        NSDictionary *d = @{@"uid":uid, @"date":date};
        [[NetworkTool sharedTool] requestWithURLString:@"blue/getUserIncome" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
            NSLog(@"%@      ------------- %@", stringData, JSON );
            NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
            if ([code isEqualToString:@"1"]) {
                [weakSelf performSelectorOnMainThread:@selector(changeDisk:) withObject:[[[JSON objectForKey:@"Data"] objectForKey:@"history"] objectForKey:@"inCome"] waitUntilDone:YES];
                [weakSelf performSelectorOnMainThread:@selector(showHistory:) withObject:[[JSON objectForKey:@"Data"] objectForKey:@"history"] waitUntilDone:YES];
            } else {
                
            }
        } failed:^(NSError *error) {
            //        [weakSelf requestError];
        }];
    } else {
        
    }
}

- (void) requestWithData : (NSString *) data
{
    __weak __typeof(self) weakSelf = self;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uid = [defaults objectForKey:@"uid"];
    
    if (uid.length && [self.stepLabel.text doubleValue] > 0) {
        NSString *t = @"0";
        if (_isBinding) {
            t = @"1";
        }
        NSDictionary *d = @{@"uid":uid, @"kmCount":self.kmLabel.text, @"type":t, @"steps":self.stepLabel.text, @"cal":self.calLabel.text};
        [[NetworkTool sharedTool] requestWithURLString:@"blue/calcInCome" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
            NSLog(@"%@      ------------- %@", stringData, JSON );
            [weakSelf performSelectorOnMainThread:@selector(showToastWithMessage:) withObject:[JSON objectForKey:@"msg"] waitUntilDone:YES];
        } failed:^(NSError *error) {
            //        [weakSelf requestError];
        }];
    } else {
        
    }
}

- (void) requestRelieve:(NSString *)code
{
    __weak __typeof(self) weakSelf = self;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uid = [defaults objectForKey:@"uid"];

    if (uid.length) {
        NSDictionary *d = @{@"uid":uid, @"code":code};
        [[NetworkTool sharedTool] requestWithURLString:@"blue/unbind" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
            NSLog(@"%@      ------------- %@", stringData, JSON );
            [weakSelf performSelectorOnMainThread:@selector(showToastWithMessage:) withObject:[JSON objectForKey:@"msg"] waitUntilDone:YES];
            [weakSelf performSelectorOnMainThread:@selector(requestUser) withObject:nil waitUntilDone:YES];
        } failed:^(NSError *error) {
            //        [weakSelf requestError];
        }];
    } else {

    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"run" forIndexPath:indexPath];
    
    UILabel *num = (UILabel *)[cell viewWithTag:1];
    UIImageView *image = (UIImageView *)[cell viewWithTag:2];

    if (indexPath.row<3) {
        NSArray *array = @[@"运动挖矿首页_27.png", @"运动挖矿首页_30.png", @"运动挖矿首页_32.png"];
        image.image = [UIImage imageNamed:[array objectAtIndex:indexPath.row]];
        image.hidden = NO;
        
        num.hidden = YES;
    } else {
        image.hidden = YES;
        num.hidden = NO;
    }
    num.text = [NSString stringWithFormat:@"%ld", indexPath.row+1];

    UILabel *phone = (UILabel *)[cell viewWithTag:3];
    phone.text = [NSString stringWithFormat:@"%@", [self numberSuitScanf:[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"phone"]]];

    UILabel *incomeCount = (UILabel *)[cell viewWithTag:4];
    incomeCount.text = [NSString stringWithFormat:@"%.2lf", [[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"incomeCount"] doubleValue]];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68*kScaleH;
}

- (void) stepNumber:(int)num
{
    self.stepLabel.text = [NSString stringWithFormat:@"%d", num];
    self.calLabel.text = [NSString stringWithFormat:@"%.2lf", num*0.03];
    self.kmLabel.text = [NSString stringWithFormat:@"%.2lf", num*0.785/1000];
    if (_isClick) {
        [self showToastWithMessage:@"蓝牙数据同步完成"];
        _isClick = NO;
    }
}

- (void) linkSuccess
{
    self.bluImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", @"运动挖矿首页-蓝牙金_18.png"]];
    self.bluStateLabel.textColor = [UIColor colorWithRed:193/255.0 green:169/255.0 blue:107/255.0 alpha:1];
    self.bluStateLabel.text = @"已连接";
    _isLink = YES;
    [self showToastWithMessage:@"蓝牙设备已连接"];
}

- (void) linkOut
{
//    _isLink = NO;
//    [self setBluImageviewAndLabel];
//    [self showToastWithMessage:@"蓝牙设备已断开连接"];
}

- (void) stepNumber1:(NSString *)num
{
    self.stepLabel.text = [NSString stringWithFormat:@"%@", num];
    self.calLabel.text = [NSString stringWithFormat:@"%.2lf", [num doubleValue]*0.03/1000];
    self.kmLabel.text = [NSString stringWithFormat:@"%.2lf", [num doubleValue]*0.785/1000];
}

- (IBAction)historyBtnClick:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *value = [defaults objectForKey:@"isLogin"];
    if ([value isEqualToString:@"YES"]) {
        HistoryRunViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HistoryRunVC"];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        LoginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void) verifySuccessWithCode:(NSString *)code
{
    [self requestRelieve:code];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *phoneNum = [defaults objectForKey:@"phoneNum"];
        CaptchaViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CaptchaVC"];
        vc.phoneNum = [NSString stringWithFormat:@"+86 %@", phoneNum];
        vc.phone = phoneNum;
        vc.delegate = self;
        vc.isRun = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)bindingBtnClick:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *value = [defaults objectForKey:@"isLogin"];
    if ([value isEqualToString:@"YES"]) {
        if (_isBinding) {
            UIButton *b = (UIButton *)sender;
            NSInteger x = b.tag;
            if (x == 100) {
                if (!_isLink) {
                    [self showToastWithMessage:@"搜索蓝牙设备中，请确定蓝牙设备已打开且未被其他设备连接"];
                } else {
                    [self showToastWithMessage:@"蓝牙数据同步中"];
                    _isClick = YES;
                    [_bluetooth sendOrder];
                }
                return;
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"解绑后需重新购买激活码激活设备，请谨慎操作" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        } else {
            _macVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MacListVC"];
            _macVC.dataArray = _macArray;
            _macVC.delegate = self;
            [self.navigationController pushViewController:_macVC animated:YES];
            [self openBlueTooth];
        }
    } else {
        LoginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)showDateBtnClick:(id)sender {
//    self.dateBGView.hidden = NO;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    self.dateBGBtn.hidden = NO;
    self.dateBGView.frame = CGRectMake(self.dateBGView.frame.origin.x, 0, self.dateBGView.frame.size.width, self.dateBGView.frame.size.height);
    [UIView commitAnimations];
}
- (IBAction)hiddenDateBtnClick:(id)sender {
//    self.dateBGView.hidden = YES;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    self.dateBGBtn.hidden = YES;
    self.dateBGView.frame = CGRectMake(self.dateBGView.frame.origin.x, -self.dateBGView.frame.size.height-1, self.dateBGView.frame.size.width, self.dateBGView.frame.size.height);
    [UIView commitAnimations];
}

- (IBAction)upDataBtnClick:(id)sender {
    if (_isCanUpData) {
        NSLog(@"yes");
        [self requestWithData:@"1.25"];
    } else {
        NSLog(@"no");
    }
}
- (IBAction)howBtnClick:(id)sender {
    ServiceExplainViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ServiceExplainVC"];
    vc.UrlString = [NSString stringWithFormat:@"%@%@", REQUEST_URL_STRING,@"mine_introduce.html"];
    vc.titleStr = @"如何提高收益";
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)changeDay:(id)sender {
    NSString *day = [_weakArray objectAtIndex:[sender tag]-20-1];
    NSArray *array = [day componentsSeparatedByString:@"-"];
    self.dateLabel.text = [NSString stringWithFormat:@"%d月%d日", [[array objectAtIndex:1] intValue], [[array objectAtIndex:2] intValue]];
    self.todayLabel.text = [NSString stringWithFormat:@"%d月%d日", [[array objectAtIndex:1] intValue], [[array objectAtIndex:2] intValue]];

    for (int i = 1; i < 8; i++) {
        UILabel *label = (UILabel *)[self.view viewWithTag:i+10];
        label.textColor = [UIColor colorWithRed:87/255.0 green:87/255.0 blue:87/255.0 alpha:1];
        UIButton *btn = (UIButton *)[self.view viewWithTag:i+20];
        [btn setTitleColor:[UIColor colorWithRed:87/255.0 green:87/255.0 blue:87/255.0 alpha:1] forState:UIControlStateNormal];
        if (i == [sender tag]-20) {
            label.textColor = [UIColor colorWithRed:193/255.0 green:169/255.0 blue:107/255.0 alpha:1];
            [btn setTitleColor:[UIColor colorWithRed:193/255.0 green:169/255.0 blue:107/255.0 alpha:1] forState:UIControlStateNormal];
        }
    }
    if ([sender tag]-20-1 == 6) {
        [self requestRankWithDate:[_weakArray objectAtIndex:[sender tag]-20-2]];
        self.diskView.hidden = YES;
        self.runImageView.hidden = NO;
        self.runLabel.hidden = NO;
        self.upDataBtn.hidden = NO;
        self.bluImageView.hidden = NO;
        self.bluStateLabel.hidden = NO;
        self.bluBtn.hidden = NO;
        self.rankLabel.text = @"收益排行(昨日)";
        self.todayLabel.text = [NSString stringWithFormat:@"%d月%d日 今天", [[array objectAtIndex:1] intValue], [[array objectAtIndex:2] intValue]];

    } else {
        [self requestWithDate:day];
        [self requestRankWithDate:day];
        self.diskView.hidden = NO;
        self.runImageView.hidden = YES;
        self.runLabel.hidden = YES;
        self.upDataBtn.hidden = YES;
        self.bluImageView.hidden = YES;
        self.bluStateLabel.hidden = YES;
        self.bluBtn.hidden = YES;
        self.rankLabel.text = @"收益排行(日)";
    }
    self.lineImageView.frame = CGRectMake((([sender tag]-20-1)*53+9)*kScaleH, self.lineImageView.frame.origin.y, self.lineImageView.frame.size.width, self.lineImageView.frame.size.height);
    [self hiddenDateBtnClick:nil];
}

- (IBAction)helpBtnClick:(id)sender {
    ServiceExplainViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ServiceExplainVC"];
    vc.UrlString = [NSString stringWithFormat:@"%@%@", REQUEST_URL_STRING,@"bind_bluetooth_intro.html"];
    vc.titleStr = @"帮助";
    [self presentViewController:vc animated:YES completion:nil];
}

- (void) setMacListArray : (NSNotification *)dic
{
    NSLog(@"%@", dic.object);
    _macArray = [NSArray arrayWithArray:dic.object];
    [_macVC reSetMacArray:_macArray];
}

- (NSString *) changeMac : (NSString *)string
{
    NSString *doneTitle = @"";
    for (int i = 0, count = 0; i < string.length; i++) {
        count++;
        doneTitle = [doneTitle stringByAppendingString:[string substringWithRange:NSMakeRange(i, 1)]];
        if (count == 2 && i<string.length-1) {
            doneTitle = [NSString stringWithFormat:@"%@:", doneTitle];
            count = 0;
        }
    }
    return doneTitle;
}

-(NSString *)numberSuitScanf:(NSString*)number
{
    if (number.length>10) {
        NSString *numberString = [number stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        return numberString;
    }
    return number;
}

//当前时间是否在时间段内 (忽略年月日)
- (BOOL)judgeTimeByStartAndEnd:(NSString *)startTime withExpireTime:(NSString *)expireTime {
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    // 时间格式,此处遇到过坑,建议时间HH大写,手机24小时进制和12小时禁止都可以完美格式化
    [dateFormat setDateFormat:@"HH:mm"];
    NSString * todayStr=[dateFormat stringFromDate:today];//将日期转换成字符串
    today=[ dateFormat dateFromString:todayStr];//转换成NSDate类型。日期置为方法默认日期
    //startTime格式为 02:22   expireTime格式为 12:44
    NSDate *start = [dateFormat dateFromString:startTime];
    NSDate *expire = [dateFormat dateFromString:expireTime];
    
    if ([today compare:start] == NSOrderedDescending && [today compare:expire] == NSOrderedAscending) {
        return YES;
    }
    return NO;
}

-(NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/SuZhou"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
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
