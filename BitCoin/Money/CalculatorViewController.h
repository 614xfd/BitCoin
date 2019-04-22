//
//  CalculatorViewController.h
//  BitCoin
//
//  Created by LBH on 2018/5/22.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "BaseViewController.h"

@interface CalculatorViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIButton *mBtn;
@property (weak, nonatomic) IBOutlet UIButton *dBtn;
@property (weak, nonatomic) IBOutlet UIButton *yBtn;
@property (weak, nonatomic) IBOutlet UITextField *dayTF;
@property (weak, nonatomic) IBOutlet UITextField *rateTF;
@property (weak, nonatomic) IBOutlet UITextField *moneyTF;
@property (weak, nonatomic) IBOutlet UILabel *nowDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet UILabel *earningsLabel;
@property (weak, nonatomic) IBOutlet UIView *btnBGView;

@end
