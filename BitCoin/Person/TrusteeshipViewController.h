//
//  TrusteeshipViewController.h
//  BitCoin
//
//  Created by LBH on 2018/2/6.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "BaseViewController.h"

@interface TrusteeshipViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;

@end
