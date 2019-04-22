//
//  AddAddressViewController.h
//  BitCoin
//
//  Created by LBH on 2017/10/21.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import "BaseViewController.h"

@interface AddAddressViewController : BaseViewController

@property (nonatomic, assign) BOOL isReset;
@property (nonatomic, strong) NSDictionary *dic;

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UILabel *regionLabel;
@property (weak, nonatomic) IBOutlet UITextView *addressTV;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@end
