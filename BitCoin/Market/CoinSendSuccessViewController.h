//
//  CoinSendSuccessViewController.h
//  BitCoin
//
//  Created by LBH on 2018/9/19.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "BaseViewController.h"

@interface CoinSendSuccessViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;

@property (nonatomic, strong) NSString *numberString;
@property (nonatomic, strong) NSString *phoneString;

@end
