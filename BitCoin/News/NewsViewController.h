//
//  NewsViewController.h
//  BitCoin
//
//  Created by LBH on 2018/9/19.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "BaseViewController.h"

@interface NewsViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end
