//
//  MacListViewController.m
//  BitCoin
//
//  Created by LBH on 2018/8/11.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "MacListViewController.h"

@interface MacListViewController () {
    NSString *_macString;
}

@end

@implementation MacListViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setBarBlackColor:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.codeView.layer.cornerRadius = 4;
    self.codeView.layer.masksToBounds = YES;
    self.bgLabel.layer.cornerRadius = 4;
    self.bgLabel.layer.masksToBounds = YES;
}

- (void) reSetMacArray:(NSArray *)array
{
    self.dataArray = [NSArray arrayWithArray:array];
    [self.tableView reloadData];
}

- (void) requestActivationCode
{
    __weak __typeof(self) weakSelf = self;
    [[NetworkTool sharedTool] requestWithURLString:@"activitCode/getActivityCode" parameters:nil method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@", stringData, JSON );
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
//            _activationCode = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"Data"]];
//            [weakSelf performSelectorOnMainThread:@selector(requestActivate) withObject:nil waitUntilDone:YES];
        } else {
            
        }
    } failed:^(NSError *error) {
        //        [weakSelf requestError];
    }];
}

- (void) requestActivate
{
    __weak __typeof(self) weakSelf = self;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uid = [defaults objectForKey:@"uid"];
    NSString *mac = _macString;
    NSDictionary *d = @{@"uid":uid, @"code":self.codeTF.text, @"blueMac":mac};
    [[NetworkTool sharedTool] requestWithURLString:@"activitCode/activity" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@", stringData, JSON );
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        [weakSelf performSelectorOnMainThread:@selector(showToastWithMessage:) withObject:[JSON objectForKey:@"msg"] waitUntilDone:YES];

        if ([code isEqualToString:@"1"]) {
            [weakSelf performSelectorOnMainThread:@selector(returnSuccess) withObject:nil waitUntilDone:YES];
        } else {
        }
        

    } failed:^(NSError *error) {
        //        [weakSelf requestError];
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mac" forIndexPath:indexPath];
    
    UILabel *mac = (UILabel *)[cell viewWithTag:1];
    mac.text = [NSString stringWithFormat:@"%@", [self changeMac:[_dataArray objectAtIndex:indexPath.row]]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58*kScaleH;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _macString = [NSString stringWithFormat:@"%@", [self changeMac:[_dataArray objectAtIndex:indexPath.row]]];
    self.codeView.hidden = NO;
    self.bgBtn.hidden = NO;
}

- (void) returnSuccess
{
    double delayInSeconds = 1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_global_queue(0,0), ^(void){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate bindingSuccess];
            [self.navigationController popViewControllerAnimated:YES];
        });
    });
}

- (NSString *) changeMac : (NSString *)string
{
    NSString *doneTitle = @"";
    for (int i = 0, count = 0; i < string.length; i++) {
        count++;
        doneTitle = [doneTitle stringByAppendingString:[string substringWithRange:NSMakeRange(i, 1)]];
        if (count == 2 && i<string.length-1) {
            doneTitle = [NSString stringWithFormat:@"%@:", doneTitle];
            count = 0;
        }
    }
    return doneTitle;
}

- (IBAction)sandCode:(id)sender {
    if (self.codeTF.text.length > 0) {
        [self requestActivate];
        self.codeView.hidden = YES;
        self.bgBtn.hidden = YES;
    } else {
        [self showToastWithMessage:@"请输入激活码"];
    }
}

- (IBAction)cancleSend:(id)sender {
    self.codeView.hidden = YES;
    self.bgBtn.hidden = YES;
}

- (IBAction)hiddenCodeView:(id)sender {
    self.codeView.hidden = YES;
    self.bgBtn.hidden = YES;
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
