//
//  NewPersonHomeViewController.h
//  BitCoin
//
//  Created by CCC on 2019/4/23.
//  Copyright © 2019年 LBH. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewPersonHomeViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIView *footView;

@end

NS_ASSUME_NONNULL_END
