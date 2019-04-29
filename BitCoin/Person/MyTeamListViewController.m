//
//  MyTeamListViewController.m
//  BitCoin
//
//  Created by LBH on 2019/4/29.
//  Copyright © 2019年 LBH. All rights reserved.
//

#import "MyTeamListViewController.h"

#define WIDTH self.view.frame.size.width

@interface MyTeamListViewController () {
    NSMutableArray *_firstArray;
    NSMutableDictionary *_secDic;
    NSMutableArray *_isOpenArr;
//    NSDictionary *_dicc;
}

@end

@implementation MyTeamListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _firstArray = [NSMutableArray array];
    _secDic = [NSMutableDictionary dictionary];
    _isOpenArr = [NSMutableArray array];
//    _dicc = @{@"79r9yg3":@[@"123123"], @"9jmhdgv":@[@"32451235",@"asdghf",@"3456",@"34",@"123412351",@"6573",@"3151235",@"1345143"], @"9jnchpp":@[@"970987089",@"90867686",@"bjaofhoa",@"i786998",@"0986776",@"asdfgasg"]};
    [self request];
}

- (void) request
{
    __weak __typeof(self) weakSelf = self;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    NSString *phoneNum = [defaults objectForKey:@"phoneNum"];
    if (token.length) {
        NSDictionary *d = @{@"token":token, @"phone":phoneNum};
        [[NetworkTool sharedTool] requestWithURLString:@"v1/user/user/getOneLevel" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
            NSLog(@"%@      ------------- %@", stringData, JSON );
            NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
            if ([code isEqualToString:@"1"]) {
                NSLog(@"");
                NSArray *array = [JSON objectForKey:@"data"];
                for (int i = 0; i < array.count; i++) {
                    NSString *string = [[array objectAtIndex:i] objectForKey:@"level"];
                    if ([string isEqualToString:@"1"]) {
                        [_firstArray addObject:[array objectAtIndex:i]];
                        [_isOpenArr addObject:@"0"];
                    } else {
                        NSArray *arr = [_secDic objectForKey:[[array objectAtIndex:i] objectForKey:@"inviteYards"]];
                        if (arr.count) {
                            NSMutableArray *a = [NSMutableArray arrayWithArray:arr];
                            [a addObject:[array objectAtIndex:i]];
                            arr = [NSArray arrayWithArray:a];
                            [_secDic setObject:arr forKey:[[array objectAtIndex:i] objectForKey:@"inviteYards"]];
                        } else {
                            [_secDic setObject:@[[array objectAtIndex:i]] forKey:[[array objectAtIndex:i] objectForKey:@"inviteYards"]];
                        }
                    }
                }
                [weakSelf.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            } else {
            }
        } failed:^(NSError *error) {
            
        }];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myteamlist" forIndexPath:indexPath];
    NSArray *array = [_secDic objectForKey:[[_firstArray objectAtIndex:indexPath.section] objectForKey:@"inviteCode"]];
    UILabel *label = (UILabel *) [cell viewWithTag:1];
    label.text = [[array objectAtIndex:indexPath.row] objectForKey:@"phone"];
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[_isOpenArr objectAtIndex:section]isEqualToString:@"0"]) {
        return 0;
    }
    return [[_secDic objectForKey:[[_firstArray objectAtIndex:section] objectForKey:@"inviteCode"]] count];
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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 50)];
    view.tag = 888;
    view.backgroundColor = [UIColor colorWithRed:2/255.0 green:60/255.0 blue:104/255.0 alpha:1];
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(25, (50-18)/2, 9, 18)];
    img.image = [UIImage imageNamed:@"个人中心_05.png.png"];
    if ([[_isOpenArr objectAtIndex:section] isEqualToString:@"0"]) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        img.transform = CGAffineTransformMakeRotation(0);
        [UIView commitAnimations];
    } else {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        img.transform = CGAffineTransformMakeRotation(M_PI_2);
        [UIView commitAnimations];
        
    }
    img.tag = 200+section;
    [view addSubview:img];

    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 200, 50)];
    lab.text = [[_firstArray objectAtIndex:section] objectForKey:@"phone"];
    lab.font = [UIFont boldSystemFontOfSize:16];
    lab.textColor = [UIColor whiteColor];
    [view addSubview:lab];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 49.5, WIDTH, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:201/255.0 green:202/255.0 blue:202/255.0 alpha:1];
    [view addSubview:line];
    
    [tvhf.contentView addSubview:view];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, WIDTH, view.frame.size.height)];
    [btn setBackgroundColor:[UIColor clearColor]];
    btn.tag = 100+section;
    [btn addTarget:self action:@selector(headerViewClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    return tvhf;
}

- (void)headerViewClick:(UIButton *)btn{
    
    NSString *numStr = [_isOpenArr objectAtIndex:btn.tag - 100];
    if ([numStr isEqualToString:@"0"]) {
        [_isOpenArr replaceObjectAtIndex:btn.tag - 100 withObject:@"1"];
    }else{
        [_isOpenArr replaceObjectAtIndex:btn.tag - 100 withObject:@"0"];
    }
    
    //一个section刷新
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:btn.tag-100];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    
    //一个cell刷新
    //    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:3 inSection:0];
    //    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return _firstArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}




- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
