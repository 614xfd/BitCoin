//
//  NewMiningHPViewController.h
//  BitCoin
//
//  Created by LBH on 2019/4/17.
//  Copyright © 2019年 LBH. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewMiningHPViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *AllLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *bgLabel;
@property (weak, nonatomic) IBOutlet UIButton *bgBtn;
@property (weak, nonatomic) IBOutlet UIView *addView;
@property (weak, nonatomic) IBOutlet UILabel *bgLineLabel;
@property (weak, nonatomic) IBOutlet UITextField *macTF;


@end

NS_ASSUME_NONNULL_END
