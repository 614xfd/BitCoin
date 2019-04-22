//
//  AnnouncementViewController.h
//  BitCoin
//
//  Created by LBH on 2018/9/18.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "BaseViewController.h"

@interface AnnouncementViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
