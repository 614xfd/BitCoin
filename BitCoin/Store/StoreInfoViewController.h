//
//  StoreInfoViewController.h
//  BitCoin
//
//  Created by LBH on 2017/10/12.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import "BaseViewController.h"
#import "ImagesScrollView.h"

@interface StoreInfoViewController : BaseViewController <ImagesScrollViewDelegate>

@property (nonatomic, strong) NSDictionary *dic;

@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIView *infoVIew;

@property (weak, nonatomic) IBOutlet UILabel *bgLabel;

@property (weak, nonatomic) IBOutlet UIView *storeView;
@property (weak, nonatomic) IBOutlet UILabel *rimLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sIconImage;
@property (weak, nonatomic) IBOutlet UILabel *sPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *sInventoryLabel;
@property (weak, nonatomic) IBOutlet UITextField *sNumberTF;
@property (weak, nonatomic) IBOutlet UILabel *storeTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *trusteeshipView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *nInventoryLabel;

@property (weak, nonatomic) IBOutlet UITextField *numTF;

@end
