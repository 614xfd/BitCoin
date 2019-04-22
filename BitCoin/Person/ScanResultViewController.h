//
//  ScanResultViewController.h
//  BitCoin
//
//  Created by LBH on 2017/9/30.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import "BaseViewController.h"

@interface ScanResultViewController : BaseViewController

@property (nonatomic, strong) NSString *text;

@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end
