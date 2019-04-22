//
//  RealNameViewController.h
//  BitCoin
//
//  Created by LBH on 2017/11/2.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import "BaseViewController.h"

@protocol RealNameDelegate <NSObject>

- (void) resetMessage:(NSString *)string;

@end

@interface RealNameViewController : BaseViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) id <RealNameDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *IDLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *numberTF;
@property (weak, nonatomic) IBOutlet UIButton *frontBtn;
@property (weak, nonatomic) IBOutlet UIButton *contraryBtn;
@property (weak, nonatomic) IBOutlet UILabel *frontTF;
@property (weak, nonatomic) IBOutlet UILabel *contraryTF;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
//@property (nonatomic, strong) UIImage *i;
//@property (nonatomic, strong) UIView *bgView;

@end
