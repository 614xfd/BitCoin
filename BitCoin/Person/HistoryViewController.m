//
//  HistoryViewController.m
//  BitCoin
//
//  Created by LBH on 2018/5/22.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()

@end

@implementation HistoryViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setBarBlackColor:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self request];

}

- (void) hiddenLabel
{
    self.nullLabel.hidden = YES;
}

- (void) request
{
    __weak __typeof(self) weakSelf = self;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uid = [defaults objectForKey:@"uid"];
    NSDictionary *d = @{@"id":uid};
    [[NetworkTool sharedTool] requestWithURLString:@"UserAccount/TradingRecord" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@", stringData, JSON );
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            self.dataArray = [JSON objectForKey:@"Data"];
            [weakSelf.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            [weakSelf performSelectorOnMainThread:@selector(hiddenLabel) withObject:nil waitUntilDone:YES];
        } else {
            
        }
    } failed:^(NSError *error) {
        //        [weakSelf requestError];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    UILabel *type = (UILabel *) [cell viewWithTag:1];
    if ([[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"1"]) {
        type.text = [NSString stringWithFormat:@"转入%@", [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"coin_type"]];
    } else if ([[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"2"]) {
        type.text = [NSString stringWithFormat:@"转出%@", [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"coin_type"]];
    }
    UILabel *num = (UILabel *) [cell viewWithTag:2];
    if ([[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"recharge_sum"]) {
        num.text = [NSString stringWithFormat:@"%@", [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"recharge_sum"]];
    } else {
        num.text = [NSString stringWithFormat:@"统计中"];
    }
    UILabel *state = (UILabel *) [cell viewWithTag:3];
    if ([[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"state"] isEqualToString:@"0"]) {
        state.text = @"审核中";
    } else {
        state.text = @"已完成";
    }
    UILabel *time = (UILabel *) [cell viewWithTag:4];
    NSString *string = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"recharge_date"];
    NSMutableArray *array = [NSMutableArray arrayWithArray:[string componentsSeparatedByString:@":"]];
    [array removeLastObject];
    string = [array componentsJoinedByString:@":"];
    time.text = [NSString stringWithFormat:@"%@", string];

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
