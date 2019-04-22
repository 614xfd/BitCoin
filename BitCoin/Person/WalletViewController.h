//
//  WalletViewController.h
//  BitCoin
//
//  Created by LBH on 2017/11/15.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import "BaseViewController.h"

@interface WalletViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;


@property (weak, nonatomic) IBOutlet UILabel *normalLab;
@property (weak, nonatomic) IBOutlet UILabel *freezeLab;


@end
