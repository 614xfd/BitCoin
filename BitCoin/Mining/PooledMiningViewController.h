//
//  PooledMiningViewController.h
//  BitCoin
//
//  Created by LBH on 2018/2/5.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "BaseViewController.h"

@interface PooledMiningViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *coinArray;
@property (weak, nonatomic) IBOutlet UILabel *minLabel;
@property (weak, nonatomic) IBOutlet UILabel *hourLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *coinLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *bgLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITableView *changeCoinTableView;
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;
@property (weak, nonatomic) IBOutlet UIView *activityView;

@end
