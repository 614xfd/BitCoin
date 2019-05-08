//
//  NewMiningHPViewController.m
//  BitCoin
//
//  Created by LBH on 2019/4/17.
//  Copyright © 2019年 LBH. All rights reserved.
//

#import "NewMiningHPViewController.h"
#import "UIView+AZGradient.h"
#import "QRCodeViewController.h"
#import "TeamViewController.h"
#import "UIView+AZGradient.h"
#import "LoginViewController.h"

@interface NewMiningHPViewController () <QRCodeViewControllerDelegate> {
    NSArray *_dataArray;
    
}

@end

@implementation NewMiningHPViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setBarBlackColor:NO];
    [self reques];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.bgLabel az_setGradientBackgroundWithColors:@[[UIColor colorWithRed:38/255.0 green:11/255.0 blue:99/255.0 alpha:1],[UIColor colorWithRed:116/255.0 green:34/255.0 blue:168/255.0 alpha:1]] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    NSDate *date =[NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [formatter stringFromDate:date];
    self.dateLabel.text = dateStr;
    self.dateLabel1.text = dateStr;
    [self.bgLineLabel.layer setBorderWidth:1];
    [self.bgLineLabel.layer setBorderColor:[UIColor colorWithRed:241/255.0 green:241/255.0 blue:245/255.0 alpha:1].CGColor];
    [self.viewBGColorLabel az_setGradientBackgroundWithColors:@[[UIColor colorWithRed:44/255.0 green:12/255.0 blue:104/255.0 alpha:1],[UIColor colorWithRed:116/255.0 green:34/255.0 blue:168/255.0 alpha:1]] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self reques];
}

- (void) setAllLabelText:(NSString *)string
{
    self.AllLabel.text = [NSString stringWithFormat:@"%.2lf", [string doubleValue]];
}

- (void) reques
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    _dataArray = [NSArray array];
    __weak __typeof(self) weakSelf = self;
    if (token.length) {
        NSDictionary *d = @{@"token":token};
        [[NetworkTool sharedTool] requestWithURLString:@"v1/mill/pool/getUserMill" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
            NSLog(@"%@      ------------- %@", stringData, JSON );
            NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
            if ([code isEqualToString:@"1"]) {
                _dataArray = [NSArray arrayWithArray:[[JSON objectForKey:@"data"] objectForKey:@"machines"]];
                [weakSelf performSelectorOnMainThread:@selector(setAllLabelText:) withObject:[NSString stringWithFormat:@"%@", [[JSON objectForKey:@"data"] objectForKey:@"all"]] waitUntilDone:YES];
            }
            [weakSelf.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            
        } failed:^(NSError *error) {
            //        [weakSelf requestError];
        }];
    }
}

- (void) requestAdd
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    _dataArray = [NSArray array];
    __weak __typeof(self) weakSelf = self;
    if (token.length) {
        NSDictionary *d = @{@"token":token, @"mac":self.macTF.text};
        [[NetworkTool sharedTool] requestWithURLString:@"v1/mill/pool/add" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
            NSLog(@"%@      ------------- %@", stringData, JSON );
            NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
            if ([code isEqualToString:@"1"]) {
                [weakSelf performSelectorOnMainThread:@selector(showToastWithMessage:) withObject:@"绑定成功" waitUntilDone:NO];
                [weakSelf performSelectorOnMainThread:@selector(reques) withObject:nil waitUntilDone:YES];
            }
            
        } failed:^(NSError *error) {
            //        [weakSelf requestError];
        }];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newminingcell" forIndexPath:indexPath];
    
    NSDictionary *dic = [_dataArray objectAtIndex:indexPath.row];
    UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:1];
    nameLabel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"name"]];
    UILabel *dayReleaseLabel = (UILabel *)[cell.contentView viewWithTag:2];
    dayReleaseLabel.text = [NSString stringWithFormat:@"%.5lf GTSE", [[dic objectForKey:@"dayRelease"] doubleValue]];
    UILabel *statusLabel = (UILabel *)[cell.contentView viewWithTag:3];
    NSString *stri = [NSString stringWithFormat:@"%@", [dic objectForKey:@"status"]];
    if ([stri isEqualToString:@"1"]) {
        statusLabel.text = @"正常";
    } else {
        statusLabel.text = @"异常";
    }
    UILabel *singleTotalLabel = (UILabel *)[cell.contentView viewWithTag:4];
    singleTotalLabel.text = [NSString stringWithFormat:@"%.2lf GTSE", [[dic objectForKey:@"singleTotal"] doubleValue]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)returnString:(NSString *)string
{
    self.macTF.text = string;
}

- (IBAction)scanBtnClick:(id)sender {
    QRCodeViewController *qrcodeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"qrcodeview"];
    qrcodeVC.delegate = self;
    [self.navigationController pushViewController:qrcodeVC animated:YES];
}

- (IBAction)addMiningBtnClick:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    if (token.length) {
        self.bgBtn.hidden = NO;
        self.addView.hidden = NO;
    } else {
        LoginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    [self.macTF resignFirstResponder];
}
- (IBAction)hiddenAddView:(id)sender {
    self.bgBtn.hidden = YES;
    self.addView.hidden = YES;
}

- (IBAction)payBtnClick:(id)sender {
    [self requestAdd];
    self.addView.hidden = YES;
}
- (IBAction)teamBtnClick:(id)sender {
    TeamViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"teamVC"];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.macTF resignFirstResponder];
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
