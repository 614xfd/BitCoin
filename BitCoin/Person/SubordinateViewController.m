//
//  SubordinateViewController.m
//  BitCoin
//
//  Created by LBH on 2018/9/21.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "SubordinateViewController.h"

@interface SubordinateViewController ()

@end

@implementation SubordinateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self requestSubordinate];
}

- (void) setSuperior:(NSString *)string
{
    if (!string.length) {
        string = @"无";
    }
    self.superiorLabel.text = string;
    self.subordinateLabel.text = [NSString stringWithFormat:@"已邀请人数%ld", self.dataArray.count];
}

- (void) requestSubordinate
{
    __weak __typeof(self) weakSelf = self;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uid = [defaults objectForKey:@"uid"];
    if (uid.length) {
        NSDictionary *d = @{@"uid":uid};
        [[NetworkTool sharedTool] requestWithURLString:@"user/getInvitePeople" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
            NSLog(@"%@      ------------- %@", stringData, JSON );
            NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
            if ([code isEqualToString:@"1"]) {
                weakSelf.dataArray = [NSArray arrayWithArray:[[JSON objectForKey:@"Data"] objectForKey:@"subordinate"]];
                
                [weakSelf performSelectorOnMainThread:@selector(setSuperior:) withObject:[[[JSON objectForKey:@"Data"] objectForKey:@"superior"] objectAtIndex:0] waitUntilDone:YES];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"number" forIndexPath:indexPath];
    
    UILabel *num = (UILabel *)[cell viewWithTag:1];
    num.text = [NSString stringWithFormat:@"%@", [self numberSuitScanf:[self.dataArray objectAtIndex:indexPath.row]]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40*kScaleH;
}

- (IBAction)againBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSString *)numberSuitScanf:(NSString*)number
{
    if (number.length>10) {
        NSString *numberString = [number stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        return numberString;
    }
    return number;
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
