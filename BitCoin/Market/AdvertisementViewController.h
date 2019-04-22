//
//  AdvertisementViewController.h
//  BitCoin
//
//  Created by LBH on 2018/5/24.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "BaseViewController.h"

@interface AdvertisementViewController : BaseViewController <UIApplicationDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *advImage;
@property (weak, nonatomic) IBOutlet UIButton *skipBtn;
@property (weak, nonatomic) IBOutlet UILabel *bgLabel;

@end
