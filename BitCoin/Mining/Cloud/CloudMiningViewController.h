//
//  CloudMiningViewController.h
//  BitCoin
//
//  Created by LBH on 2018/9/6.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "BaseViewController.h"
#import "RealNameViewController.h"

@interface CloudMiningViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource, RealNameDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *cardScroll;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UIView *unUseView;
@property (weak, nonatomic) IBOutlet UILabel *unUseTipLael;
@property (weak, nonatomic) IBOutlet UITableView *unUseTableView;
@property (weak, nonatomic) IBOutlet UIView *useView;
@property (weak, nonatomic) IBOutlet UILabel *useTipLabel;
@property (weak, nonatomic) IBOutlet UITableView *useTableView;
@property (weak, nonatomic) IBOutlet UIView *earningsView;
@property (weak, nonatomic) IBOutlet UIView *nodeView;
@property (weak, nonatomic) IBOutlet UIView *activatView;
@property (weak, nonatomic) IBOutlet UIButton *activatBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *bgBtn;
@property (weak, nonatomic) IBOutlet UITextField *ACTF;
@property (weak, nonatomic) IBOutlet UITextField *MACTF;
@property (weak, nonatomic) IBOutlet UILabel *accumulatedIncomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayOutputLabel;
@property (weak, nonatomic) IBOutlet UILabel *anticipatedIncomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *surplusDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *accumulatedIncome1Label;
@property (weak, nonatomic) IBOutlet UILabel *codeAllNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeDayGetLable;
@property (weak, nonatomic) IBOutlet UILabel *codeNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayNumLabel;

@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, strong) NSArray *unUseArray;
@property (nonatomic, strong) NSArray *useArray;
@property (weak, nonatomic) IBOutlet UILabel *unUseCodeNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *earnLab;
@property (weak, nonatomic) IBOutlet UILabel *earnRatioLab;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@end
