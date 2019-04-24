//
//  payPasswordView.h
//  BitCoin
//
//  Created by CCC on 2019/4/24.
//  Copyright © 2019年 LBH. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol payPasswordViewDelegate <NSObject>

@optional
- (void) returnPayPassword:(NSString *)string;

@end

NS_ASSUME_NONNULL_BEGIN

@interface payPasswordView : UIView <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *payNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *payNumLabel;

@property (nonatomic, weak) id<payPasswordViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
