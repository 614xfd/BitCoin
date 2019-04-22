//
//  MonitoringViewController.h
//  BitCoin
//
//  Created by LBH on 2017/11/9.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import "BaseViewController.h"

@interface MonitoringViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) UIView *publicView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
