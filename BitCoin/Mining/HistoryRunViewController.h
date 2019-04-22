//
//  HistoryRunViewController.h
//  BitCoin
//
//  Created by LBH on 2018/8/11.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "BalanceViewController.h"

@interface HistoryRunViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *allCoinLabel;
@property (weak, nonatomic) IBOutlet UILabel *allCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *allStepLabel;
@property (weak, nonatomic) IBOutlet UILabel *allKMLabel;
@property (weak, nonatomic) IBOutlet UILabel *allKCalLabel;

@end
