//
//  ExtractViewController.h
//  BitCoin
//
//  Created by LBH on 2018/5/22.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "BaseViewController.h"
#import "QRCodeViewController.h"
#import "RealNameViewController.h"

@interface ExtractViewController : BaseViewController <QRCodeViewControllerDelegate, UIAlertViewDelegate, RealNameDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet UITextField *numberTF;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIView *payView;
@property (weak, nonatomic) IBOutlet UILabel *payMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *coinLabel;
@property (weak, nonatomic) IBOutlet UILabel *chargeLabel;

@property (nonatomic, strong) NSString *coinName;
@property (nonatomic, assign) double count;
@end
