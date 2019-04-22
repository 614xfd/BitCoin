//
//  NewShareViewController.h
//  BitCoin
//
//  Created by mac on 2019/4/20.
//  Copyright © 2019 LBH. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewShareViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *codeLab;

@property (nonatomic, strong)NSString *codeStr;

@end

NS_ASSUME_NONNULL_END
