//
//  ReSetPayPasswordViewController.h
//  BitCoin
//
//  Created by mac on 2019/4/23.
//  Copyright © 2019 LBH. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReSetPayPasswordViewController : BaseViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *tf;
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;

@end

NS_ASSUME_NONNULL_END
