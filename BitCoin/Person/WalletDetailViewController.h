//
//  WalletDetailViewController.h
//  BitCoin
//
//  Created by mac on 2019/4/20.
//  Copyright © 2019 LBH. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletDetailViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tabView;
@end

NS_ASSUME_NONNULL_END
