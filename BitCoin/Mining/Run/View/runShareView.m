//
//  runShareView.m
//  BitCoin
//
//  Created by LBH on 2018/9/7.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "runShareView.h"
#import "CreatQRCode.h"

@implementation runShareView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle] loadNibNamed:@"runShareView" owner:self options:nil] lastObject];
    if (self) {
        self.frame = frame;
    }
    return self;
}

- (void) creatInfoWithDic:(NSDictionary *)dic
{
    self.shareImageView.image = [CreatQRCode qrImageForString:[NSString stringWithFormat:@"http://www.bitboss.vg/regist.html?code=%@", [dic objectForKey:@"code"]] imageSize:self.shareImageView.frame.size.width logoImageSize:0];
    self.phoneLabel.text = [self numberSuitScanf:[dic objectForKey:@"phone"]];
    self.dateLabel.text = [NSString stringWithFormat:@"BitBoss·运动挖矿%@", [dic objectForKey:@"date"]];
    self.KMLabel.text = [dic objectForKey:@"KM"];
    self.stepLabel.text = [dic objectForKey:@"step"];
    self.coinLabel.text = [dic objectForKey:@"coin"];
}

-(NSString *)numberSuitScanf:(NSString*)number
{
    if (number.length>10) {
        NSString *numberString = [number stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        return numberString;
    }
    return number;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
