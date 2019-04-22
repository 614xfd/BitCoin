//
//  AnnouncementViewController.m
//  BitCoin
//
//  Created by LBH on 2018/9/18.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "AnnouncementViewController.h"
#import "AnnouncementInfoViewController.h"

@interface AnnouncementViewController ()

@end

@implementation AnnouncementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self request];
}

- (void) request
{
    __weak __typeof(self) weakSelf = self;
    [[NetworkTool sharedTool] requestWithURLString:@"/notice/list" parameters:nil method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@", stringData, JSON );
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            weakSelf.dataArray = [NSArray arrayWithArray:[JSON objectForKey:@"data"]];
            [weakSelf.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        } else {
            
        }
    } failed:^(NSError *error) {
        //        [weakSelf requestError];
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detail" forIndexPath:indexPath];
    
    UILabel *title = (UILabel *)[cell viewWithTag:1];
    title.text = [NSString stringWithFormat:@"%@", [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"title"]];
    
    UILabel *time = (UILabel *)[cell viewWithTag:2];
    time.text = [NSString stringWithFormat:@"%@", [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"datetime"]];
    
    UILabel *content = (UILabel *)[cell viewWithTag:3];
    content.text = [NSString stringWithFormat:@"%@", [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"content"]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140*kScaleH;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    AnnouncementInfoViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AnnouncementInfoVC"];
    //    vc.dic = [self.dataArray objectAtIndex:indexPath.row];
    //    [self.navigationController pushViewController:vc animated:YES];
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
