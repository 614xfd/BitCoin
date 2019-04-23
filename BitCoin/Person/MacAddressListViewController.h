//
//  MacAddressListViewController.h
//  BitCoin
//
//  Created by CCC on 2019/4/23.
//  Copyright © 2019年 LBH. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MacAddressListViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

NS_ASSUME_NONNULL_END
