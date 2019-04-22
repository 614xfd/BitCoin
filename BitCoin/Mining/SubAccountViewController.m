//
//  SubAccountViewController.m
//  BitCoin
//
//  Created by LBH on 2018/2/5.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "SubAccountViewController.h"
#import "PayRecordViewController.h"

@interface SubAccountViewController () {
    NSInteger _s;
    BOOL _isRequest;
    NSDictionary *_userApiState;
    NSDictionary *_userBalance;
    NSDictionary *_userHashrate;
    UILabel *_tipLabel;
    NSInteger _totals;
}

@end

@implementation SubAccountViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setBarBlackColor:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.userApiIdLabel.text = self.userApiId;
    _s = 0;
    _totals = 0;
    _isRequest = NO;
    self.dataArray = [NSMutableArray array];
    [self request];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    view.backgroundColor = [UIColor clearColor];
    
    _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    _tipLabel.text = @"加载中...";
    _tipLabel.textColor = [UIColor grayColor];
    _tipLabel.font = [UIFont systemFontOfSize:14];
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:_tipLabel];
    self.tableView.tableFooterView = view;
}

- (void) request
{
    _s++;
    if (_isRequest) {
        return;
    }
    __weak __typeof(self) weakSelf = self;
    NSDictionary *dic = @{@"phone":self.phone, @"userApiId":self.userApiId, @"coin":self.coin, @"page":[NSString stringWithFormat:@"%ld", _s]};
    _isRequest = YES;
    [[NetworkTool sharedTool] requestWithURLString:@"AntsPool/findAccount" parameters:dic method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ", JSON );
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            NSData *jsonData = [[[JSON objectForKey:@"Data"] objectForKey:@"userApiState"] dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            _userApiState = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&err];
            jsonData = [[[JSON objectForKey:@"Data"] objectForKey:@"userBalance"] dataUsingEncoding:NSUTF8StringEncoding];
            _userBalance = [NSJSONSerialization JSONObjectWithData:jsonData
                                                           options:NSJSONReadingMutableContainers
                                                             error:&err];
            jsonData = [[[JSON objectForKey:@"Data"] objectForKey:@"userHashrate"] dataUsingEncoding:NSUTF8StringEncoding];
            _userHashrate = [NSJSONSerialization JSONObjectWithData:jsonData
                                                              options:NSJSONReadingMutableContainers
                                                                error:&err];
            [weakSelf performSelectorOnMainThread:@selector(showMessage) withObject:nil waitUntilDone:YES];
            _totals = [[[_userApiState objectForKey:@"data"] objectForKey:@"totalRecord"] integerValue];
            NSArray *row = [[_userApiState objectForKey:@"data"] objectForKey:@"rows"];
            for (NSDictionary *d in row) {
                [self.dataArray addObject:d];
            }
            [weakSelf.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        } else {
            [weakSelf performSelectorOnMainThread:@selector(showToastWithMessage:) withObject:[JSON objectForKey:@"msg"] waitUntilDone:YES];
        }
        _isRequest = NO;
    } failed:^(NSError *error) {
        //        [weakSelf requestError];
    }];
}

- (void) showMessage
{
    self.earn24HoursLabel.text = [NSString stringWithFormat:@"%.2lf%@", [[[_userBalance objectForKey:@"data"] objectForKey:@"earn24Hours"] doubleValue], _coin];
    self.earnTotalLabel.text = [NSString stringWithFormat:@"%.2lf%@", [[[_userBalance objectForKey:@"data"] objectForKey:@"earnTotal"] doubleValue], _coin];
    self.paidOutLabel.text = [NSString stringWithFormat:@"%.2lf%@", [[[_userBalance objectForKey:@"data"] objectForKey:@"paidOut"] doubleValue], _coin];
    self.balanceLabel.text = [NSString stringWithFormat:@"%.2lf%@", [[[_userBalance objectForKey:@"data"] objectForKey:@"balance"] doubleValue], _coin];
    
    
    double m = [[[_userHashrate objectForKey:@"data"] objectForKey:@"last10m"] doubleValue];
    NSString *unitsM = @"";
    if (m > 1000) {
        m = m/1000;
        unitsM = @"G";
        if (m > 1000) {
            m = m/1000;
            unitsM = @"T";
            if (m > 1000) {
                m = m/1000;
                unitsM = @"P";
            }
        }
    }else if (m == 0) {
        unitsM = @"";
    } else {
        unitsM = @"M";
    }
    self.last10mLabel.text = [NSString stringWithFormat:@"%.2lf %@%@", m, unitsM, self.units];
    
    m = [[[_userHashrate objectForKey:@"data"] objectForKey:@"last30m"] doubleValue];
    if (m > 1000) {
        m = m/1000;
        unitsM = @"G";
        if (m > 1000) {
            m = m/1000;
            unitsM = @"T";
            if (m > 1000) {
                m = m/1000;
                unitsM = @"P";
            }
        }
    }else if (m == 0) {
        unitsM = @"";
    } else {
        unitsM = @"M";
    }
    self.last30mLabel.text = [NSString stringWithFormat:@"%.2lf %@%@", m, unitsM, self.units];
    
    m = [[[_userHashrate objectForKey:@"data"] objectForKey:@"last1h"] doubleValue];
    if (m > 1000) {
        m = m/1000;
        unitsM = @"G";
        if (m > 1000) {
            m = m/1000;
            unitsM = @"T";
            if (m > 1000) {
                m = m/1000;
                unitsM = @"P";
            }
        }
    }else if (m == 0) {
        unitsM = @"";
    } else {
        unitsM = @"M";
    }
    self.last1hLabel.text = [NSString stringWithFormat:@"%.2lf %@%@", m, unitsM, self.units];
    
    m = [[[_userHashrate objectForKey:@"data"] objectForKey:@"last1d"] doubleValue];
    if (m > 1000) {
        m = m/1000;
        unitsM = @"G";
        if (m > 1000) {
            m = m/1000;
            unitsM = @"T";
            if (m > 1000) {
                m = m/1000;
                unitsM = @"P";
            }
        }
    }else if (m == 0) {
        unitsM = @"";
    } else {
        unitsM = @"M";
    }
    self.last1dLabel.text = [NSString stringWithFormat:@"%.2lf %@%@", m, unitsM, self.units];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sub" forIndexPath:indexPath];
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:2];
    titleLabel.text = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"worker"];
    
    double m = [[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"last10m"] doubleValue];
    NSString *unitsM = @"";
    if (m > 1000) {
        m = m/1000;
        unitsM = @"G";
        if (m > 1000) {
            m = m/1000;
            unitsM = @"T";
            if (m > 1000) {
                m = m/1000;
                unitsM = @"P";
            }
        }
        titleLabel.textColor = [UIColor colorWithRed:39/255.0 green:114/255.0 blue:255/255.0 alpha:1];
    }else if (m == 0) {
        unitsM = @"";
        titleLabel.textColor = [UIColor colorWithRed:239/255.0 green:71/255.0 blue:58/255.0 alpha:1];
    } else {
        unitsM = @"M";
        titleLabel.textColor = [UIColor colorWithRed:39/255.0 green:114/255.0 blue:255/255.0 alpha:1];
    }
    UILabel *min_10 = (UILabel *)[cell viewWithTag:1];
    min_10.text = [NSString stringWithFormat:@"%.2lf %@%@", m, unitsM, self.units];
    
    m = [[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"last1d"] doubleValue];
    if (m > 1000) {
        m = m/1000;
        unitsM = @"G";
        if (m > 1000) {
            m = m/1000;
            unitsM = @"T";
            if (m > 1000) {
                m = m/1000;
                unitsM = @"P";
            }
        }
    }else if (m == 0) {
        unitsM = @"";
    } else {
        unitsM = @"M";
    }
    UILabel *day = (UILabel *)[cell viewWithTag:3];
    day.text = [NSString stringWithFormat:@"%.2lf %@%@每天算力", m, unitsM, self.units];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48*kScaleH;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* customView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 43*kScaleH)] ;
    customView.backgroundColor = [UIColor colorWithRed:245/255.0 green:246/255.0 blue:250/255.0 alpha:1];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 100, 43*kScaleH)];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.text = @"我的矿工";
    label.textColor = [UIColor colorWithRed:33/255.0 green:33/255.0 blue:33/255.0 alpha:1];
    [customView addSubview:label];
    
   
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, customView.frame.size.height-1, self.view.frame.size.width, 1)];
    line.backgroundColor = [UIColor colorWithRed:220/255.0 green:221/255.0 blue:222/255.0 alpha:1];
    [customView addSubview:line];
    return customView;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 43*kScaleH;
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.dataArray.count>0) {
        if (self.dataArray.count < _totals) {
            if (!_isRequest) {
                if (scrollView.contentOffset.y > scrollView.contentSize.height-scrollView.frame.size.height-400) {
                    [self request];
                } else {
                    //                NSLog(@"没进______%lf， contentSize______%lf",scrollView.contentOffset.y,scrollView.contentSize.height-scrollView.frame.size.height);
                }
            }
            
        } else {
            _tipLabel.text = @"已经是最后一页了。";
        }
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentSize.height>scrollView.frame.size.height) {
        if (!(scrollView.contentOffset.y > scrollView.contentSize.height-scrollView.frame.size.height+80)) {
            return;
        }
    } else {
        if (!(scrollView.contentOffset.y > 80)) {
            return;
        }
    }
    _tipLabel.text = @"已经是最后一页了。";
}


- (IBAction)check:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *phoneNum = [defaults objectForKey:@"phoneNum"];
    PayRecordViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"payRecordVC"];
    vc.phone = phoneNum;
    vc.userApiId = self.userApiId;
    vc.coin = self.coin;
    vc.units = self.units;
    [self.navigationController pushViewController:vc animated:YES];
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
