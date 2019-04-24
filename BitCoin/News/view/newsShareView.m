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
    self.date.text = [dic objectForKey:@"time"];
    self.newsTitle.text = [dic objectForKey:@"title"];
    self.content.text = [dic objectForKey:@"content"];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
