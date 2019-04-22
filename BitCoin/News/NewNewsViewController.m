//
//  NewNewsViewController.m
//  BitCoin
//
//  Created by LBH on 2019/4/14.
//  Copyright © 2019年 LBH. All rights reserved.
//

#import "NewNewsViewController.h"
#import "UIView+AZGradient.h"

@interface NewNewsViewController () {
    NSArray *_dataArray;
}

@end

@implementation NewNewsViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setBarBlackColor:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(request)];
    
    //自动更改透明度
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    //进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}

- (void) request
{
    _dataArray = @[];
    __weak __typeof(self) weakSelf = self;
    [[NetworkTool sharedTool] requestWithURLString:@"quickInfo/getNews" parameters:nil method:@"POST" completed:^(id JSON, NSString *stringData) {
        [weakSelf.tableView.mj_header endRefreshing];
        NSLog(@"%@      ------------- %@", stringData, JSON );
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            _dataArray = [NSArray arrayWithArray:[JSON objectForKey:@"data"]];
            [weakSelf.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        } else {
        }
    } failed:^(NSError *error) {
        //        [weakSelf requestError];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newnews" forIndexPath:indexPath];
    
    UIView *view = (UIView *) [cell.contentView viewWithTag:10];
    [view.layer setMasksToBounds:YES];
    view.layer.cornerRadius = 6;
    
    //    CAGradientLayer *gradient = [CAGradientLayer layer];
    //    gradient.frame = view.bounds;
    //    gradient.colors = @[(id)[UIColor colorWithRed:2/255.0 green:105/255.0 blue:180/255.0 alpha:1].CGColor,(id)[UIColor colorWithRed:56/255.0 green:174/255.0 blue:240/255.0 alpha:1].CGColor];
    //    gradient.startPoint = CGPointMake(0, 0);
    //    gradient.endPoint = CGPointMake(1, 0);
    //    //    gradient.locations = @[@(0.5f), @(1.0f)];
    //    [view.layer addSublayer:gradient];
    [view az_setGradientBackgroundWithColors:@[[UIColor colorWithRed:2/255.0 green:105/255.0 blue:180/255.0 alpha:1],[UIColor colorWithRed:56/255.0 green:174/255.0 blue:240/255.0 alpha:1]] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(0, 1)];
    
    UILabel *time = (UILabel *) [cell.contentView viewWithTag:11];
    time.text = [[_dataArray objectAtIndex:indexPath.row] objectForKey:@"time"];
    UILabel *title = (UILabel *) [cell.contentView viewWithTag:12];
    title.text = [[_dataArray objectAtIndex:indexPath.row] objectForKey:@"title"];
    UILabel *content = (UILabel *) [cell.contentView viewWithTag:13];
    content.text = [[_dataArray objectAtIndex:indexPath.row] objectForKey:@"content"];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
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
