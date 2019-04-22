//
//  BillViewController.h
//  BitCoin
//
//  Created by LBH on 2018/8/31.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "BaseViewController.h"

@interface BillViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIButton *BGBtn;

@end
