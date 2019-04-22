//
//  NetworkTool.h
//  BitCoin
//
//  Created by LBH on 2017/9/22.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void (^CallBackSucceed)(id JSON,NSString *stringData);
typedef void (^CallBlockFailure)(NSError *error);

@interface NetworkTool: AFHTTPSessionManager

@property (nonatomic, strong)CallBackSucceed completeBlock;
@property (nonatomic, strong)CallBlockFailure failed;

/**
 创建网络请求工具类的单例
 */
+ (instancetype)sharedTool;

/**
 创建请求方法
 */
- (void)requestWithURLString: (NSString *)URLString
                  parameters: (NSDictionary *)parameters
                      method: (NSString *)method
                    completed:(CallBackSucceed )completedBlock
                      failed:(CallBlockFailure )failed;

- (void)requestWithHPURLString: (NSString *)URLString
                  parameters: (NSDictionary *)parameters
                      method: (NSString *)method
                   completed:(CallBackSucceed )completedBlock
                      failed:(CallBlockFailure )failed;
@end
