//
//  MyOrderInfoViewController.h
//  BitCoin
//
//  Created by LBH on 2017/11/2.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import "BaseViewController.h"

@interface MyOrderInfoViewController : BaseViewController

@property (nonatomic, strong) NSDictionary *dataDic;

@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UIImageView *auditImageView;
@property (weak, nonatomic) IBOutlet UIImageView *finishImageView;
@property (weak, nonatomic) IBOutlet UILabel *orderStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *userAddressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *productTypeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *productNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalProductPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *allPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *payPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *payDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *sendDateLabel;
@property (weak, nonatomic) IBOutlet UIView *orderDateView;
@property (weak, nonatomic) IBOutlet UIView *serviceView;
@property (weak, nonatomic) IBOutlet UIView *payView;
@property (weak, nonatomic) IBOutlet UIButton *logisticsBtn;



@end
