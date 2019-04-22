//
//  SelectAddressViewController.m
//  BitCoin
//
//  Created by LBH on 2017/10/21.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import "SelectAddressViewController.h"
#import "AddressManageViewController.h"

@interface SelectAddressViewController () {
    NSMutableArray *_dataArray;
}

@end

@implementation SelectAddressViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestAddress];
    [self setBarBlackColor:YES];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dataArray = [NSMutableArray array];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void) requestAddress
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    __weak __typeof(self) weakSelf = self;
    NSDictionary *dic = @{@"token":token};
    [[NetworkTool sharedTool] requestWithURLString:@"v1/user/ra/findAll" parameters:dic method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@", stringData, JSON );
        //        NSString *isError = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            //            [weakSelf verifyPass];
            NSArray *array = [JSON objectForKey:@"data"];
            _dataArray = [NSMutableArray arrayWithArray:array];
            if (_dataArray.count) {
                [weakSelf performSelectorOnMainThread:@selector(hiddenMessageImage) withObject:nil waitUntilDone:YES];
                [weakSelf.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            } else{
                [weakSelf performSelectorOnMainThread:@selector(showMessageImage) withObject:nil waitUntilDone:YES];
            }
        } else {
            [weakSelf performSelectorOnMainThread:@selector(showToastWithMessage:) withObject:[JSON objectForKey:@"msg"] waitUntilDone:YES];
        }
    } failed:^(NSError *error) {
        //        [weakSelf requestError];
    }];
}

- (void) showMessageImage
{
    self.tableView.hidden = YES;
}

- (void) hiddenMessageImage
{
    self.tableView.hidden = NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectaddview" forIndexPath:indexPath];
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:1];
    nameLabel.text = [[_dataArray objectAtIndex:indexPath.row] objectForKey:@"userName"];
    
    UILabel *phontLabel = (UILabel *)[cell viewWithTag:2];
    phontLabel.text = [[_dataArray objectAtIndex:indexPath.row] objectForKey:@"receiptPhone"];
    
    UILabel *addressLabel = (UILabel *)[cell viewWithTag:3];
    addressLabel.text = [[_dataArray objectAtIndex:indexPath.row] objectForKey:@"receivingAddress"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 86;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate returnAddressDic:[_dataArray objectAtIndex:indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)intoManage:(id)sender {
    AddressManageViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddressManageVC"];
    vc.dataArray = _dataArray;
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
