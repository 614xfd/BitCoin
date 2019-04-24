//
//  newsShareView.h
//  BitCoin
//
//  Created by LBH on 2018/9/21.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface newsShareView : UIView
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *newsTitle;
@property (weak, nonatomic) IBOutlet UILabel *content;

- (void) setInfo:(NSDictionary *) dic;

@end
