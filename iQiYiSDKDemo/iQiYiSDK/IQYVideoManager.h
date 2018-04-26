//
//  IQYVideoManager.h
//  iQiYiSDKDemo
//
//  Created by miaoshichang on 2018/4/26.
//  Copyright © 2018年 MiaoShichang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface IQYVideoManager : NSObject

+ (void)fetchVideoList:(NSDictionary *)params block:(void(^)(NSDictionary *result))block;


+ (void)fetchVideoInfo:(NSDictionary *)params block:(void(^)(NSDictionary *result))block;


+ (void)fetchVideoUrl:(NSDictionary *)params block:(void(^)(NSDictionary *result))block;

@end
