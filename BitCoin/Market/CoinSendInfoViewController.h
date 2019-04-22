//
//  CoinSendInfoViewController.h
//  BitCoin
//
//  Created by LBH on 2018/9/19.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "BaseViewController.h"

@interface CoinSendInfoViewController : BaseViewController <UITextFieldDelegate>

@property (nonatomic, strong) NSString *phoneString;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *chargeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sendImage;
@property (weak, nonatomic) IBOutlet UIView *payView;
@property (weak, nonatomic) IBOutlet UIButton *bgBtn;
@property (weak, nonatomic) IBOutlet UILabel *payNumLabel;
@property (weak, nonatomic) IBOutlet UIView *payTVView;
@property (weak, nonatomic) IBOutlet UITextField *numberTF;

@end
