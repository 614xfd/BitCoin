//
//  BillViewController.m
//  BitCoin
//
//  Created by LBH on 2018/8/31.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "BillViewController.h"
#import "JLDatePickerView.h"
#import "HistoryRunViewController.h"
#import "NodeParticularViewController.h"
#import "HoldMoneyViewController.h"
#import "HistoryViewController.h"
#import "CoinInfoViewController.h"

@interface BillViewController () <JLDatePickerDelegate> {
    int _sum;
    int _page;
    NSMutableArray *_dataArray;
    NSMutableArray *_mArray;
    UILabel *_tipLabel;
    BOOL _isRequest;
    JLDatePickerView *_picker;
    NSString *_selectDate;
}

@end

@implementation BillViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setBarBlackColor:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (@available(iOS 11.0, *)) {
        [self.tableView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _dataArray = [NSMutableArray array];
    _mArray = [NSMutableArray array];
    _sum = 0;
    _page = 0;
    _isRequest = NO;
    _selectDate = @"";
    [self request];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44*kScaleH)];
    self.tableView.tableFooterView = view;

    _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    _tipLabel.text = @"加载中...";
    _tipLabel.font = [UIFont systemFontOfSize:14];
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    _tipLabel.textColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:136/255.0 alpha:1];
    [view addSubview:_tipLabel];

    _picker = [JLDatePickerView pickerViewWithType:JLDatePickerModeYearAndMonth];
    _picker.delegate = self;
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"YYYY-MM"];
    _picker.time = [formatter stringFromDate:[NSDate date]];
}

- (void) request
{
    _isRequest = YES;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uid = [defaults objectForKey:@"uid"];
    if (uid.length) {
        __weak __typeof(self) weakSelf = self;
        NSDictionary *d = @{@"uid":uid, @"time":_selectDate, @"page":[NSString stringWithFormat:@"%d", _page]};
        [[NetworkTool sharedTool] requestWithURLString:@"UserAccount/getuserBills" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
            NSLog(@"%@      ------------- %@", stringData, JSON );
            _isRequest = NO;
            NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
            if ([code isEqualToString:@"1"]) {
                _sum = [[[JSON objectForKey:@"Data"] objectForKey:@"totalPage"] intValue];
                NSArray *array = [NSArray arrayWithArray:[[JSON objectForKey:@"Data"] objectForKey:@"userBills"]];
                NSMutableArray *mArr = [NSMutableArray array];
                BOOL isSameArray = NO;
                if (_dataArray.count) {
                    mArr = [NSMutableArray arrayWithArray:[_dataArray lastObject]];
                    isSameArray = YES;
                }
                for (int i = 0; i < array.count; i++) {
                    NSString *string = [NSString stringWithFormat:@"%@-%@", [[[[array objectAtIndex:i] objectForKey:@"transactionTime"] componentsSeparatedByString:@"-"] firstObject], [[[[array objectAtIndex:i] objectForKey:@"transactionTime"] componentsSeparatedByString:@"-"] objectAtIndex:1]];
                    if (_mArray.count) {
                        if ([string isEqualToString:[_mArray lastObject]]) {
                            [mArr addObject:[array objectAtIndex:i]];
                            if (i == array.count-1) {
                                if (isSameArray) {
                                    [_dataArray replaceObjectAtIndex:_dataArray.count-1 withObject:[NSArray arrayWithArray:mArr]];
                                    isSameArray = NO;
                                } else {
                                    [_dataArray addObject:[NSArray arrayWithArray:mArr]];
                                }                            }
                        } else {
                            if (isSameArray) {
                                [_dataArray replaceObjectAtIndex:_dataArray.count-1 withObject:[NSArray arrayWithArray:mArr]];
                                isSameArray = NO;
                            } else {
                                [_dataArray addObject:[NSArray arrayWithArray:mArr]];
                            }
                            [mArr removeAllObjects];
                            [_mArray addObject:string];
                            [mArr addObject:[array objectAtIndex:i]];
                            if (i == array.count-1) {
                                [_dataArray addObject:mArr];
                            }
                        }
                    } else {
                        [_mArray addObject:string];
                        [mArr addObject:[array objectAtIndex:i]];
                    }
                }
//                NSLog(@"%@-0-0-0-0-0-0-0-0-%@", _mArray, _dataArray);
                [weakSelf.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            } else {
                
            }
        } failed:^(NSError *error) {
            //        [weakSelf requestError];
        }];
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bill" forIndexPath:indexPath];
    
    UIImageView *icon = (UIImageView *)[cell viewWithTag:1];
    

    UILabel *title = (UILabel *)[cell viewWithTag:2];
    title.text = [NSString stringWithFormat:@"%@", [[[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"description"]];

//    UILabel *num = (UILabel *)[cell viewWithTag:3];
//    num.text = [NSString stringWithFormat:@"+%.2lf", [[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"count"] doubleValue]];
    
    UILabel *time = (UILabel *)[cell viewWithTag:4];
    NSString *string = [[[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"transactionTime"];
    time.text = [NSString stringWithFormat:@"%@", [[[[string componentsSeparatedByString:@" "] firstObject] componentsSeparatedByString:@"-"] componentsJoinedByString:@"."]];
    
    UILabel *pirce = (UILabel *)[cell viewWithTag:5];
    string = [[[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"mark"];
    switch ([string intValue]) {
        case 1:
            //运动挖矿
            icon.image = [UIImage imageNamed:@"账单运动挖矿_03.png"];
            
            break;
        case 2:
            //每日理财收益
            icon.image = [UIImage imageNamed:@"账单_08.png"];
            
            break;
        case 3:
            //充币
            icon.image = [UIImage imageNamed:@"账单_03.png"];
            
            break;
        case 4:
            //提币
            icon.image = [UIImage imageNamed:@"账单_06.png"];
            
            break;
        case 5:
            //理财到期
            icon.image = [UIImage imageNamed:@"账单_08.png"];
            
            break;
        case 6:
            //分享所得
            icon.image = [UIImage imageNamed:@"账单+_03.png"];
            
            break;
        case 7:
            //节点收益
            icon.image = [UIImage imageNamed:@"账单_10.png"];

            break;
        case 8:
            //云矿机收益
            icon.image = [UIImage imageNamed:@"账单+_06.png"];

            break;
        case 9:
            //币用宝注册收益
            icon.image = [UIImage imageNamed:@"账单运动挖矿_03.png"];

            break;
        case 10:
            //激活节点
            icon.image = [UIImage imageNamed:@"账单_10.png"];

            break;
        case 11:
            //尚仙城积分兑换
            icon.image = [UIImage imageNamed:@"账单+_08.png"];

            break;
        case 12:
            //内部转入
            icon.image = [UIImage imageNamed:@"账单_14.png"];

            break;
        case 13:
            //内部转出
            icon.image = [UIImage imageNamed:@"账单_16.png"];

            break;
        case 14:
            //用户交易手续费
            icon.image = [UIImage imageNamed:@"内部转账手续费.png"];

            break;
            
        default:
            break;
    }
    if ([string isEqualToString:@"4"] || [string isEqualToString:@"10"] || [string isEqualToString:@"13"] || [string isEqualToString:@"14"] || [string isEqualToString:@"15"] || [string isEqualToString:@"17"] ) {
        string = @"-";
        pirce.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    } else {
        string = @"+";
        pirce.textColor = [UIColor colorWithRed:255/255.0 green:130/255.0 blue:8/255.0 alpha:1];
    }
    pirce.text = [NSString stringWithFormat:@"%@%.2lfBBC", string, [[[[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"amount"] doubleValue]];



    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_dataArray objectAtIndex:section] count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95*kScaleH;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *str = @"ID";
    
    UITableViewHeaderFooterView *tvhf = [tableView dequeueReusableHeaderFooterViewWithIdentifier:str];
    if (!tvhf) {
        tvhf = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:str];
    } else {
        for (UIView *view in tvhf.contentView.subviews) {
            if (view.tag == 888) {
                [view removeFromSuperview];
            }
        }
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 49*kScaleH)];
    view.tag = 888;
    view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, view.frame.size.height)];
    label.text = [_mArray objectAtIndex:section];
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [UIColor colorWithRed:54/255.0 green:54/255.0 blue:54/255.0 alpha:1];
    [view addSubview:label];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, view.frame.size.height-1, self.view.frame.size.width, 1)];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [view addSubview:line];
    
    [tvhf.contentView addSubview:view];
    return tvhf;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return _mArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 49*kScaleH;
}
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
        if (_page < _sum) {
            if (!_isRequest) {
                if (scrollView.contentOffset.y > scrollView.contentSize.height-scrollView.frame.size.height-400) {
                    _page++;
                    [self request];
                } else {
                    //                NSLog(@"没进______%lf， contentSize______%lf",scrollView.contentOffset.y,scrollView.contentSize.height-scrollView.frame.size.height);
                }
            }
            
        } else {
            if (_dataArray.count) {
                _tipLabel.text = @"已经是最后一页了。";
            } else {
                _tipLabel.text = @"暂无数据。";
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
    if (_dataArray.count) {
        _tipLabel.text = @"已经是最后一页了。";
    } else {
        _tipLabel.text = @"暂无数据。";
    }
}

- (IBAction)intoInfoVCBtnClick:(id)sender {
    [UIView animateWithDuration:0.3 animations:^ {
        self.BGBtn.alpha = 0.35;
        self.infoView.frame = CGRectMake(self.infoView.frame.origin.x, self.view.frame.size.height-self.infoView.frame.size.height, self.infoView.frame.size.width, self.infoView.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)BGBtnClick:(id)sender {
    [UIView animateWithDuration:0.3 animations:^ {
        self.BGBtn.alpha = 0;
        self.infoView.frame = CGRectMake(self.infoView.frame.origin.x, self.view.frame.size.height, self.infoView.frame.size.width, self.infoView.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)selectDateBtnClick:(id)sender {
    [_picker show];
}

- (void)JLDatePickerViewDidDismissWithConfirm:(JLDatePickerView *)pickerView string:(NSString *)string {
    if (pickerView.type == JLDatePickerModeYear || pickerView.type == JLDatePickerModeYearAndMonth || pickerView.type == JLDatePickerModeNomal) {
        _selectDate = string;
        _page = 0;
        [_dataArray removeAllObjects];
        [_mArray removeAllObjects];
        [self request];
    }
}
- (IBAction)run:(id)sender {
    HistoryRunViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HistoryRunVC"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)node:(id)sender {
    NodeParticularViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"NodeParticularVC"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)hold:(id)sender {
    HoldMoneyViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HoldMoneyVC"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)inOrOut:(id)sender {
    HistoryViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HistoryVC"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)getOrSend:(id)sender {
    CoinInfoViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CoinInfoVC"];
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
