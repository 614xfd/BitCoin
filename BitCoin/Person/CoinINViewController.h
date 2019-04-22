//
//  CoinINViewController.h
//  BitCoin
//
//  Created by LBH on 2019/4/22.
//  Copyright © 2019年 LBH. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CoinINViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet UITextField *numTF;
@property (weak, nonatomic) IBOutlet UIImageView *addressImageView;

@end

NS_ASSUME_NONNULL_END
