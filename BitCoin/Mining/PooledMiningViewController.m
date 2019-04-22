//
//  PooledMiningViewController.m
//  BitCoin
//
//  Created by LBH on 2018/2/5.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "PooledMiningViewController.h"
#import "SubAccountViewController.h"

@interface PooledMiningViewController () {
    double _min;
    double _day;
    double _hour;
    double _balance;
    NSString *_unitsM;
    NSString *_unitsD;
    NSString *_unitsH;
    NSString *_units;
    NSString *_coin;
}

@end

@implementation PooledMiningViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setBarBlackColor:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self requestWithCoin:@""];
    self.tableView.tableFooterView = [UIView new];
    
    [self.bgView.layer setMasksToBounds:YES];
    self.bgView.layer.cornerRadius = 4;
    
    [self.changeCoinTableView.layer setMasksToBounds:YES];
    self.changeCoinTableView.layer.cornerRadius = 4;
    
    [self.cancleBtn.layer setMasksToBounds:YES];
    self.cancleBtn.layer.cornerRadius = 4;
}

- (void) showEarnings
{
    self.minLabel.text = [NSString stringWithFormat:@"%.2lf %@%@", _min, _unitsM, _units];
    self.dayLabel.text = [NSString stringWithFormat:@"%.2lf %@%@", _day, _unitsD, _units];
    self.hourLabel.text = [NSString stringWithFormat:@"%.2lf %@%@", _hour, _unitsD, _units];
    self.coinLabel.text = [NSString stringWithFormat:@"%.4lf %@", _balance, _coin];
}

- (void) showActivity
{
    self.activityView.hidden = NO;
}

- (void) hiddenActivity
{
    self.activityView.hidden = YES;
}

- (void) requestWithCoin:(NSString *)coin
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *phoneNum = [defaults objectForKey:@"phoneNum"];
    __weak __typeof(self) weakSelf = self;
    NSLog(@"al;sdfjl;asdjfasdf");
    NSDictionary *dic;
    if (coin.length) {
        dic = @{@"phone":phoneNum, @"coin":coin};
        _coin = coin;
    } else {
        dic = @{@"phone":phoneNum};
        _coin = @"";
    }
    _min = 0;
    _day = 0;
    _hour = 0;
    _balance = 0;
    _unitsM = @"";
    _unitsD = @"";
    _unitsH = @"";
    _units = @"";
    [self showActivity];
    [[NetworkTool sharedTool] requestWithURLString:@"AntsPool/finduserPool" parameters:dic method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ", JSON );
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            NSDictionary *d = [JSON objectForKey:@"Data"];
            self.dataArray = [d objectForKey:@"user"];
            for (int i = 0; i < self.dataArray.count; i++) {
                double d = [[[self.dataArray objectAtIndex:i] objectForKey:@"last1d"] doubleValue];
                double m = [[[self.dataArray objectAtIndex:i] objectForKey:@"last10m"] doubleValue];
                double h = [[[self.dataArray objectAtIndex:i] objectForKey:@"last1h"] doubleValue];
                double b = [[[self.dataArray objectAtIndex:i] objectForKey:@"balance"] doubleValue];
                _min = _min + m;
                _day = _day + d;
                _hour = _hour +h;
                _balance = _balance+b;
            }
            if (_min > 1000) {
                _min = _min/1000;
                _unitsM = @"G";
                if (_min > 1000) {
                    _min = _min/1000;
                    _unitsM = @"T";
                    if (_min > 1000) {
                        _min = _min/1000;
                        _unitsM = @"P";
                    }
                }
            } else {
                _unitsM = @"M";
            }
            if (_day > 1000) {
                _day = _day/1000;
                _unitsD = @"G";
                if (_day > 1000) {
                    _day = _day/1000;
                    _unitsD = @"T";
                    if (_day > 1000) {
                        _day = _day/1000;
                        _unitsD = @"P";
                    }
                }
            } else {
                _unitsD = @"M";
            }
            if (_hour > 1000) {
                _hour = _hour/1000;
                _unitsH = @"G";
                if (_hour > 1000) {
                    _hour = _hour/1000;
                    _unitsH = @"T";
                    if (_hour > 1000) {
                        _hour = _hour/1000;
                        _unitsH = @"P";
                    }
                }
            } else {
                _unitsH = @"M";
            }
            weakSelf.coinArray = [d objectForKey:@"findCoin"];
            if (!_coin.length) {
                _coin = [d objectForKey:@"coin"];
            }
            for (int i = 0; i < weakSelf.coinArray.count; i++) {
                NSString *s = [[weakSelf.coinArray objectAtIndex:i] objectForKey:@"coin"];
                if ([s isEqualToString:_coin]) {
                    _units = [[weakSelf.coinArray objectAtIndex:i] objectForKey:@"unit"];
                }
            }
            [weakSelf showEarnings];
            [weakSelf.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            [weakSelf.changeCoinTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            NSLog(@"lasjdfljasdlf");
        } else {
            [weakSelf performSelectorOnMainThread:@selector(showToastWithMessage:) withObject:[JSON objectForKey:@"msg"] waitUntilDone:YES];
        }
        [weakSelf performSelectorOnMainThread:@selector(hiddenActivity) withObject:nil waitUntilDone:YES];
    } failed:^(NSError *error) {
        //        [weakSelf requestError];
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (tableView == self.tableView) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"pool" forIndexPath:indexPath];
        
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:1];
        titleLabel.text = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"userApiId"];
        
        UILabel *min = (UILabel *)[cell viewWithTag:2];
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
        }else if (m == 0) {
            unitsM = @"";
        } else {
            unitsM = @"M";
        }
        min.text = [NSString stringWithFormat:@"%.2lf %@%@", m, unitsM, _units];
        
        UILabel *hour = (UILabel *)[cell viewWithTag:3];
        double s = [[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"earn24Hours"] doubleValue];
        hour.text = [NSString stringWithFormat:@"%.6lf %@", s, _coin];
        
        UILabel *num = (UILabel *)[cell viewWithTag:4];
        num.text = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"number"];
    } else if (tableView == self.changeCoinTableView) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"change" forIndexPath:indexPath];
        
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:10];
        titleLabel.text = [[self.coinArray objectAtIndex:indexPath.row] objectForKey:@"coin"];
    }
    


    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.changeCoinTableView) {
        return self.coinArray.count;
    }
    return self.dataArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.changeCoinTableView) {
        return 44*kScaleH;
    }
    return 50*kScaleH;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.changeCoinTableView) {
        return 1;
    }
    return 1;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self.changeCoinTableView) {
        return nil;
    }
    UIView* customView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 78*kScaleH)] ;
    customView.backgroundColor = [UIColor colorWithRed:245/255.0 green:246/255.0 blue:250/255.0 alpha:1];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 100, 40*kScaleH)];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.text = @"子账户";
    label.textColor = [UIColor colorWithRed:33/255.0 green:33/255.0 blue:33/255.0 alpha:1];
    [customView addSubview:label];
    
    UILabel *bgLab = [[UILabel alloc] initWithFrame:CGRectMake(0, label.frame.size.height, self.view.frame.size.width, customView.frame.size.height-label.frame.size.height)];
    bgLab.backgroundColor = [UIColor whiteColor];
    [customView addSubview:bgLab];

    NSArray *array = @[@"    算力", @"24小时收益", @"矿机数    ",];
    for (int i = 0; i < array.count; i++) {
        
        UILabel *lab  = [[UILabel alloc] initWithFrame:CGRectMake(0+self.view.frame.size.width/3*i, label.frame.size.height, self.view.frame.size.width/3, customView.frame.size.height-label.frame.size.height)];
        lab.text  = [array objectAtIndex:i];
        lab.textColor = [UIColor blackColor];
        lab.font = [UIFont boldSystemFontOfSize:14];
        if (i == 0) {
            lab.textAlignment = NSTextAlignmentLeft;
        } else if (i == 1) {
            lab.textAlignment = NSTextAlignmentCenter;
        } else if (i == 2) {
            lab.textAlignment = NSTextAlignmentCenter;
        }
        [customView addSubview:lab];
    }
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, customView.frame.size.height-1, self.view.frame.size.width, 1)];
    line.backgroundColor = [UIColor colorWithRed:220/255.0 green:221/255.0 blue:222/255.0 alpha:1];
    [customView addSubview:line];
    return customView;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.changeCoinTableView) {
        return 0;
    }
    return 78*kScaleH;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *phoneNum = [defaults objectForKey:@"phoneNum"];
        SubAccountViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SubAccountVC"];
        vc.phone = phoneNum;
        vc.userApiId = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"userApiId"];
        vc.coin = _coin;
        vc.units = _units;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (tableView == self.changeCoinTableView) {
        [self requestWithCoin:[[self.coinArray objectAtIndex:indexPath.row] objectForKey:@"coin"]];
        [self cancleSelect:nil];
    }

}

- (IBAction)change:(id)sender {
    self.bgLabel.hidden = NO;
    self.bgView.hidden = NO;
}

- (IBAction)cancleSelect:(id)sender {
    self.bgLabel.hidden = YES;
    self.bgView.hidden = YES;
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
