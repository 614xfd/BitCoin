//
//  NewsViewController.m
//  BitCoin
//
//  Created by LBH on 2018/9/19.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "NewsViewController.h"
#import "WebViewController.h"

@interface NewsViewController ()

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self request];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
}

- (void) request
{
    __weak __typeof(self) weakSelf = self;
    [[NetworkTool sharedTool] requestWithURLString:@"jscj/getJscj" parameters:nil method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@", stringData, JSON );
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            [weakSelf performSelectorOnMainThread:@selector(requestList:) withObject:[JSON objectForKey:@"Data"] waitUntilDone:YES];
        } else {
            
        }
    } failed:^(NSError *error) {
        //        [weakSelf requestError];
    }];
}

- (void) requestList : (NSString *)string
{
    __weak __typeof(self) weakSelf = self;
    [[NetworkTool sharedTool] requestWithHPURLString:string parameters:nil method:@"GET" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@", stringData, JSON );
        weakSelf.dataArray = [NSArray arrayWithArray:[JSON objectForKey:@"list"]];
        NSLog(@"%ld", self.dataArray.count);
        [weakSelf.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    } failed:^(NSError *error) {
        //        [weakSelf requestError];x
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"news" forIndexPath:indexPath];
    UILabel *label = (UILabel *)[cell viewWithTag:1];

    if (indexPath.row == 0) {
        label.hidden = NO;
    } else {
        label.hidden = YES;
    }
    NSArray *array = [[[[[self.dataArray objectAtIndex:indexPath.section] objectForKey:@"lives"] objectAtIndex:indexPath.row] objectForKey:@"content"] componentsSeparatedByString:@"】"];
    UILabel *content = (UILabel *)[cell viewWithTag:4];
    content.text = [array objectAtIndex:1];
    CGSize maximumLabelSize = CGSizeMake(content.frame.size.width, 9999);//labelsize的最大值
    CGSize expectSize = [content sizeThatFits:maximumLabelSize];
    content.frame = CGRectMake(content.frame.origin.x, content.frame.origin.y, expectSize.width, expectSize.height);
    
    NSString *s = [[[[self.dataArray objectAtIndex:indexPath.section] objectForKey:@"lives"] objectAtIndex:indexPath.row] objectForKey:@"created_at"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[s doubleValue]];
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"HH:mm"];
    NSString* string=[dateFormat stringFromDate:confromTimesp];
    UILabel *time = (UILabel *)[cell viewWithTag:2];
    time.text = string;
    UILabel *titleLab = (UILabel *)[cell viewWithTag:3];
    titleLab.text = [NSString stringWithFormat:@"%@】", [array objectAtIndex:0]];
    
    UIView *view = (UIView *)[cell viewWithTag:10];
    view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 142+content.frame.size.height);
    UILabel *line = (UILabel *)[cell viewWithTag:8];
    line.frame = CGRectMake(line.frame.origin.x, line.frame.origin.y, line.frame.size.width, cell.contentView.frame.size.height);
    UIView *v = (UIView *)[cell viewWithTag:9];
    v.frame = CGRectMake(v.frame.origin.x, content.frame.size.height+content.frame.origin.y, v.frame.size.width, v.frame.size.height);
    
    UILabel *label1 = (UILabel *)[cell viewWithTag:11];
    UIButton *button = (UIButton *)[v.subviews objectAtIndex:1];
    
    NSString *link = [[[[self.dataArray objectAtIndex:indexPath.section] objectForKey:@"lives"] objectAtIndex:indexPath.row] objectForKey:@"link"];
    if (link.length) {
        label1.hidden = NO;
        button.hidden = NO;
        button.tag = 100000*indexPath.section+indexPath.row;
    } else {
        label1.hidden = YES;
        button.hidden = YES;
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.dataArray objectAtIndex:section] objectForKey:@"lives"] count];
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//
//
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.textLabel.text = [[[[self.dataArray objectAtIndex:indexPath.section] objectForKey:@"lives"] objectAtIndex:indexPath.row] objectForKey:@"content"];
    CGSize maximumLabelSize = CGSizeMake(self.textLabel.frame.size.width, 9999);//labelsize的最大值
    CGSize expectSize = [self.textLabel sizeThatFits:maximumLabelSize];
//    self.textLabel.frame = CGRectMake(20, 70, expectSize.width, expectSize.height);
    
    return  expectSize.height+195;
}

- (IBAction)linkBtnClick:(id)sender {
    NSString *string = [[[[self.dataArray objectAtIndex:[sender tag]/100000] objectForKey:@"lives"] objectAtIndex:[sender tag]%100000] objectForKey:@"link"];
    WebViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WebVC"];
    vc.UrlString = string;
    [self.navigationController pushViewController:vc animated:YES];
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
