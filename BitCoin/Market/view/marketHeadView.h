//
//  marketHeadView.h
//  BitCoin
//
//  Created by LBH on 2018/9/14.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImagesScrollView.h"

@protocol marketHeadViewDelegate <NSObject>

- (void) intoWebViewWith:(NSString *)string;
- (void) intoQRCode;
- (void) intoCoinInCome;
- (void) intoCoinSend;
- (void) intoAnnouncement;
- (void) intohold;
- (void) intoNode;
- (void) intoCloud;
- (void) more;

@end

@interface marketHeadView : UIView <ImagesScrollViewDelegate>

@property (nonatomic, weak) id <marketHeadViewDelegate> delegate;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) ImagesScrollView *adsScrollView;
//@property (nonatomic, assign)  CGFloat scale;
@property (weak, nonatomic) IBOutlet UIView *imagesView;
@property (weak, nonatomic) IBOutlet UILabel *line;

- (void) requestImage;

@end
