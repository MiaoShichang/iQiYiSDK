//
//  IQYVideoManager.m
//  iQiYiSDKDemo
//
//  Created by miaoshichang on 2018/4/26.
//  Copyright © 2018年 MiaoShichang. All rights reserved.
//

#import "IQYVideoManager.h"
#import "IQYVideoHelpManager.h"

@interface IQYVideoManager ()

@end


@implementation IQYVideoManager

+ (void)fetchVideoList:(NSDictionary *)params block:(void(^)(NSDictionary *result))block
{
    NSString *url = @"http://openapi.iqiyi.com/api/file/videoListForExternal";
    [IQYVideoHelpManager GET:url params:params block:block];
}

+ (void)fetchVideoInfo:(NSDictionary *)params block:(void(^)(NSDictionary *result))block
{
    NSString *url = @"http://openapi.iqiyi.com/api/file/fullStatus";
    [IQYVideoHelpManager GET:url params:params block:block];
}

+ (void)fetchVideoUrl:(NSDictionary *)params block:(void(^)(NSDictionary *result))block
{
    NSString *url = @"http://openapi.iqiyi.com/api/file/urllist";
    [IQYVideoHelpManager GET:url params:params block:block];
}

@end
