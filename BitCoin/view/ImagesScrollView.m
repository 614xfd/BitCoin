//
//  ScrollView.m
//  newHNW
//
//  Created by hnwlbh on 15/9/24.
//  Copyright © 2015年 hnwlbh. All rights reserved.
//

#import "ImagesScrollView.h"
//#import "UIImageView+WebCache.h"
#import "FLAnimatedImageView+WebCache.h"


#define VIEWWIDTH self.frame.size.width
#define VIEWHEIGHT self.frame.size.height

@implementation ImagesScrollView {
    int _x;
    int _y;
    NSTimer *_timer;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self creatScrollView];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame withImagesArray:(NSArray *)imagesArr isRound:(BOOL)isRound withImageWidth:(double)imageWidth withImageHeight:(double)imageHeight isSmall : (BOOL) isSmall time : (double) time tag:(unsigned long)tag
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.dataArr = imagesArr;
        self.imageHeight = imageHeight;
        self.imageWidth = imageWidth;
        self.isRound = isRound;
        self.isSmall = isSmall;
        self.index = tag;
        self.time = time;
        self.scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, VIEWWIDTH, VIEWHEIGHT)];
        self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0,VIEWHEIGHT-30,VIEWWIDTH,18)];
        [self creatScrollView];
        
    }
    return self;
}

- (void) creatScrollView
{
    self.scroll.pagingEnabled = YES;
    self.scroll.showsVerticalScrollIndicator = NO;
    self.scroll.showsHorizontalScrollIndicator = NO;
    self.scroll.alwaysBounceHorizontal = NO;
    self.scroll.alwaysBounceVertical = NO;
    self.scroll.bounces = YES;
    self.scroll.delegate = self;
    if (self.isSmall) {
        //  两行图片  每行3个
        
        _x = (int)self.dataArr.count/6;
        _y = (int)self.dataArr.count % 6;
        if (_y) {
            _x+=1;
        }
        for (int i = 0; i < _x; i++) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(VIEWWIDTH*(i+1), 0, VIEWWIDTH, VIEWHEIGHT)];
            [self.scroll addSubview:view];
            for (int j = 0; j < 6 && i*6+j <self.dataArr.count; j++) {
                FLAnimatedImageView *img = [[FLAnimatedImageView alloc] init];
                //                img.image = [UIImage imageNamed:[self.dataArr objectAtIndex:i*6+j]];
                [img sd_setImageWithURL:[NSURL URLWithString:[self.dataArr objectAtIndex:i*6+j]]];
                
                if (j < 3) {
                    img.frame = CGRectMake((self.imageWidth+4)*j, 0, self.imageWidth, self.imageHeight);
                } else {
                    img.frame = CGRectMake((self.imageWidth+4)*(j-3), self.imageHeight+8, self.imageWidth, self.imageHeight);
                }
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageClick:)];
                [img addGestureRecognizer:tap];
                
                UIView *tapView = [tap view];
                tapView.tag = i*6+j + 6000;
                
                img.userInteractionEnabled = YES;
                
                if (self.isRound) {
                    [img.layer setMasksToBounds:YES];
                    [img.layer setCornerRadius:10];
                }
                [view addSubview:img];
            }
        }
        if ([self.dataArr count]) {
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, VIEWWIDTH, VIEWHEIGHT)];
            if (!_y) {
                for (int i = 6; i == 0; i--) {
                    FLAnimatedImageView *img = [[FLAnimatedImageView alloc] init];
                    [img sd_setImageWithURL:[NSURL URLWithString:[self.dataArr objectAtIndex:self.dataArr.count-i]]];
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageClick:)];
                    [img addGestureRecognizer:tap];
                    int a = 0;
                    if (i > 3) {
                        img.frame = CGRectMake((self.imageWidth+4)*a, 0, self.imageWidth, self.imageHeight);
                    } else {
                        img.frame = CGRectMake((self.imageWidth+4)*(a-3), self.imageHeight+8, self.imageWidth, self.imageHeight);
                    }
                    a++;
                    UIView *tapView = [tap view];
                    tapView.tag = self.dataArr.count-i + 6000;
                    
                    img.userInteractionEnabled = YES;
                    
                    if (self.isRound) {
                        [img.layer setMasksToBounds:YES];
                        [img.layer setCornerRadius:10];
                    }
                    [view addSubview:img];
                }
            } else {
                for (int i = _y; i == 0; i--) {
                    FLAnimatedImageView *img = [[FLAnimatedImageView alloc] initWithImage:[UIImage imageNamed:[self.dataArr objectAtIndex:self.dataArr.count-i]]];
                    [img sd_setImageWithURL:[NSURL URLWithString:[self.dataArr objectAtIndex:self.dataArr.count-i]]];
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageClick:)];
                    [img addGestureRecognizer:tap];
                    int a = 0;
                    if (i > 3) {
                        img.frame = CGRectMake((self.imageWidth+4)*a, 0, self.imageWidth, self.imageHeight);
                    } else {
                        img.frame = CGRectMake((self.imageWidth+4)*(a-3), self.imageHeight+8, self.imageWidth, self.imageHeight);
                    }
                    a++;
                    UIView *tapView = [tap view];
                    tapView.tag = self.dataArr.count-i + 6000;
                    
                    img.userInteractionEnabled = YES;
                    
                    if (self.isRound) {
                        [img.layer setMasksToBounds:YES];
                        [img.layer setCornerRadius:10];
                    }
                    [view addSubview:img];
                }
                
            }
            [self.scroll addSubview:view];
            
            UIView *v = [[UIView alloc] initWithFrame:CGRectMake(VIEWWIDTH*(_x+1), 0, VIEWWIDTH, VIEWHEIGHT)];
            for (int i = 0; i < 6 && i < self.dataArr.count; i++) {
                FLAnimatedImageView *img = [[FLAnimatedImageView alloc] initWithImage:[UIImage imageNamed:[self.dataArr objectAtIndex:i]]];
                [img sd_setImageWithURL:[NSURL URLWithString:[self.dataArr objectAtIndex:i]]];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageClick:)];
                [img addGestureRecognizer:tap];
                if (i < 3) {
                    img.frame = CGRectMake((self.imageWidth+4)*i, 0, self.imageWidth, self.imageHeight);
                } else {
                    img.frame = CGRectMake((self.imageWidth+4)*(i-3), self.imageHeight+8, self.imageWidth, self.imageHeight);
                }
                UIView *tapView = [tap view];
                tapView.tag = self.dataArr.count-i + 6000;
                
                img.userInteractionEnabled = YES;
                
                if (self.isRound) {
                    [img.layer setMasksToBounds:YES];
                    [img.layer setCornerRadius:10];
                }
                [v addSubview:img];
            }
            [self.scroll addSubview:v];
            
            self.scroll.contentSize = CGSizeMake(VIEWWIDTH*(_x + 2), VIEWHEIGHT);
            [self.scroll setContentOffset:CGPointMake(0, 0)];
            [self.scroll scrollRectToVisible:CGRectMake(VIEWWIDTH,0,VIEWWIDTH, VIEWHEIGHT) animated:NO]; // 默认从序号1位置放第1页 ，序号0位置位置放第4页
        }
        
        
        
    } else {
        for (int i = 0; i < self.dataArr.count; i++) {
            FLAnimatedImageView *img = [[FLAnimatedImageView alloc] initWithFrame:CGRectMake(self.frame.size.width*(i+1), 0, self.frame.size.width, self.scroll.frame.size.height)];
            //            img.image = [UIImage imageNamed:[self.dataArr objectAtIndex:i]];
            NSString *string = [self.dataArr objectAtIndex:i];
            if ([string containsString:@"://"]) {
                [img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",string]]];
            } else {
                [img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_URL,string]]];
            }

//            [img sd_setImageWithURL:[NSURL URLWithString:[self.dataArr objectAtIndex:i]]];
//            img.image = [UIImage imageNamed:[self.dataArr objectAtIndex:i]];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageClick:)];
            [img addGestureRecognizer:tap];
            
            UIView *tapView = [tap view];
            tapView.tag = i + 6000;
            
            img.userInteractionEnabled = YES;
            
            if (self.isRound) {
                [img.layer setMasksToBounds:YES];
                [img.layer setCornerRadius:10];
            }
            [self.scroll addSubview:img];
        }
        if ([self.dataArr count]) {
            // 取数组最后一张图片 放在第0页
            FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
            //        [imageView setImageWithURL:[NSURL URLWithString:[self.MIArr lastObject]] placeholderImage:nil];
            //            imageView.image = [UIImage imageNamed:[self.dataArr lastObject]];
//            [imageView sd_setImageWithURL:[NSURL URLWithString:[self.dataArr lastObject]]];
            NSString *string = [self.dataArr lastObject];
            if ([string containsString:@"://"]) {
                [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",string]]];
            } else {
                [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_URL,string]]];
            }
            imageView.frame = CGRectMake(0, 0,self.frame.size.width,self.scroll.frame.size.height); // 添加最后1页在首页 循环
            if (self.isRound) {
                [imageView.layer setMasksToBounds:YES];
                [imageView.layer setCornerRadius:10];
            }
            [self.scroll addSubview:imageView];
            // 取数组第一张图片 放在最后1页
            imageView = [[FLAnimatedImageView alloc] init];
            //            imageView.image = [UIImage imageNamed:[self.dataArr firstObject]];
//            [imageView sd_setImageWithURL:[NSURL URLWithString:[self.dataArr firstObject]]];
            string = [self.dataArr firstObject];
            if ([string containsString:@"://"]) {
                [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",string]]];
            } else {
                [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_URL,string]]];
            }
            imageView.frame = CGRectMake(self.frame.size.width * (self.dataArr.count + 1) , 0, self.frame.size.width, self.scroll.frame.size.height); // 添加第1页在最后 循环
            if (self.isRound) {
                [imageView.layer setMasksToBounds:YES];
                [imageView.layer setCornerRadius:10];
            }
            [self.scroll addSubview:imageView];
            
            self.scroll.contentSize = CGSizeMake(self.frame.size.width*(self.dataArr.count + 2), self.scroll.frame.size.height);
            [self.scroll setContentOffset:CGPointMake(0, 0)];
            [self.scroll scrollRectToVisible:CGRectMake(VIEWWIDTH,0,VIEWWIDTH, VIEWHEIGHT) animated:NO]; // 默认从序号1位置放第1页 ，序号0位置位置放第4页
        }
    }
    if (self.isSmall) {
        self.pageControl.frame = CGRectMake(0,VIEWHEIGHT-24,VIEWWIDTH,18);
    }
    [self.pageControl setCurrentPageIndicatorTintColor:[UIColor colorWithRed:255/255.0 green:124/255.0 blue:0/255.0 alpha:1]];
    [self.pageControl setPageIndicatorTintColor:[UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1]];
    self.pageControl.numberOfPages = self.dataArr.count;
    if (self.isSmall) {
        if (self.dataArr.count % 6 == 0) {
            self.pageControl.numberOfPages = self.dataArr.count/6;
        } else {
            self.pageControl.numberOfPages = self.dataArr.count/6+1;
        }
    }
    self.pageControl.currentPage = 0;
    [self.pageControl addTarget:self action:@selector(turnPage) forControlEvents:UIControlEventValueChanged]; // 触摸mypag
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:self.time target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
    [self addSubview:self.scroll];
    [self addSubview:self.pageControl];
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_timer invalidate];
    _timer = nil;
}

- (void) scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:self.time target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
}

// scrollview 委托函数
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pagewidth = VIEWWIDTH;
    int page = floor((self.scroll.contentOffset.x - pagewidth/([self.dataArr count]+2))/pagewidth)+1;
    if (self.isSmall) {
        page =  floor((self.scroll.contentOffset.x - pagewidth/(_x+2))/pagewidth)+1;
    }
    page --;  // 默认从第二页开始
    self.pageControl.currentPage = page;
}
// scrollview 委托函数
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pagewidth = VIEWWIDTH;
    int currentPage = floor((self.scroll.contentOffset.x - pagewidth/ ([self.dataArr count]+2)) / pagewidth) + 1;
    //    int currentPage_ = (int)self.scrollView.contentOffset.x/320; // 和上面两行效果一样
    if (currentPage==0) {
        [self.scroll scrollRectToVisible:CGRectMake(VIEWWIDTH * [self.dataArr count], 0, VIEWWIDTH, VIEWHEIGHT) animated:NO]; // 序号0 最后1页
    } else if (currentPage==([self.dataArr count]+1)) {
        [self.scroll scrollRectToVisible:CGRectMake(VIEWWIDTH, 0, VIEWWIDTH, VIEWHEIGHT) animated:NO]; // 最后+1,循环第1页
    }
    if (self.isSmall) {
        
        int currentPage = floor((self.scroll.contentOffset.x - pagewidth/ (_x+2)) / pagewidth) + 1;
        if (currentPage==0) {
            [self.scroll scrollRectToVisible:CGRectMake(VIEWWIDTH * _x, 0, VIEWWIDTH, VIEWHEIGHT) animated:NO]; // 序号0 最后1页
        } else if (currentPage==(_x+1)) {
            [self.scroll scrollRectToVisible:CGRectMake(VIEWWIDTH, 0, VIEWWIDTH, VIEWHEIGHT) animated:NO]; // 最后+1,循环第1页
        }
    }
}

// pagecontrol 选择器的方法
- (void)turnPage
{
    unsigned long page = self.pageControl.currentPage; // 获取当前的page
    [self.scroll scrollRectToVisible:CGRectMake(VIEWWIDTH*(page+1), 0, VIEWWIDTH, VIEWHEIGHT) animated:NO]; // 触摸pagecontroller那个点点 往后翻一页 +1
}

// 定时器 绑定的方法
- (void)runTimePage
{
    
    unsigned long page = self.pageControl.currentPage; // 获取当前的page
    page++;
    if (self.isSmall) {
        page = page > _x - 1 ? 0 : page ;
    } else {
        page = page > (self.dataArr.count - 1) ? 0 : page ;
    }
    self.pageControl.currentPage = page;
    [self turnPage];
}

- (void) ImageClick : (id) sender
{
//    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
//    unsigned long x;
//    x = [tap view].tag - 6000;
//    [self.delegate index:x tag:self.index];
}


@end
