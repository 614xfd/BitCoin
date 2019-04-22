//
//  bluetooth.h
//  BitCoin
//
//  Created by LBH on 2018/8/11.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@protocol BlueDelegate <NSObject>

@optional
- (void) stepNumber:(int)num;
- (void) linkSuccess;
- (void) linkOut;

@end

@interface bluetooth : NSObject <CBCentralManagerDelegate,CBPeripheralDelegate, BlueDelegate>

@property (nonatomic, weak) id <BlueDelegate> delegate;

- (void) resetBluetooth : (NSString *)string;

- (instancetype)initWithMac : (NSString *)string;

- (void) sendOrder;


@end
