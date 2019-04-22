//
//  ViewController.h
//  BitCoin
//
//  Created by LBH on 2017/9/22.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "marketHeadView.h"
#import "QRCodeViewController.h"

@interface MarketViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, marketHeadViewDelegate, QRCodeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (weak, nonatomic) IBOutlet UILabel *bgTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *titleImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *littleBtnView;
@property (weak, nonatomic) IBOutlet UIView *bigBtnView;


//@property (weak, nonatomic) IBOutlet UILabel *bgLabel;
//@property (weak, nonatomic) IBOutlet UIImageView *virtualCoinImage;
//@property (weak, nonatomic) IBOutlet UILabel *virtualCoinNameLabel;
//@property (weak, nonatomic) IBOutlet UILabel *turnoverLabel;
//@property (weak, nonatomic) IBOutlet UILabel *rangeLabel;
//@property (weak, nonatomic) IBOutlet UILabel *priceLabel;


@end

