//
//  NodeParticularViewController.h
//  BitCoin
//
//  Created by LBH on 2018/8/28.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "BaseViewController.h"

@interface NodeParticularViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UILabel *titleBGLabel;
@property (weak, nonatomic) IBOutlet UIButton *BGBtn;
@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;
@property (weak, nonatomic) IBOutlet UIImageView *detailImageView1;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@property (nonatomic, strong) NSArray *dataArray;
@end
