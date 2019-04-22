//
//  runShareView.h
//  BitCoin
//
//  Created by LBH on 2018/9/7.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface runShareView : UIView
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *KMLabel;
@property (weak, nonatomic) IBOutlet UILabel *stepLabel;
@property (weak, nonatomic) IBOutlet UILabel *coinLabel;
@property (weak, nonatomic) IBOutlet UIImageView *shareImageView;


- (void) creatInfoWithDic:(NSDictionary *)dic;

@end
