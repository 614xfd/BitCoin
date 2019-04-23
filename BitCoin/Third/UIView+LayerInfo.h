//
//  UIView+LayerInfo.h
//  ALLibrary-SZiOS
//
//  Created by epro_ios on 2018/11/2.
//  Copyright © 2018年 deng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//IB_DESIGNABLE

@interface UIView (LayerInfo)

/**
 
  * 可视化设置边框宽度
 
  */

@property (nonatomic,assign)IBInspectable CGFloat borderWidth;

/**
 
  * 可视化设置边框颜色
 
  */

@property (nonatomic,strong)IBInspectable UIColor *borderColor;

/**
 
  * 可视化设置圆角
 
  */

@property (nonatomic,assign)IBInspectable CGFloat cornerRadius;

@end

NS_ASSUME_NONNULL_END
