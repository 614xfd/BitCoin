//
//  SubordinateViewController.h
//  BitCoin
//
//  Created by LBH on 2018/9/21.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "BaseViewController.h"

@interface SubordinateViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *superiorLabel;
@property (weak, nonatomic) IBOutlet UILabel *subordinateLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@end
