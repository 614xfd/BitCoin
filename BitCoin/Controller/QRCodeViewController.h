//
//  QRCodeViewController.h
//  newHNW
//
//  Created by hnwlbh on 16/6/8.
//  Copyright © 2016年 hnwlbh. All rights reserved.
//

#import "BaseViewController.h"
@class QRCodeViewController;

@protocol QRCodeViewControllerDelegate <NSObject>

//- (void) intoViewController : (NSDictionary *)dic;
//- (void)gotoAdsView:(UIViewController *)view;
- (void) returnString : (NSString *) string;

@end

@interface QRCodeViewController : BaseViewController

@property (nonatomic, assign) id <QRCodeViewControllerDelegate> delegate;

@property (nonatomic, assign) BOOL isCode;

@end
