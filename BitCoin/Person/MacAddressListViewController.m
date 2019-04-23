//
//  MacAddressListViewController.m
//  BitCoin
//
//  Created by CCC on 2019/4/23.
//  Copyright © 2019年 LBH. All rights reserved.
//

#import "MacAddressListViewController.h"

@interface MacAddressListViewController () {
    NSArray *_dataArray;
    
}

@end

@implementation MacAddressListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self request];
}

- (void) request
{
    __weak __typeof(self) weakSelf = self;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    if (token.length) {
        NSDictionary *d = @{@"token":token};
        [[NetworkTool sharedTool] requestWithURLString:@"/v1/mall/product/order/getMacs" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
            NSLog(@"%@      ------------- %@", stringData, JSON );
            NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
            if ([code isEqualToString:@"1"]) {
                NSLog(@"");
                _dataArray = [NSArray arrayWithArray:[JSON objectForKey:@"data"]];
                [weakSelf.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            } else {
            }
        } failed:^(NSError *error) {
            
        }];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"macaddress" forIndexPath:indexPath];
    
    UILabel *mac = (UILabel *)[cell.contentView viewWithTag:1];
    mac.text = [NSString stringWithFormat:@"%@", [[_dataArray objectAtIndex:indexPath.row] objectForKey:@"mac"]];
    
    UILabel *use = (UILabel *)[cell.contentView viewWithTag:2];
    use.text = @"未使用";
    use.textColor = [UIColor colorWithRed:5/255.0 green:211/255.0 blue:184/255.0 alpha:1];
    if ([[NSString stringWithFormat:@"%@", [[_dataArray objectAtIndex:indexPath.row] objectForKey:@"mac"]] isEqualToString:@"1"]) {
        use.text = @"已使用";
        use.textColor = [UIColor groupTableViewBackgroundColor];
    }
    
    UIButton *btn = (UIButton *) [cell.contentView.subviews objectAtIndex:2];
    btn.tag = indexPath.row+10000;
    [btn addTarget:self action:@selector(copyClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _dataArray.count;
}

- (void) copyClick:(UIButton *)btn
{
    
}


- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
