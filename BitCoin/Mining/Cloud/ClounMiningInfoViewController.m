//
//  ClounMiningInfoViewController.m
//  BitCoin
//
//  Created by LBH on 2018/9/21.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "ClounMiningInfoViewController.h"

@interface ClounMiningInfoViewController ()

@end

@implementation ClounMiningInfoViewController

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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uid = [defaults objectForKey:@"uid"];
    if (uid.length) {
        __weak __typeof(self) weakSelf = self;
        NSDictionary *d = @{@"uid":uid};
        [[NetworkTool sharedTool] requestWithURLString:@"cloundMill/yieldRecord" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
            NSLog(@"%@      ------------- %@", stringData, JSON );
            NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
            if ([code isEqualToString:@"1"]) {
                weakSelf.dataArray = [NSArray arrayWithArray:[JSON objectForKey:@"Data"]];
                [weakSelf.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
                [weakSelf performSelectorOnMainThread:@selector(hiddenLabel) withObject:nil waitUntilDone:YES];
            } else {
                
            }
        } failed:^(NSError *error) {
            //        [weakSelf requestError];
        }];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detail" forIndexPath:indexPath];
    
    UILabel *num = (UILabel *)[cell viewWithTag:1];
    UILabel *amount = (UILabel *)[cell viewWithTag:3];
    
    num.text = [NSString stringWithFormat:@"%@", [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"from"]];
    amount.text = [NSString stringWithFormat:@"+%@", [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"amount"]];
    UILabel *time = (UILabel *)[cell viewWithTag:2];
    time.text = [NSString stringWithFormat:@"%@", [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"transactionTime"]];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60*kScaleH;
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
