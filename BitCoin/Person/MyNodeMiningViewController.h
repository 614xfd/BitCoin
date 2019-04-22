//
//  MyNodeMiningViewController.h
//  BitCoin
//
//  Created by LBH on 2018/8/20.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "BaseViewController.h"

@interface MyNodeMiningViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *topBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *hashRateSumLabel;
@property (weak, nonatomic) IBOutlet UILabel *grandTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *rverydayLabel;
@property (weak, nonatomic) IBOutlet UILabel *reverydayRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *unfreezeSumLabel;
@property (weak, nonatomic) IBOutlet UILabel *unfreezeDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *freezeSumLabel;

@property (nonatomic, strong) NSArray *dataArray;

@end
