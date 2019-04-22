//
//  PayViewController.h
//  BitCoin
//
//  Created by LBH on 2018/7/12.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "BaseViewController.h"

@interface PayViewController : BaseViewController <UITextFieldDelegate>//<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
//@property (weak, nonatomic) IBOutlet UILabel *numLabel;
//@property (weak, nonatomic) IBOutlet UIImageView *payImageView;
//@property (weak, nonatomic) IBOutlet UIButton *reSelectBtn;
//@property (weak, nonatomic) IBOutlet UIImageView *bigImage;
//@property (weak, nonatomic) IBOutlet UILabel *bgLabel;
//@property (weak, nonatomic) IBOutlet UIButton *bgBtn;
//@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
//
//@property (nonatomic, strong) NSString *idString;


@property (weak, nonatomic) IBOutlet UILabel *orderIdLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *tipMoneyLab;
@property (weak, nonatomic) IBOutlet UIView *tipView;
@property (weak, nonatomic) IBOutlet UIView *dustView;

@property (nonatomic, strong)NSString *idString;
@property (nonatomic, strong)NSString *money;

@end
