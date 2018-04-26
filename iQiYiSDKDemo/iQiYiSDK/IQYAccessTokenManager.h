//
//  IQYAccessTokenManager.h
//  iQiYiSDKDemo
//
//  Created by miaoshichang on 2018/4/25.
//  Copyright © 2018年 MiaoShichang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IQYAccessTokenManager : NSObject

+ (instancetype)managerWithKey:(NSString *)key withSecret:(NSString *)secret;

- (void)getAccessToken:(void(^)(NSString *accessToken, NSString *errorMsg))Block;

@end
