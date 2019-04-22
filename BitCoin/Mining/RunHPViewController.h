//
//  RunHPViewController.h
//  BitCoin
//
//  Created by LBH on 2018/7/7.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "BaseViewController.h"
#import "CaptchaViewController.h"
#import "bluetooth.h"
#import <HealthKit/HealthKit.h>
#import "MacListViewController.h"

@interface RunHPViewController : BaseViewController <CaptchaDelegate, UITableViewDelegate, UITableViewDataSource, BlueDelegate, MacListDelegate>

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *dateView;
@property (weak, nonatomic) IBOutlet UIView *dateBGView;
@property (weak, nonatomic) IBOutlet UIButton *upDataBtn;
@property (weak, nonatomic) IBOutlet UIImageView *bluImageView;
@property (weak, nonatomic) IBOutlet UILabel *bluStateLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UIButton *dateBGBtn;
@property (weak, nonatomic) IBOutlet UILabel *stepLabel;
@property (weak, nonatomic) IBOutlet UILabel *calLabel;
@property (weak, nonatomic) IBOutlet UILabel *kmLabel;
@property (weak, nonatomic) IBOutlet UIView *diskView;
@property (weak, nonatomic) IBOutlet UIImageView *runImageView;
@property (weak, nonatomic) IBOutlet UILabel *runLabel;
@property (weak, nonatomic) IBOutlet UIButton *bluBtn;
@property (weak, nonatomic) IBOutlet UIImageView *lineImageView;
@property (weak, nonatomic) IBOutlet UILabel *todayLabel;
@property (weak, nonatomic) IBOutlet UIButton *bindingBtn;
@property (weak, nonatomic) IBOutlet UILabel *macLabel;

@property (nonatomic, strong) HKHealthStore *healthStore;

@end
