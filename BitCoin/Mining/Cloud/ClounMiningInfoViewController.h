//
//  ClounMiningInfoViewController.h
//  BitCoin
//
//  Created by LBH on 2018/9/21.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "BaseViewController.h"

@interface ClounMiningInfoViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *nullLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@end
