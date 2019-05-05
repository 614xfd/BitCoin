//
//  CoinOUTViewController.h
//  BitCoin
//
//  Created by LBH on 2019/4/23.
//  Copyright © 2019年 LBH. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CoinOUTViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet UITextField *numTF;
@property (weak, nonatomic) IBOutlet UILabel *coinNumLabel;
@property (weak, nonatomic) IBOutlet UITextField *contentTF;

@end

NS_ASSUME_NONNULL_END
