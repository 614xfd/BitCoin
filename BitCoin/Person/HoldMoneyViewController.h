//
//  HoldMoneyViewController.h
//  BitCoin
//
//  Created by LBH on 2017/9/29.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomAlertView.h"

@interface HoldMoneyViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *earningsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@end
