//
//  AddressManageViewController.h
//  BitCoin
//
//  Created by LBH on 2017/10/21.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import "BaseViewController.h"

@interface AddressManageViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
