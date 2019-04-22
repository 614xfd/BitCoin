//
//  SubAccountViewController.h
//  BitCoin
//
//  Created by LBH on 2018/2/5.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "BaseViewController.h"

@interface SubAccountViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *userApiId;
@property (nonatomic, strong) NSString *coin;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSString *units;
@property (weak, nonatomic) IBOutlet UILabel *earn24HoursLabel;
@property (weak, nonatomic) IBOutlet UILabel *earnTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *paidOutLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *last10mLabel;
@property (weak, nonatomic) IBOutlet UILabel *last30mLabel;
@property (weak, nonatomic) IBOutlet UILabel *last1hLabel;
@property (weak, nonatomic) IBOutlet UILabel *last1dLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *userApiIdLabel;

@end
