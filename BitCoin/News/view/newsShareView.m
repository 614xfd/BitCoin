//
//  newsShareView.m
//  BitCoin
//
//  Created by LBH on 2018/9/21.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "newsShareView.h"
#define UILABEL_LINE_SPACE 6

@implementation newsShareView

- (instancetype)init{
    
    self = [super init];
    self.backgroundColor = [UIColor whiteColor];
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
    
    UILabel *tiem = [[UILabel alloc] initWithFrame:CGRectMake(15, 300, 375-30, 16)];
    tiem.textColor = [UIColor grayColor];
    tiem.text = [dic objectForKey:@"time"];
    tiem.textAlignment = NSTextAlignmentCenter;
    tiem.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    [self addSubview:tiem];

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 316+20, 375-30, 45)];
    title.textColor = [UIColor blackColor];
    title.text = [dic objectForKey:@"title"];
    title.textAlignment = NSTextAlignmentCenter;
    title.numberOfLines = 2;
    title.font = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
    [self addSubview:title];
    
    UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(15, 316+20+15+45, 375-30, 20)];
    content.textColor = [UIColor blackColor];
    content.text = [dic objectForKey:@"content"];
    content.numberOfLines = 0;
    content.textAlignment = NSTextAlignmentCenter;
    content.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    [self addSubview:content];

    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentCenter;
    paraStyle.lineSpacing = UILABEL_LINE_SPACE; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *d = @{NSFontAttributeName:content.font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f};
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:content.text attributes:d];
    content.attributedText = attributeStr;

    CGFloat f = [self getSpaceLabelHeight:content.text withFont:content.font withWidth:content.frame.size.width];
    content.frame = CGRectMake(content.frame.origin.x, content.frame.origin.y, content.frame.size.width, f);
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, content.frame.origin.y+content.frame.size.height+30, 375, 155)];
    view.backgroundColor = [UIColor colorWithRed:15/255.0 green:57/255.0 blue:138/255.0 alpha:1];
    [self addSubview:view];
    
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 200, 90)];
    logo.image = [UIImage imageNamed:@"logo.png"];
    [view addSubview:logo];
    
    UIImageView *code = [[UIImageView alloc] initWithFrame:CGRectMake(375-50-15, 15, 90, 90)];
    code.image = [UIImage imageNamed:@"WechatIMG2210.png"];
    [view addSubview:code];
    
    UIImageView *share = [[UIImageView alloc] initWithFrame:CGRectMake(15, 90+15+15, 20, 20)];
    share.image = [UIImage imageNamed:@"分享 (3).png"];
    [view addSubview:share];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(4, 90+15+15, 200, 20)];
    lab.textColor = [UIColor whiteColor];
    lab.text = @"文章转载自金色财经";
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
    [view addSubview:lab];
    
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(375-15-100, 90+15+15, 100, 20)];
    l.textColor = [UIColor whiteColor];
    l.text = @"扫码下载小蚂蚁";
    l.textAlignment = NSTextAlignmentCenter;
    l.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
    [view addSubview:l];
    
    self.frame = CGRectMake(0, 0, 375, view.frame.size.height+view.frame.origin.y);
}

-(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = UILABEL_LINE_SPACE;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f};
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
