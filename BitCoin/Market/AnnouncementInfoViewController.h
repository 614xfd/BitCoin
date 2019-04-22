//
//  AnnouncementInfoViewController.h
//  BitCoin
//
//  Created by LBH on 2018/9/19.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "BaseViewController.h"

@interface AnnouncementInfoViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabbel;
@property (weak, nonatomic) IBOutlet UILabel *content;

@property (nonatomic, strong) NSDictionary *dic;

@end
