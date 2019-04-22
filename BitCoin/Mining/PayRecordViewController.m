//
//  PayRecordViewController.m
//  BitCoin
//
//  Created by LBH on 2018/2/8.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "PayRecordViewController.h"

@interface PayRecordViewController () {
    NSInteger _s;
    BOOL _isRequest;
    UILabel *_tipLabel;
    NSInteger _totals;
}

@end

@implementation PayRecordViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setBarBlackColor:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _s = 0;
    _totals = 0;
    _isRequest = NO;
    self.dataArray = [NSMutableArray array];
    [self request];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    view.backgroundColor = [UIColor clearColor];
    
    _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    _tipLabel.text = @"加载中...";
    _tipLabel.textColor = [UIColor grayColor];
    _tipLabel.font = [UIFont systemFontOfSize:14];
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:_tipLabel];
    self.tableView.tableFooterView = view;
}

- (void) request
{
    _s++;
    if (_isRequest) {
        return;
    }
    __weak __typeof(self) weakSelf = self;
    NSDictionary *dic = @{@"phone":self.phone, @"userApiId":self.userApiId, @"coin":self.coin, @"page":[NSString stringWithFormat:@"%ld", _s]};
    _isRequest = YES;
    [[NetworkTool sharedTool] requestWithURLString:@"AntsPool/findUserPayout" parameters:dic method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ", JSON );
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            NSDictionary *d = [[JSON objectForKey:@"Data"] objectForKey:@"data"];
            _totals = [[d objectForKey:@"totalRecord"] integerValue];
            
            NSArray *row = [d objectForKey:@"rows"];
            for (NSDictionary *d in row) {
                [self.dataArray addObject:d];
            }
            [weakSelf.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        } else {
            [weakSelf performSelectorOnMainThread:@selector(showToastWithMessage:) withObject:[JSON objectForKey:@"msg"] waitUntilDone:YES];
        }
        _isRequest = NO;
    } failed:^(NSError *error) {
        //        [weakSelf requestError];
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pay" forIndexPath:indexPath];
    
    UILabel *address = (UILabel *)[cell viewWithTag:1];
    address.text = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"walletAddress"];
    
    UILabel *txId = (UILabel *)[cell viewWithTag:2];
    txId.text = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"txId"];

    
    UILabel *amount = (UILabel *)[cell viewWithTag:3];
    amount.text = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"amount"];
    
    UILabel *timestamp = (UILabel *)[cell viewWithTag:4];
    timestamp.text = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"timestamp"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135*kScaleH;
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.dataArray.count>0) {
        if (self.dataArray.count < _totals) {
            if (!_isRequest) {
                if (scrollView.contentOffset.y > scrollView.contentSize.height-scrollView.frame.size.height-400) {
                    [self request];
                } else {
                    //                NSLog(@"没进______%lf， contentSize______%lf",scrollView.contentOffset.y,scrollView.contentSize.height-scrollView.frame.size.height);
                }
            }
            
        } else {
            _tipLabel.text = @"已经是最后一页了。";
        }
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentSize.height>scrollView.frame.size.height) {
        if (!(scrollView.contentOffset.y > scrollView.contentSize.height-scrollView.frame.size.height+80)) {
            return;
        }
    } else {
        if (!(scrollView.contentOffset.y > 80)) {
            return;
        }
    }
    _tipLabel.text = @"已经是最后一页了。";
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
