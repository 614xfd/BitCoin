//
//  ToastView.m
//  BitCoin
//
//  Created by LBH on 2017/9/26.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import "ToastView.h"

@implementation ToastView

- (instancetype)initWithFrame:(CGRect)frame WithMessage:(NSString *)str
{
    self = [super initWithFrame:frame];
    if (self) {
        CGSize titleSize = [str boundingRectWithSize:CGSizeMake(self.frame.size.width-50, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
        
        UILabel *toast = [[UILabel alloc] initWithFrame:CGRectMake(25, (frame.size.height-70)/2, self.frame.size.width-50, titleSize.height+30)];
        toast.text = str;
        toast.font = [UIFont systemFontOfSize:14];
        toast.textAlignment = NSTextAlignmentCenter;
        toast.textColor = [UIColor whiteColor];
        toast.backgroundColor = [UIColor blackColor];
        toast.alpha = 0.5;
        toast.layer.cornerRadius = 4;
        toast.layer.masksToBounds = YES;
        toast.numberOfLines = 0;
        toast.lineBreakMode = NSLineBreakByCharWrapping;
        [self addSubview:toast];
        [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(warnDisappear) userInfo:nil repeats:NO];
    }
    return self;
}

- (void)warnDisappear
{
    [self removeFromSuperview];
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
