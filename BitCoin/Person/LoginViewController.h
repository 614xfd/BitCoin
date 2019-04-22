//
//  LoginViewController.h
//  BitCoin
//
//  Created by LBH on 2017/9/23.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : BaseViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *passwordNum;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIImageView *showPasswordImage;
@property (weak, nonatomic) IBOutlet UILabel *bgLabel;
@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (nonatomic, assign) BOOL isResetPW;
@property (nonatomic, assign) BOOL isMonitoring;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *line;
@property (weak, nonatomic) IBOutlet UILabel *line1;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end
