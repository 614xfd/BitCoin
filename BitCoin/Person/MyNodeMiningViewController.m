//
//  MyNodeMiningViewController.m
//  BitCoin
//
//  Created by LBH on 2018/8/20.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "MyNodeMiningViewController.h"
#import "NodeMiningViewController.h"
#import "NodeParticularViewController.h"

@interface MyNodeMiningViewController () {
    NSDictionary *_dataDic;
}

@end

@implementation MyNodeMiningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (@available(iOS 11.0, *)) {
        [self.tableView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _dataDic = [NSDictionary dictionary];
    [self requestData];
    [self request];
}

- (void) creatView
{
    if([[_dataDic allKeys] containsObject:@"freezeSum"]) {
        self.freezeSumLabel.text = [NSString stringWithFormat:@"%.2lf", [[_dataDic objectForKey:@"freezeSum"] doubleValue]];
    }
    if([[_dataDic allKeys] containsObject:@"grandTotal"]) {
        self.grandTotalLabel.text = [NSString stringWithFormat:@"%.2lf", [[_dataDic objectForKey:@"grandTotal"] doubleValue]];
    }
    if([[_dataDic allKeys] containsObject:@"hashRateSum"]) {
        self.hashRateSumLabel.text = [NSString stringWithFormat:@"%.2lf", [[_dataDic objectForKey:@"hashRateSum"] doubleValue]];
    }
    if([[_dataDic allKeys] containsObject:@"reverydayRate"]) {
        self.reverydayRateLabel.text = [NSString stringWithFormat:@"%.2lf", [[_dataDic objectForKey:@"reverydayRate"] doubleValue]*100];
    }
    if([[_dataDic allKeys] containsObject:@"rveryday"]) {
        self.rverydayLabel.text = [NSString stringWithFormat:@"%.2lf", [[_dataDic objectForKey:@"rveryday"] doubleValue]];
    }
    if([[_dataDic allKeys] containsObject:@"unfreezeDay"]) {
        self.unfreezeDayLabel.text = [NSString stringWithFormat:@"%.2lf", [[_dataDic objectForKey:@"unfreezeDay"] doubleValue]];
    }
    if([[_dataDic allKeys] containsObject:@"unfreezeSum"]) {
        self.unfreezeSumLabel.text = [NSString stringWithFormat:@"%.2lf", [[_dataDic objectForKey:@"unfreezeSum"] doubleValue]];
    }
}

- (void) request
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uid = [defaults objectForKey:@"uid"];
    if (uid.length) {
        __weak __typeof(self) weakSelf = self;
        NSDictionary *d = @{@"uid":uid};
        [[NetworkTool sharedTool] requestWithURLString:@"node/findHashRateSource" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
            NSLog(@"%@      ------------- %@", stringData, JSON );
            NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
            if ([code isEqualToString:@"1"]) {
                self.dataArray = [NSArray arrayWithArray:[JSON objectForKey:@"Data"]];
                [weakSelf.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            } else {
                
            }
        } failed:^(NSError *error) {
            //        [weakSelf requestError];
        }];
    }
}

- (void) requestData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uid = [defaults objectForKey:@"uid"];
    if (uid.length) {
        __weak __typeof(self) weakSelf = self;
        NSDictionary *d = @{@"uid":uid};
        [[NetworkTool sharedTool] requestWithURLString:@"node/findAllData" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
            NSLog(@"%@      ------------- %@", stringData, JSON );
            NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
            if ([code isEqualToString:@"1"]) {
                _dataDic = [NSDictionary dictionaryWithDictionary:[JSON objectForKey:@"Data"]];
                [weakSelf performSelectorOnMainThread:@selector(creatView) withObject:nil waitUntilDone:YES];
            } else {
                
            }
        } failed:^(NSError *error) {
            //        [weakSelf requestError];
        }];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nodemining" forIndexPath:indexPath];
    
    UILabel *from = (UILabel *)[cell viewWithTag:1];
    from.text = [NSString stringWithFormat:@"%@", [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"source"]];

    UILabel *date = (UILabel *)[cell viewWithTag:2];
    date.text = [NSString stringWithFormat:@"%@", [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"addTime"]];

    UILabel *num = (UILabel *)[cell viewWithTag:3];
    num.text = [NSString stringWithFormat:@"+%.2lf", [[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"count"] doubleValue]];
    
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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50*kScaleH)];
    view.tag = 888;
    view.backgroundColor = [UIColor whiteColor];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 13*kScaleH, 23, 23)];
    imageView.image = [UIImage imageNamed:@"我的节点挖矿_07.png"];
    [view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.size.width+imageView.frame.origin.x+11, 0, 200, view.frame.size.height)];
    label.text = @"算力来源";
    label.font = [UIFont systemFontOfSize:18];
    [view addSubview:label];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, view.frame.size.height-1, self.view.frame.size.width, 1)];
    line.backgroundColor = [UIColor colorWithRed:220/255.0 green:221/255.0 blue:222/255.0 alpha:1];
    [view addSubview:line];
    
    [tvhf.contentView addSubview:view];
    return tvhf;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50*kScaleH;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    UIColor * color = [UIColor whiteColor];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > 372*kScaleH) {
        self.topBtn.hidden = NO;
    } else {
        self.topBtn.hidden = YES;
    }
        NSLog(@"%lf", offsetY);
    
}
- (IBAction)particularBtnClick:(id)sender
{    
    NodeParticularViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"NodeParticularVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)activateBtn:(id)sender {
    NodeMiningViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"NodeMiningVC"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)topBtnClick:(id)sender {
    NSIndexPath* indexPat = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPat atScrollPosition:UITableViewScrollPositionBottom animated:YES];
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
