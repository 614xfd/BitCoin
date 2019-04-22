//
//  CustomAlertView.h
//  BitCoin
//
//  Created by LBH on 2017/9/29.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomAlertDelegate <NSObject>

- (void) returnSelectDic : (NSDictionary *)dic;

@end

@interface CustomAlertView : UIView <UIPickerViewDelegate, UIPickerViewDataSource, UIAlertViewDelegate, CustomAlertDelegate>

@property (nonatomic, assign) id <CustomAlertDelegate> delegate;

- (id) initWithFrame:(CGRect)frame andDataArray:(NSArray *)array;

@end
