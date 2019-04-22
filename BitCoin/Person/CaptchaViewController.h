//
//  CaptchaViewController.h
//  BitCoin
//
//  Created by LBH on 2017/9/23.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CaptchaDelegate <NSObject>

@optional
- (void) verifySuccessWithCode:(NSString *)code;

@end

@interface CaptchaViewController : BaseViewController <UITextViewDelegate>

@property (nonatomic, assign) BOOL isReset;
@property (nonatomic, assign) BOOL isVerify;
@property (nonatomic, assign) BOOL isPayVerify;
@property (nonatomic, assign) BOOL isRun;
@property (nonatomic, strong) NSString *phoneNum;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, weak) id <CaptchaDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *resetTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *backView;
@property (weak, nonatomic) IBOutlet UILabel *captchaLabel;
@property (weak, nonatomic) IBOutlet UIView *captchaView;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *countDownLabel;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UIButton *reSandBtn;

@end
