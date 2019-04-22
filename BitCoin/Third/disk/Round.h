//
//  Round.h
//  calculate
//
//  Created by LBH on 2018/7/4.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Round : UIView

@property (nonatomic,assign) CGFloat percent;
@property (nonatomic,strong) CAShapeLayer *bottomShapeLayer; // 外圆的底层layer
@property (nonatomic,strong)CAShapeLayer *upperShapeLayer;  // 外圆的更新的layer
@property (nonatomic,strong)CAShapeLayer *updatedShapeLayer;  // 外圆的更新的layer
@property (nonatomic,assign)CGFloat startAngle;  // 开始的弧度
@property (nonatomic,assign)CGFloat endAngle;  // 结束的弧度
@property (nonatomic,assign)CGFloat radius; // 开始角度
@property (nonatomic,assign)CGFloat progressRadius; // 外层的开始角度
@property (nonatomic,assign)CGFloat centerX;
@property (nonatomic,assign)CGFloat centerY;
@property (nonatomic,strong)UILabel *progressView;
@property (nonatomic,assign) int ratio;
@property (nonatomic, assign) double inCome;



@end
