//
//  RegisterViewController.h
//  BitCoin
//
//  Created by LBH on 2017/9/23.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : BaseViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *AreaCodeLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTF;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *inviteTf;
@property (weak, nonatomic) IBOutlet UIImageView *invitaCodeImgV;

@property (nonatomic, assign)bool isFindID; //找回密码

@end
