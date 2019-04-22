//
//  ResetPasswordViewController.h
//  BitCoin
//
//  Created by LBH on 2017/9/23.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResetPasswordViewController : BaseViewController

@property (nonatomic, strong) NSString *phoneNum;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordNumTF;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end
