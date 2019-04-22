//
//  SetPayPassWordViewController.h
//  BitCoin
//
//  Created by LBH on 2017/11/9.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import "BaseViewController.h"

@interface SetPayPassWordViewController : BaseViewController <UITextViewDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (nonatomic, strong) NSArray *numArray;

@property (nonatomic, assign) BOOL isReset;
@property (nonatomic, strong) NSString *tipString;

@property (nonatomic, assign) BOOL isNewPayPW;
@property (nonatomic, strong) NSString *original;

@property (nonatomic, assign) BOOL isVerify;

@end
