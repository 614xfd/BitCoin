//
//  MyOrderViewController.h
//  BitCoin
//
//  Created by LBH on 2017/10/27.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import "BaseViewController.h"

@interface MyOrderViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

//@property (weak, nonatomic) IBOutlet UITableView *paymentTableView;
//@property (weak, nonatomic) IBOutlet UITableView *finishTableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UILabel *blueLine;
@property (weak, nonatomic) IBOutlet UILabel *nowLabel;
@property (weak, nonatomic) IBOutlet UILabel *onceLabel;

@end
