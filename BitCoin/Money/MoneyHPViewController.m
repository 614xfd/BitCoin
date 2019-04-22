//
//  MoneyHPViewController.m
//  BitCoin
//
//  Created by LBH on 2017/9/29.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import "MoneyHPViewController.h"
#import "MoneyInfoViewController.h"

@interface MoneyHPViewController () {
    NSArray *_titleArray;
    NSArray *_numArray;
    NSArray *_dayArray;
}

@end

@implementation MoneyHPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    _titleArray = @[@"三月期理财 | Bitboss", @"六月期理财 | Bitboss", @"一年期理财 | Bitboss"];
    _numArray = @[@"4.60%", @"6.99%", @"11.11%"];
    _dayArray = @[@"90天", @"180天", @"365"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"money" forIndexPath:indexPath];
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:10];
    titleLabel.text = [_titleArray objectAtIndex:indexPath.row];
    
    UILabel *numLabel = (UILabel *)[cell viewWithTag:11];
    numLabel.text = [_numArray objectAtIndex:indexPath.row];
    UILabel *dayLabel = (UILabel *)[cell viewWithTag:12];
    dayLabel.text = [_dayArray objectAtIndex:indexPath.row];

    
    
    UILabel *line = (UILabel *)[cell viewWithTag:13];
    [line.layer setMasksToBounds:YES];
    line.layer.cornerRadius = 2;
    [line.layer setBorderWidth:0.5];
    [line.layer setBorderColor:[UIColor colorWithRed:140/255.0 green:140/255.0 blue:140/255.0 alpha:1].CGColor];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 144;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MoneyInfoViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MoneyInfoVC"];
    [self.navigationController pushViewController:vc animated:YES];
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
