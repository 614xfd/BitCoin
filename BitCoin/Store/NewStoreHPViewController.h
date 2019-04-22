//
//  NewStoreHPViewController.h
//  BitCoin
//
//  Created by LBH on 2019/4/14.
//  Copyright © 2019年 LBH. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewStoreHPViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;

@end

NS_ASSUME_NONNULL_END
