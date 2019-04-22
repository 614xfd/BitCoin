//
//  MiningHPViewController.h
//  BitCoin
//
//  Created by LBH on 2017/9/29.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MiningHPViewController : BaseViewController <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UILabel *difficultyLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sumLabel;
@property (weak, nonatomic) IBOutlet UILabel *validLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;

@end
