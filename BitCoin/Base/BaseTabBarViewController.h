//
//  BaseTabBarViewController.h
//  BitCoin
//
//  Created by LBH on 2017/9/28.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTabBarViewController : UITabBarController

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *homeBtn;
@property (nonatomic, strong) UIButton *storeBtn;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) UIButton *friendBtn;
@property (nonatomic, strong) UIButton *askBtn;
@property (nonatomic, strong) UIButton *travelBtn;
@property (nonatomic, strong) UIButton *wayBtn;
@property (nonatomic, strong) UIButton *myBtn;

@end
