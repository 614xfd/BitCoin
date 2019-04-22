//
//  AddressManageViewController.m
//  BitCoin
//
//  Created by LBH on 2017/10/21.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import "AddressManageViewController.h"
#import "AddAddressViewController.h"

@interface AddressManageViewController () {
    NSString *_delPsthID;
}

@end

@implementation AddressManageViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestAddress];
    [self setBarBlackColor:YES];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
                [weakSelf rank];
                [weakSelf.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            } else{
            }
        } else {
            [weakSelf performSelectorOnMainThread:@selector(showToastWithMessage:) withObject:[JSON objectForKey:@"msg"] waitUntilDone:YES];
        }
    } failed:^(NSError *error) {
        //        [weakSelf requestError];
    }];
}


- (void) rank
{
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < self.dataArray.count; i++) {
        NSString *string = [NSString stringWithFormat:@"%@", [[self.dataArray objectAtIndex:i] objectForKey:@"state"]];
        if ([string isEqualToString:@"1"]) {
            [arr addObject:[self.dataArray objectAtIndex:i]];
            [self.dataArray removeObject:[self.dataArray objectAtIndex:i]];
        }
    }
    for (int i = 0; i < self.dataArray.count; i++) {
        [arr addObject:[self.dataArray objectAtIndex:i]];
    }
    [self.dataArray removeAllObjects];
    self.dataArray = [NSMutableArray arrayWithArray:arr];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addManager" forIndexPath:indexPath];
    
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:1];
    nameLabel.text = [[_dataArray objectAtIndex:indexPath.row] objectForKey:@"userName"];
    
    UILabel *phontLabel = (UILabel *)[cell viewWithTag:2];
    phontLabel.text = [[_dataArray objectAtIndex:indexPath.row] objectForKey:@"receiptPhone"];
    
    UILabel *addressLabel = (UILabel *)[cell viewWithTag:3];
    addressLabel.text = [[_dataArray objectAtIndex:indexPath.row] objectForKey:@"receivingAddress"];
    
    NSString *string = [NSString stringWithFormat:@"%@", [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"state"]];
    if ([string isEqualToString:@"1"]) {
        UIImageView *imageView = (UIImageView *)[cell viewWithTag:4];
        imageView.image = [UIImage imageNamed:@"商城-确认订单-06.png"];
        
        UILabel *mLabel = (UILabel *)[cell viewWithTag:5];
        mLabel.text = @"默认地址";
        mLabel.textColor = [UIColor colorWithRed:32/255.0 green:98/255.0 blue:230/255.0 alpha:1];
    }
    
    UIButton *btn1 = [cell.contentView.subviews objectAtIndex:6];
    btn1.tag = 100+indexPath.row;
    [btn1 addTarget:self action:@selector(setDefault:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn2 = [cell.contentView.subviews objectAtIndex:12];
    btn2.tag = 200+indexPath.row;
    [btn2 addTarget:self action:@selector(reSet:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn3 = [cell.contentView.subviews objectAtIndex:11];
    btn3.tag = 300+indexPath.row;
    [btn3 addTarget:self action:@selector(del:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}

- (void) requestDefault : (NSString *)pathID ReceivingAddress:(NSString *)ReceivingAddress receiptPhone:(NSString *)receiptPhone
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    __weak __typeof(self) weakSelf = self;
    NSDictionary *dic = @{@"token":token, @"id":pathID};
    [[NetworkTool sharedTool] requestWithURLString:@"v1/user/ra/setDefaultAddress" parameters:dic method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@", stringData, JSON );
        //        NSString *isError = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            //            [weakSelf verifyPass];
            [weakSelf performSelectorOnMainThread:@selector(requestAddress) withObject:nil waitUntilDone:YES];
        } else {
            [weakSelf performSelectorOnMainThread:@selector(showToastWithMessage:) withObject:[JSON objectForKey:@"msg"] waitUntilDone:YES];
        }
    } failed:^(NSError *error) {
        //        [weakSelf requestError];
    }];
}

- (void) setDefault : (UIButton *)btn
{
    NSString *pathID = [[self.dataArray objectAtIndex:btn.tag-100] objectForKey:@"id"];
    NSString *ReceivingAddress = [[self.dataArray objectAtIndex:btn.tag-100] objectForKey:@"receivingAddress"];
    NSString *receiptPhone = [[self.dataArray objectAtIndex:btn.tag-100] objectForKey:@"receiptPhone"];

    [self requestDefault:pathID ReceivingAddress:ReceivingAddress receiptPhone:receiptPhone];
}

- (void) reSet : (UIButton *)btn
{
    AddAddressViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddAddressVC"];
    vc.isReset = YES;
    vc.dic = [self.dataArray objectAtIndex:btn.tag-200];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) del : (UIButton *)btn
{
    _delPsthID = [[self.dataArray objectAtIndex:btn.tag-300] objectForKey:@"id"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"是否删除该地址？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *token = [defaults objectForKey:@"token"];
        __weak __typeof(self) weakSelf = self;
        NSDictionary *dic = @{@"token":token, @"id":_delPsthID};
        [self showToastWithMessage:@"正在删除"];
        [[NetworkTool sharedTool] requestWithURLString:@"v1/user/ra/delAddress" parameters:dic method:@"POST" completed:^(id JSON, NSString *stringData) {
            NSLog(@"%@      ------------- %@", stringData, JSON );
            //        NSString *isError = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
            NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
            if ([code isEqualToString:@"1"]) {
                //            [weakSelf verifyPass];
                [weakSelf showToastWithMessage:[JSON objectForKey:@"删除成功！"]];
                [weakSelf performSelectorOnMainThread:@selector(requestAddress) withObject:nil waitUntilDone:YES];
            } else {
                [weakSelf showToastWithMessage:[JSON objectForKey:@"msg"]];
            }
        } failed:^(NSError *error) {
            //        [weakSelf requestError];
        }];
    }
}

- (IBAction)addNewAddress:(id)sender {
}
- (IBAction)addAddressBtnClick:(id)sender {
    AddAddressViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddAddressVC"];
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
