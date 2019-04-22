//
//  ShareViewController.h
//  BitCoin
//
//  Created by LBH on 2018/5/22.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "BaseViewController.h"

@interface ShareViewController : BaseViewController

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *number;

@property (weak, nonatomic) IBOutlet UIImageView *codeImageView;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UIButton *tipLabel;

@end
