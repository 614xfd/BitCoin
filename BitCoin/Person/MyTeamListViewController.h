//
//  MyTeamListViewController.h
//  BitCoin
//
//  Created by LBH on 2019/4/29.
//  Copyright © 2019年 LBH. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyTeamListViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

NS_ASSUME_NONNULL_END
