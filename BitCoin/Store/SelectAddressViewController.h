//
//  SelectAddressViewController.h
//  BitCoin
//
//  Created by LBH on 2017/10/21.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import "BaseViewController.h"

@protocol SelectAddressDelegate <NSObject>

- (void) returnAddressDic : (NSDictionary *)dic;

@end

@interface SelectAddressViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) id <SelectAddressDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
