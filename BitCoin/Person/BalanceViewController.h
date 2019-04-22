//
//  BalanceViewController.h
//  BitCoin
//
//  Created by LBH on 2018/5/22.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "BaseViewController.h"

@interface BalanceViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coinImage;
@property (nonatomic, strong) NSString *coinName;

@end
