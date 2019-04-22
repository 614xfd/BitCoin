//
//  SafeViewController.h
//  BitCoin
//
//  Created by LBH on 2018/5/22.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "BaseViewController.h"
#import "RealNameViewController.h"

@interface SafeViewController : BaseViewController <RealNameDelegate>
@property (weak, nonatomic) IBOutlet UILabel *payPWLabel;
@property (weak, nonatomic) IBOutlet UILabel *loginPWLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *gesturePWLabel;


@property (weak, nonatomic) IBOutlet UIView *dustView;
@property (weak, nonatomic) IBOutlet UIView *tipView;

@end
