//
//  newsShareView.m
//  BitCoin
//
//  Created by LBH on 2018/9/21.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "newsShareView.h"

@implementation newsShareView

- (instancetype)init{
    
    self = [super init];
    return self;
}

- (void) setInfo:(NSDictionary *)dic
{
//    self.date.text = [dic objectForKey:@"time"];
//    self.newsTitle.text = [dic objectForKey:@"title"];
//    self.content.text = [dic objectForKey:@"content"];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 375, 280)];
    imageView.image = [UIImage imageNamed:@"cylc_bg.jpg"];
    [self addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 375, 40)];
    label.center = imageView.center;
    label.textColor = [UIColor whiteColor];
    label.text = @"最新资讯";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:32 weight:UIFontWeightBold];
    [self addSubview:label];
    
    self.frame = CGRectMake(0, 0, 375, imageView.frame.size.height);
    
//    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
//    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
//    paraStyle.alignment = NSTextAlignmentCenter;
//    paraStyle.hyphenationFactor = 1.0;
//    paraStyle.firstLineHeadIndent = 0.0;
//    paraStyle.paragraphSpacingBefore = 0.0;
//    paraStyle.headIndent = 0;
//    paraStyle.tailIndent = 0;
//    //设置字间距 NSKernAttributeName:@1.5f
//    NSDictionary *dic = @{NSFontAttributeName:self.titleLabel.font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f};
//    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:@"小蚂蚁" attributes:dic];
//    self.titleLabel.attributedText = attributeStr;
//
//    CGFloat f = [self getSpaceLabelHeight:str withFont:content.font withWidth:content.frame.size.width];
//    content.frame = CGRectMake(content.frame.origin.x, content.frame.origin.y, content.frame.size.width, f);

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
