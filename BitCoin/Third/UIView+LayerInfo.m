//
//  UIView+LayerInfo.m
//  ALLibrary-SZiOS
//
//  Created by epro_ios on 2018/11/2.
//  Copyright © 2018年 deng. All rights reserved.
//

#import "UIView+LayerInfo.h"

@implementation UIView (LayerInfo)

/**
 
  * 设置边框宽度
 
  */
- (void)setBorderWidth:(CGFloat)borderWidth {
    if(borderWidth <0) return;
    self.layer.borderWidth = borderWidth;
}

/**
 
  * 设置边框颜色
 
  */
- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

/**
 
  *  设置圆角
 
  */
- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = cornerRadius >0;
}
@end
