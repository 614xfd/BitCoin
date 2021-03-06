//
//  BaseViewController.h
//  BitCoin
//
//  Created by LBH on 2017/9/27.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import <CommonCrypto/CommonDigest.h>
#import "payPasswordView.h"

#define kScaleH                   (kScreenHeight/667.0)
#define kScaleW                  (kScreenWidth/375.0)

@interface BaseViewController : UIViewController <payPasswordViewDelegate>

//@property (nonatomic, assign)  CGFloat scale;
@property (nonatomic, strong) NSString *payPasswordString;

- (void) setBarBlackColor : (BOOL) isBlack;

- (NSString *)md5:(NSString *)str;

- (void) requestError;

- (void) showToastWithMessage : (NSString *)string;

- (BOOL)inputShouldNumber:(NSString *)inputString;//  判断是否纯数字

- (BOOL)inputShouldLetter:(NSString *)inputString;//  判断是否纯英文

- (void) tokenError;

-(NSString *)getTimeTimestamp;

- (void) showService;

- (void) shareImageViewWithView:(UIView *)view;

- (void) inputPayPasswordWithPayTip:(NSString *)tip andPrice:(NSString *)price;

@end
