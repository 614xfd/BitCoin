//
//  HoldMoneyViewController.m
//  BitCoin
//
//  Created by LBH on 2017/9/29.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import "HoldMoneyViewController.h"

@interface HoldMoneyViewController () {
    CGFloat _x;
    UIColor *_color;
    UIColor *_color2;
}

@end

@implementation HoldMoneyViewController

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
    [self request];
}

- (void) setMoney
{
    double s = 0, x = 0;
    for (int i = 0; i < self.dataArray.count; i++) {
        s+=[[[self.dataArray objectAtIndex:i] objectForKey:@"usdtAmount"] doubleValue];
        x+=[[[self.dataArray objectAtIndex:i] objectForKey:@"income"] doubleValue];
    }
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2lf", s];
    self.earningsLabel.text = [NSString stringWithFormat:@"预计总收益(ETH)%.2lf", x];
}

- (void) showImage
{
    self.bgImage.hidden = NO;
    self.tipLabel.hidden = NO;
}

- (void) hiddenImage
{
    self.bgImage.hidden = YES;
    self.tipLabel.hidden = YES;
}

- (void) request
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    __weak __typeof(self) weakSelf = self;
    NSDictionary *d = @{@"token":token};
    [[NetworkTool sharedTool] requestWithURLString:@"v1/financing/findUserFinancial" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@", stringData, JSON );
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            self.dataArray = [JSON objectForKey:@"Data"];
            [weakSelf performSelectorOnMainThread:@selector(setMoney) withObject:nil waitUntilDone:YES];
            if (self.dataArray.count) {
                [weakSelf performSelectorOnMainThread:@selector(hiddenImage) withObject:nil waitUntilDone:YES];
                [weakSelf.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            } else {
                [weakSelf performSelectorOnMainThread:@selector(showImage) withObject:nil waitUntilDone:YES];
            }
        } else {
            
        }
    } failed:^(NSError *error) {
        //        [weakSelf requestError];
    }];
    //    [[NetworkTool sharedTool] requestWithHPURLString:@"http://192.168.0.161/Bitboss/financing/findUserFinancial" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
    //        NSLog(@"%@      ------------- %@", stringData, JSON );
    //        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
    //        if ([code isEqualToString:@"1"]) {
    //            self.dataArray = [JSON objectForKey:@"Data"];
    //            [weakSelf performSelectorOnMainThread:@selector(setMoney) withObject:nil waitUntilDone:YES];
    //            if (self.dataArray.count) {
    //                [weakSelf performSelectorOnMainThread:@selector(hiddenImage) withObject:nil waitUntilDone:YES];
    //                [weakSelf.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    //            } else {
    //                [weakSelf performSelectorOnMainThread:@selector(showImage) withObject:nil waitUntilDone:YES];
    //            }
    //        } else {
    //
    //        }
    //    } failed:^(NSError *error) {
    //        //        [weakSelf requestError];
    //    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"holdmoneycell" forIndexPath:indexPath];
    UILabel *time = (UILabel *) [cell viewWithTag:1];
    NSString *string = [NSString stringWithFormat:@"%@", [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"type"]];
    if ([string isEqualToString:@"3"]) {
        time.text = @"三月期";
    } else if ([string isEqualToString:@"6"]) {
        time.text = @"六月期";
    } else if ([string isEqualToString:@"12"]) {
        time.text = @"一年期";
    }
    [time sizeToFit];
    
    UILabel *money = (UILabel *) [cell viewWithTag:2];
    double x = [[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"bbcamount"] doubleValue] + [[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"bbcShare"] doubleValue];
    string = [NSString stringWithFormat:@"%.2lf/%.2lf", [[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"usdtAmount"] doubleValue], x];
    money.text = string;
    
    UILabel *earnings = (UILabel *) [cell viewWithTag:3];
    earnings.text = [NSString stringWithFormat:@"+%.2lf", [[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"income"] doubleValue]];
    
    //    UILabel *day = (UILabel *) [cell viewWithTag:4];
    //    string = [[[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"time"] componentsSeparatedByString:@" "] firstObject];
    //    day.text = [NSString stringWithFormat:@"%@ 到期还本付息", string];
    UILabel *state = (UILabel *) [cell viewWithTag:5];
    string = [NSString stringWithFormat:@"%@", [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"orderStatus"]];
    if ([string isEqualToString:@"3"] || [string isEqualToString:@"2"]) {
        state.text = @"进行中";
        state.textColor = [UIColor colorWithRed:232/255.0 green:84/255.0 blue:30/255.0 alpha:1];
        string = [[[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"time"] componentsSeparatedByString:@" "] firstObject];
        UILabel *dayLabel = (UILabel *) [cell viewWithTag:6];
        dayLabel.frame = CGRectMake(time.frame.size.width+time.frame.origin.x+5, time.frame.origin.y+3, 150, 12);
        dayLabel.text = [NSString stringWithFormat:@"(%@到期)", string];
        [dayLabel sizeToFit];
    } else if ([string isEqualToString:@"4"]) {
        state.text = @"已到期";
        state.textColor = [UIColor colorWithRed:20/255.0 green:164/255.0 blue:152/255.0 alpha:1];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
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
