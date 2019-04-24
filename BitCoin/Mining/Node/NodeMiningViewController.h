//
//  NodeMiningViewController.h
//  BitCoin
//
//  Created by LBH on 2018/8/20.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "BaseViewController.h"

@interface NodeMiningViewController : BaseViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

//@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
//@property (weak, nonatomic) IBOutlet UILabel *lineBGLabel;
//@property (weak, nonatomic) IBOutlet UILabel *lineBGLabel1;
//@property (weak, nonatomic) IBOutlet UIView *activationView;
//@property (weak, nonatomic) IBOutlet UIButton *bgBtn;
//@property (weak, nonatomic) IBOutlet UITextField *codeFT;
//@property (weak, nonatomic) IBOutlet UITextField *numTF;
@property (weak, nonatomic) IBOutlet UILabel *earningLab;
@property (weak, nonatomic) IBOutlet UILabel *earningRatioLab;

@property (weak, nonatomic) IBOutlet UITableView *resultTableView;


@property (weak, nonatomic) IBOutlet UIScrollView *buyBScrollView;//未购买时显示
@property (weak, nonatomic) IBOutlet UIView *dustView;  //蒙尘
@property (weak, nonatomic) IBOutlet UIView *buyTipView;//购买弹窗view

@property (weak, nonatomic) IBOutlet UILabel *tipLab1;
@property (weak, nonatomic) IBOutlet UILabel *tipLab2;
@property (weak, nonatomic) IBOutlet UILabel *tipLab3;

@property (weak, nonatomic) IBOutlet UIView *payView;//支付密码弹窗
@property (weak, nonatomic) IBOutlet UILabel *payLab;


@property (weak, nonatomic) IBOutlet UIButton *bgBtn;


@property (nonatomic, assign) BOOL isSuperNode;                 //超级d节点

@end
