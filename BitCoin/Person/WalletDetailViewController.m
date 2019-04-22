//
//  WalletDetailViewController.m
//  BitCoin
//
//  Created by mac on 2019/4/20.
//  Copyright © 2019 LBH. All rights reserved.
//

#import "WalletDetailViewController.h"

@interface WalletDetailViewController ()
@property (nonatomic, strong)NSMutableArray *dataList;

@end

@implementation WalletDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self requestQuery];
    self.tabView.delegate = self;
    self.tabView.dataSource = self;
}



- (void) requestQuery
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    if (token.length) {
        __weak __typeof(self) weakSelf = self;
        NSDictionary *d = @{@"token":token};
        [[NetworkTool sharedTool] requestWithURLString:@"/v1/user/account/detail/query" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
            NSLog(@"%@      ------------- %@", stringData, JSON );
            NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
            if ([code isEqualToString:@"1"]) {
                self.dataList = JSON[@"data"];
                [self.tabView reloadData];
            } else {
                
            }
        } failed:^(NSError *error) {
            //        [weakSelf requestError];
        }];
    }
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailCellId" forIndexPath:indexPath];

    NSDictionary *item = self.dataList[indexPath.row];
    UILabel *titleLab = [cell.contentView viewWithTag:100];
    titleLab.text = item[@"description"];
    
    UILabel *subLab = [cell.contentView viewWithTag:101];
    subLab.text = item[@"createTime"];
    
    UILabel *suffixLab = [cell.contentView viewWithTag:102];
    CGFloat amount = [item[@"amount"] floatValue];
    if (item[@"isIncome"]) {
        suffixLab.text = [NSString stringWithFormat:@"+%.2lfGTSE",amount];
        suffixLab.textColor = [UIColor colorWithRed:250/255.0 green:100/255.0 blue:121/255.0 alpha:1];
    }else{
        suffixLab.text = [NSString stringWithFormat:@"-%.2lfGTSE",amount];
//        suffixLab.textColor = [UIColor colorWithRed:250/255.0 green:100/255.0 blue:121/255.0 alpha:1];
        suffixLab.textColor = [UIColor greenColor];
    }
    
    
    return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
