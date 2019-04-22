//
//  SetPasswordViewController.h
//  BitCoin
//
//  Created by LBH on 2017/9/23.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetPasswordViewController : BaseViewController <UITextFieldDelegate>

@property (nonatomic, strong) NSString *phoneNum;
@property (nonatomic, strong) NSString *phone;

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UITextField *fPassword;
@property (weak, nonatomic) IBOutlet UITextField *sPassword;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UITextField *invite;

@end
