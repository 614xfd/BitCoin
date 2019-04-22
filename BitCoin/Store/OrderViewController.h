//
//  OrderViewController.h
//  BitCoin
//
//  Created by LBH on 2017/10/13.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import "BaseViewController.h"
#import "SelectAddressViewController.h"

@interface OrderViewController : BaseViewController <SelectAddressDelegate>

@property (nonatomic, strong) NSDictionary *dic;
@property (nonatomic, strong) NSString *storeNum;

@property (nonatomic, strong) NSString *imageString;

@property (weak, nonatomic) IBOutlet UILabel *pLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *storeImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *dispatchingLabel;
@property (weak, nonatomic) IBOutlet UITextField *receiptTF;
@property (weak, nonatomic) IBOutlet UILabel *maintainLabel;
@property (weak, nonatomic) IBOutlet UITextField *messageTF;
@property (weak, nonatomic) IBOutlet UILabel *allStoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *monyeLabel;
@property (weak, nonatomic) IBOutlet UILabel *xjLabel;
@property (weak, nonatomic) IBOutlet UIButton *orderBtn;
@property (weak, nonatomic) IBOutlet UIButton *hiddenBtn;
@end
