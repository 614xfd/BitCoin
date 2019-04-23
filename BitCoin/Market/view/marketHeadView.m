//
//  marketHeadView.m
//  BitCoin
//
//  Created by LBH on 2018/9/14.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "marketHeadView.h"

#define kScaleH (kScreenHeight/667.0)
#define kScaleW (kScreenWidth/375.0)

@implementation marketHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle] loadNibNamed:@"marketHeadView" owner:self options:nil] lastObject];
    if (self) {
        self.frame = frame;
//        self.scale = 1.0;
//        if ([UIScreen mainScreen].bounds.size.height == 736) {
//            self.scale = 1.103;
//        } else if ([UIScreen mainScreen].bounds.size.height == 480) {
//            self.scale = 0.7196;
//        } else if ([UIScreen mainScreen].bounds.size.height == 568) {
//            self.scale = 0.851;
//        }
        self.line.frame = CGRectMake(self.line.frame.origin.x, self.line.frame.origin.y, self.line.frame.size.width, 0.5);
        [self requestImage];
    }
    return self;
}

- (void) requestImage
{
    __weak __typeof(self) weakSelf = self;
    [[NetworkTool sharedTool] requestWithURLString:@"home/carousel/get" parameters:nil method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@", stringData, JSON );
        //        NSString *isError = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            //                        [weakSelf verifyPass];
            NSArray *array = [JSON objectForKey:@"data"];
            NSMutableArray *arr = [NSMutableArray array];
            for (int i = 0; i < array.count; i++) {
                NSString *str = [NSString stringWithFormat:@"%@%@", [[array objectAtIndex:i] objectForKey:@"url"], [[array objectAtIndex:i] objectForKey:@"mallImage"]];
                [arr addObject:str];
            }
            weakSelf.imageArray = [NSArray arrayWithArray:array];
            [weakSelf performSelectorOnMainThread:@selector(creatImageWith:) withObject:[NSArray arrayWithArray:arr] waitUntilDone:YES];
        } else {
            
        }
    } failed:^(NSError *error) {
        //        [weakSelf requestError];
    }];
}

- (void) creatImageWith : (NSArray *)arr
{
    self.adsScrollView = [[ImagesScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.imagesView.frame.size.height) withImagesArray:arr isRound:NO withImageWidth:self.frame.size.width withImageHeight:self.imagesView.frame.size.height isSmall : NO time:5.0 tag:100];
    self.adsScrollView.tag = 100;
    self.adsScrollView.delegate = self;
    [self.imagesView addSubview:self.adsScrollView];
}

- (IBAction)QRCodeBtnClick:(id)sender {
    [self.delegate intoQRCode];
}

- (IBAction)inComeBtnClick:(id)sender {
    [self.delegate intoCoinInCome];
}

- (IBAction)sendBtnClick:(id)sender {
    [self.delegate intoCoinSend];
}

- (IBAction)announcementBtnClick:(id)sender {
    [self.delegate intoAnnouncement];
}

- (IBAction)holdBtnClick:(id)sender {
    [self.delegate intohold];
}

- (IBAction)nodeBtnClick:(id)sender {
    [self.delegate intoNode];
}

- (IBAction)cloudBtnClick:(id)sender {
    [self.delegate intoCloud];
}

- (IBAction)moreBtnClick:(id)sender {
    [self.delegate more];
}

#pragma mark  循环scroll广告点击事件跳转
- (void) index:(unsigned long)index tag:(unsigned long)tag
{
    NSString *string;
    if (tag == 100) {
        NSLog(@"1 : %ld, tag = %ld",index, tag);
        [self.delegate intoVC:index];
//        string = [[self.imageArray objectAtIndex:index] objectForKey:@"url"];
    }
//    if (![string isEqualToString:@"0"] && string.length) {
//        [self.delegate intoWebViewWith:string];
//    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
