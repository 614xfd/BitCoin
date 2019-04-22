//
//  MyOrderInfoViewController.m
//  BitCoin
//
//  Created by LBH on 2017/11/2.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import "MyOrderInfoViewController.h"
#import "PayViewController.h"

@interface MyOrderInfoViewController ()

@end

@implementation MyOrderInfoViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setBarBlackColor:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.userNameLabel.text = [NSString stringWithFormat:@"%@", [self.dataDic objectForKey:@"RAname"]];
    self.userPhoneLabel.text = [NSString stringWithFormat:@"%@", [self.dataDic objectForKey:@"RAphone"]];
    self.userAddressLabel.text = [NSString stringWithFormat:@"%@", [self.dataDic objectForKey:@"ReceivingAddress"]];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMAGE_URL, [self.dataDic objectForKey:@"productTypeImg"]]]];
    self.productTypeLabel.text = [NSString stringWithFormat:@"%@", [self.dataDic objectForKey:@"productType"]];
    [self.productImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMAGE_URL, [self.dataDic objectForKey:@"productTitleImg"]]]];
    self.productTitleLabel.text = [NSString stringWithFormat:@"%@", [self.dataDic objectForKey:@"productName"]];
    self.productPriceLabel.text = [NSString stringWithFormat:@"%@ USDT", [self.dataDic objectForKey:@"productPrice"]];
    self.productNumLabel.text = [NSString stringWithFormat:@"x%@", [self.dataDic objectForKey:@"productNumber"]];
    self.totalProductPriceLabel.text = [NSString stringWithFormat:@"%@ USDT", [self.dataDic objectForKey:@"productTotal"]];
    self.allPriceLabel.text = [NSString stringWithFormat:@"%@ USDT", [self.dataDic objectForKey:@"orderTotal"]];
    self.payPriceLabel.text = [NSString stringWithFormat:@"%@ USDT", [self.dataDic objectForKey:@"orderTotal"]];
    self.orderNumLabel.text = [NSString stringWithFormat:@"%@", [self.dataDic objectForKey:@"OrderID"]];
    self.orderDateLabel.text = [NSString stringWithFormat:@"%@", [self.dataDic objectForKey:@"EstablishDate"]];
    
    NSString *orderState = [NSString stringWithFormat:@"%@", [self.dataDic objectForKey:@"orderState"]];
    if ([orderState isEqualToString:@"0"]) {
        self.orderStateLabel.text = @"等待买家付款";
        self.auditImageView.hidden = NO;
    } else if ([orderState isEqualToString:@"1"]) {
        self.orderStateLabel.text = @"等待审核";
        self.auditImageView.hidden = NO;
    } else if ([orderState isEqualToString:@"2"]) {
        self.finishImageView.hidden = NO;
        self.payView.hidden = YES;
        self.logisticsBtn.hidden = NO;
    }
}

- (IBAction)cancleBtnClick:(id)sender {
    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *uid = [defaults objectForKey:@"uid"];
//    __weak __typeof(self) weakSelf = self;
//    NSDictionary *d = @{@"uid":uid};
//    [[NetworkTool sharedTool] requestWithURLString:@"user/delOrder" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
//        NSLog(@"%@      ------------- %@", stringData, JSON );
//        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
//        if ([code isEqualToString:@"1"]) {
//
//        } else {
//
//        }
//    } failed:^(NSError *error) {
//        //        [weakSelf requestError];
//    }];
}

- (IBAction)payBtnClick:(id)sender {
    PayViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PayVC"];
//    vc.orderDict = self.dataDic;
    vc.idString = [NSString stringWithFormat:@"%@", [self.dataDic objectForKey:@"OrderID"]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)logisticsBtnClick:(id)sender {
    
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
