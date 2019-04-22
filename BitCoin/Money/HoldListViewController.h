//
//  HoldListViewController.h
//  BitCoin
//
//  Created by LBH on 2018/9/21.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "BaseViewController.h"

@interface HoldListViewController : BaseViewController

@property (nonatomic, strong) NSArray *dataArray;
@property (weak, nonatomic) IBOutlet UILabel *rete_3;
@property (weak, nonatomic) IBOutlet UILabel *rate_6;
@property (weak, nonatomic) IBOutlet UILabel *rate_12;
@property (weak, nonatomic) IBOutlet UILabel *day_3;
@property (weak, nonatomic) IBOutlet UILabel *day_6;
@property (weak, nonatomic) IBOutlet UILabel *day_12;

@end
