//
//  ScrollView.h
//  newHNW
//
//  Created by hnwlbh on 15/9/24.
//  Copyright © 2015年 hnwlbh. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "HNWBaseViewController.h"

@protocol ImagesScrollViewDelegate <NSObject>

- (void) index : (unsigned long) index tag : (unsigned long) tag;

@end

@interface ImagesScrollView : UIView <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scroll;
@property (strong,nonatomic)UIPageControl *pageControl;

@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, assign) double imageWidth;
@property (nonatomic, assign) double imageHeight;
@property (nonatomic, assign) BOOL isRound;    //  是否圆角
@property (nonatomic, assign) unsigned long index;
@property (nonatomic, assign) BOOL isSmall;
@property (nonatomic, assign) double time;
@property (nonatomic, strong) id<ImagesScrollViewDelegate> delegate;

-(id) initWithFrame:(CGRect)frame withImagesArray : (NSArray *) imagesArr isRound : (BOOL) isRound withImageWidth : (double) imageWidth withImageHeight : (double) imageHeight isSmall : (BOOL) isSmall time : (double) time tag : (unsigned long) tag;

@end
