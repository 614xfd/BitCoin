//
//  CreatQRCode.h
//  BitCoin
//
//  Created by LBH on 2017/9/30.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreatQRCode : UIImageView

+ (UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)Imagesize logoImageSize:(CGFloat)waterImagesize;

@end
