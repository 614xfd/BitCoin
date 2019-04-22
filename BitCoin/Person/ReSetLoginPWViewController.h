//
//  ReSetLoginPWViewController.h
//  BitCoin
//
//  Created by LBH on 2017/12/28.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import "BaseViewController.h"

@interface ReSetLoginPWViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UITextField *passwordNumTF;
@property (nonatomic, assign) BOOL isReSet;
@property (nonatomic, strong) NSString *password;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@end
