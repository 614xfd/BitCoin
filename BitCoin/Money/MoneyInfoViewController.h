//
//  MoneyInfoViewController.h
//  BitCoin
//
//  Created by LBH on 2017/10/12.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import "BaseViewController.h"
#import "RealNameViewController.h"

@interface MoneyInfoViewController : BaseViewController <UITextViewDelegate, UIAlertViewDelegate, RealNameDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *saveLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UIButton *bgButton;
@property (weak, nonatomic) IBOutlet UIView *buyInfoView;
@property (weak, nonatomic) IBOutlet UILabel *USDTLine;
@property (weak, nonatomic) IBOutlet UILabel *BBCLine;
@property (weak, nonatomic) IBOutlet UILabel *lastBBCLine;
@property (weak, nonatomic) IBOutlet UIImageView *warnImage;
@property (weak, nonatomic) IBOutlet UILabel *warnLabel;
@property (weak, nonatomic) IBOutlet UITextField *usdtTF;
@property (weak, nonatomic) IBOutlet UITextField *bbcTF;
@property (weak, nonatomic) IBOutlet UITextField *allBBCTF;
@property (weak, nonatomic) IBOutlet UILabel *bbcPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *limitLabel;
@property (weak, nonatomic) IBOutlet UIView *payView;
@property (weak, nonatomic) IBOutlet UILabel *payMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *allDayLabel;

@property (nonatomic, strong) NSString *idString;
@property (nonatomic, strong) NSString *day;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *rate;
@property (nonatomic, strong) NSString *type;



@end
