//
//  CoinSendSuccessViewController.m
//  BitCoin
//
//  Created by LBH on 2018/9/19.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "CoinSendSuccessViewController.h"

@interface CoinSendSuccessViewController ()

@end

@implementation CoinSendSuccessViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setBarBlackColor:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.finishBtn.layer setBorderWidth:0.5];
    [self.finishBtn.layer setBorderColor:[UIColor colorWithRed:193/255.0 green:169/255.0 blue:107/255.0 alpha:1].CGColor];
    
    self.numberLabel.text = self.numberString;
    self.phoneLabel.text = self.phoneString;
}

- (IBAction)finishBtnClick:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
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
