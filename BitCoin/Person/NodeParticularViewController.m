//
//  NodeParticularViewController.m
//  BitCoin
//
//  Created by LBH on 2018/8/28.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "NodeParticularViewController.h"

@interface NodeParticularViewController () {
    BOOL _isShow;
    NSArray *_allArray;
    NSMutableArray *_freezeArray;
    NSMutableArray *_unfreezeArray;
}

@end

@implementation NodeParticularViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setBarBlackColor:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (@available(iOS 11.0, *)) {
        [self.tableView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _isShow = NO;
    _allArray = [NSArray array];
    _freezeArray = [NSMutableArray array];
    _unfreezeArray = [NSMutableArray array];
    
    [self request];
}

- (void) showTipLabel
{
    if (self.dataArray.count<1) {
        self.tipLabel.hidden = NO;
    } else {
        self.tipLabel.hidden = YES;
    }
}

- (void) request
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uid = [defaults objectForKey:@"uid"];
    if (uid.length) {
        __weak __typeof(self) weakSelf = self;
        NSDictionary *d = @{@"uid":uid};
        [[NetworkTool sharedTool] requestWithURLString:@"node/findEverydayNode" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
            NSLog(@"%@      ------------- %@", stringData, JSON );
            NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
            if ([code isEqualToString:@"1"]) {
                self.dataArray = [NSArray arrayWithArray:[JSON objectForKey:@"Data"]];
                _allArray = [NSArray arrayWithArray:self.dataArray];
                for (int i = 0; i < self.dataArray.count; i++) {
                    NSString *status = [[self.dataArray objectAtIndex:i] objectForKey:@"status"];
                    if ([status isEqualToString:@"0"]) {
                        [_freezeArray addObject:[self.dataArray objectAtIndex:i]];
                    } else {
                        [_unfreezeArray addObject:[self.dataArray objectAtIndex:i]];
                    }
                }
                [weakSelf.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
                [weakSelf performSelectorOnMainThread:@selector(showTipLabel) withObject:nil waitUntilDone:YES];
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
    NSString *status = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"status"];
    UILabel *title = (UILabel *)[cell viewWithTag:1];
    UILabel *time = (UILabel *)[cell viewWithTag:2];
    UILabel *sta = (UILabel *)[cell viewWithTag:4];
    if ([status isEqualToString:@"0"]) {
        title.text = [NSString stringWithFormat:@"产出"];
        sta.text = @"冻结";
        time.text = [NSString stringWithFormat:@"%@", [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"releaseTime"]];
    } else if ([status isEqualToString:@"1"]) {
        title.text = [NSString stringWithFormat:@"收益"];
        sta.text = @"解冻";
        time.text = [NSString stringWithFormat:@"%@", [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"releaseDaoqi"]];
    }
    UILabel *num = (UILabel *)[cell viewWithTag:3];
    num.text = [NSString stringWithFormat:@"%.2lf", [[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"release"] doubleValue]];

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

- (IBAction)selectBtnClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSInteger x = btn.tag-10;
    if (x == 0) {
        self.dataArray = [NSArray arrayWithArray:_allArray];
    } else if (x == 1) {
        self.dataArray = [NSArray arrayWithArray:_freezeArray];
    } else if (x == 2) {
        self.dataArray = [NSArray arrayWithArray:_unfreezeArray];
    }
    for (int i = 0; i < 3; i++) {
        [self.view viewWithTag:20+i].hidden = YES;
    }
    [self.view viewWithTag:20+x].hidden = NO;
    [self detailBtnClick:nil];
    [self.tableView reloadData];
    [self showTipLabel];
}

- (IBAction)detailBtnClick:(id)sender {
    self.BGBtn.hidden = !self.BGBtn.hidden;
    self.detailImageView.hidden = !self.detailImageView.hidden;
    self.detailImageView1.hidden = !self.detailImageView1.hidden;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    if (!_isShow) {
        self.detailView.frame = CGRectMake(self.detailView.frame.origin.x, self.titleBGLabel.frame.size.height, self.detailView.frame.size.width, self.detailView.frame.size.height);
    } else {
        self.detailView.frame = CGRectMake(self.detailView.frame.origin.x, -self.detailView.frame.size.height-1, self.detailView.frame.size.width, self.detailView.frame.size.height);
    }
    [UIView commitAnimations];
    _isShow = !_isShow;
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
