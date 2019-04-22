//
//  PersonHomeViewController.h
//  BitCoin
//
//  Created by LBH on 2017/9/23.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RealNameViewController.h"

@interface PersonHomeViewController : BaseViewController <UIActionSheetDelegate, RealNameDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNum;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bgLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;
@property (weak, nonatomic) IBOutlet UILabel *balance;
@property (weak, nonatomic) IBOutlet UILabel *subordinateLabel;
@property (weak, nonatomic) IBOutlet UILabel *allUserLabel;

@end
