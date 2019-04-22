//
//  StoreHPViewController.h
//  BitCoin
//
//  Created by LBH on 2017/9/29.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImagesScrollView.h"

@interface StoreHPViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, ImagesScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
