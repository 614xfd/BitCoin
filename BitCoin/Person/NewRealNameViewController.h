//
//  NewRealNameViewController.h
//  BitCoin
//
//  Created by CCC on 2019/4/20.
//  Copyright © 2019年 LBH. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewRealNameViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *holdImageView;
@property (weak, nonatomic) IBOutlet UIImageView *frontImageView;
@property (weak, nonatomic) IBOutlet UIImageView *contraryImageView;

@property (nonatomic, strong) NSDictionary *infoDic;
@property (weak, nonatomic) IBOutlet UIView *stautsView;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@end

NS_ASSUME_NONNULL_END
