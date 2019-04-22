//
//  Round.m
//  calculate
//
//  Created by LBH on 2018/7/4.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "Round.h"

#define degreesToRadians(x) (M_PI*(x)/180.0) //把角度转换成PI的方式

static CGFloat  lineWidth = 20;   // 线宽
static CGFloat  progressLineWidth = 3;  // 外圆进度的线宽

@implementation Round
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
        [self  drawLayers];
        
    }
    
    return self;
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        
        [self drawLayers];
        
    }
    return self;
}

- (void)drawLayers
{
//        self.backgroundColor = [UIColor blackColor];
    
    self.backgroundColor = [UIColor clearColor];
    _startAngle = - 230;  // 启始角度
    _endAngle = 55;  // 结束角度
    
    _centerX = self.frame.size.width / 2;  // 控制圆盘的X轴坐标
    _centerY = self.frame.size.height / 2  + 20; // 控制圆盘的Y轴坐标
    
    _radius = (self.bounds.size.width - 100 - lineWidth) / 2;  // 内圆的角度
    _progressRadius = (self.bounds.size.width - 100 - progressLineWidth + 30) / 2; // 外圆的角度
    
    [self drawBottomLayer];  // 绘制底部灰色填充layer
    [self drawUpperLayer]; // 绘制底部进度显示 layer
    [self drawGradientLayer];  // 绘制颜色渐变 layer
    [_bottomShapeLayer addSublayer:_updatedShapeLayer]; // 将进度layer 添加到 底部layer 上
    [_updatedShapeLayer setMask:_upperShapeLayer]; // 设置进度layer 颜色
    [self.layer addSublayer:_bottomShapeLayer];  // 添加到底层的layer 上
    [self addSubview:self.progressView];
}

- (UILabel *)progressView
{
    if (!_progressView) {
        
        _progressView = [[UILabel alloc]init];
        
        CGFloat width = 160;
        CGFloat height = 60;
        _progressView.frame = CGRectMake((self.frame.size.width - width) / 2, _centerY - height / 2, width, height);
        UIFont *font = [UIFont fontWithName:@"Brandon Grotesque" size:60];
        _progressView.font = font;

        //        _progressView.backgroundColor = [UIColor greenColor];
        _progressView.textAlignment = NSTextAlignmentCenter;
        _progressView.textColor = [UIColor colorWithRed:193/255.0 green:169/255.0 blue:107/255.0 alpha:1];
        _progressView.text = @"0";
    }
    
    return _progressView;
}


// 绘制底部的layer
- (CAShapeLayer *)drawBottomLayer
{
    _bottomShapeLayer                 = [[CAShapeLayer alloc] init];
    _bottomShapeLayer.frame           = self.bounds;
    
    
    UIBezierPath *path                = [UIBezierPath bezierPathWithArcCenter:CGPointMake(_centerX, _centerY) radius:_radius startAngle:degreesToRadians(_startAngle) endAngle:degreesToRadians(_endAngle) clockwise:YES];
    
    
    _bottomShapeLayer.path            = path.CGPath;
    _bottomShapeLayer.lineCap = kCALineCapButt;
    _bottomShapeLayer.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:6], nil];
    _bottomShapeLayer.lineWidth = lineWidth;
    _bottomShapeLayer.strokeColor     = [UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1].CGColor;
    _bottomShapeLayer.fillColor       = [UIColor clearColor].CGColor;
    return _bottomShapeLayer;
}


// 绘制进度的layer
- (CAShapeLayer *)drawUpperLayer
{
    _upperShapeLayer                 = [[CAShapeLayer alloc] init];
    _upperShapeLayer.frame           = self.bounds;
    
    UIBezierPath *path                = [UIBezierPath bezierPathWithArcCenter:CGPointMake(_centerX, _centerY) radius:_radius  startAngle:degreesToRadians(_startAngle) endAngle:degreesToRadians(_endAngle) clockwise:YES];
    
    _upperShapeLayer.path            = path.CGPath;
    _upperShapeLayer.strokeStart = 0;
    _upperShapeLayer.strokeEnd =   0;
    //    [self performSelector:@selector(shapeChange) withObject:nil afterDelay:0.3];
    _upperShapeLayer.lineWidth = lineWidth;
    _upperShapeLayer.lineCap = kCALineCapButt;
    _upperShapeLayer.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:6], nil];
    _upperShapeLayer.strokeColor     = [UIColor redColor].CGColor;
    _upperShapeLayer.fillColor       = [UIColor clearColor].CGColor;
    
    
    return _upperShapeLayer;
}

//  绘制变色的layer
- (CAShapeLayer *)drawGradientLayer
{
    _updatedShapeLayer                 = [[CAShapeLayer alloc] init];
    _updatedShapeLayer.frame           = self.bounds;
    
    
    UIBezierPath *path                = [UIBezierPath bezierPathWithArcCenter:CGPointMake(_centerX, _centerY) radius:_radius startAngle:degreesToRadians(_startAngle) endAngle:degreesToRadians(_endAngle) clockwise:YES];
    
    
    _updatedShapeLayer.path            = path.CGPath;
    _updatedShapeLayer.lineCap = kCALineCapButt;
    _updatedShapeLayer.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:6], nil];
    _updatedShapeLayer.lineWidth = lineWidth;
    _updatedShapeLayer.strokeColor     = [UIColor colorWithRed:193/255.0 green:169/255.0 blue:107/255.0 alpha:1].CGColor;
    _updatedShapeLayer.fillColor       = [UIColor clearColor].CGColor;
    return _updatedShapeLayer;
}


@synthesize percent = _percent;
- (CGFloat )percent
{
    return _percent;
}
- (void)setPercent:(CGFloat)percent
{
    self.inCome = percent*100;
    _percent = percent;
    if (percent > 1) {
        percent = 1;
    } else if (percent < 0){
        percent = 0;
    }
    self.ratio = percent * 100;
    [self performSelector:@selector(shapeChange) withObject:nil afterDelay:0];
}

- (void)shapeChange
{
    
    // 复原
    [CATransaction begin];
    [CATransaction setDisableActions:NO];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [CATransaction setAnimationDuration:0];
    _upperShapeLayer.strokeEnd = 0 ;
    
    [CATransaction commit];
    
    [CATransaction begin];
    [CATransaction setDisableActions:NO];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [CATransaction setAnimationDuration:2.f];
    _upperShapeLayer.strokeEnd = _percent;;
    [CATransaction commit];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:_percent * 0.02 target:self selector:@selector(updateLabl:) userInfo:nil repeats:YES];
    
}

- (void)updateLabl:(NSTimer *)sender
{
    static double flag = 0;
    if (flag   == self.ratio) {
        [sender invalidate];
        sender = nil;
        self.progressView.text = [NSString stringWithFormat:@"%.2lf",self.inCome];
        flag = 0;
    } else {
        self.progressView.text = [NSString stringWithFormat:@"%.2lf",self.inCome];
    }
    flag ++;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
