//
//  PayRecordViewController.h
//  BitCoin
//
//  Created by LBH on 2018/2/8.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "BaseViewController.h"

@interface PayRecordViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *userApiId;
@property (nonatomic, strong) NSString *coin;
@property (nonatomic, strong) NSString *units;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
