//
//  IQYSDK.m
//  iQiYiSDKDemo
//
//  Created by miaoshichang on 2018/4/25.
//  Copyright © 2018年 MiaoShichang. All rights reserved.
//

#import "IQYSDK.h"

#import "IQYAccessTokenManager.h"
#import "IQYUploadVideoManager.h"
#import "IQYVideoManager.h"

@interface IQYSDK()
@property (nonatomic, strong)IQYAccessTokenManager *manager;
@end

@implementation IQYSDK

+ (instancetype)shareInstance
{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}


- (void)setAppKey:(NSString *)appKey appSecret:(NSString *)appSecret
{
    self.manager = [IQYAccessTokenManager managerWithKey:appKey withSecret:appSecret];
}

+ (void)uploadVideo:(IQYUpLoadVideoDataModel *)model block:(void(^)(IQYUpLoadVideoDataModel *data))block
{
    [[IQYSDK shareInstance].manager getAccessToken:^(NSString *accessToken, NSString *errorMsg) {
        model.access_token = accessToken;
        [IQYUploadVideoManager uploadVideo:model block:block];
    }];
}

+ (void)fetchVideoListForFileIds:(NSArray *)fileIdsArray page:(NSInteger)page block:(void(^)(NSDictionary *result))block
{
    [[IQYSDK shareInstance].manager getAccessToken:^(NSString *accessToken, NSString *errorMsg) {
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        if (accessToken.length > 0){
            [params setObject:accessToken forKey:@"access_token"];
        }
        
        if (fileIdsArray.count > 0){
            NSString *idsString = [fileIdsArray componentsJoinedByString:@","];
            [params setObject:idsString forKey:@"file_ids"];
        }
        else{
            [params setObject:@"" forKey:@"file_ids"];
        }
        
        [params setObject:@(page) forKey:@"page"];
        [params setObject:@(20) forKey:@"page_size"];
        
        [IQYVideoManager fetchVideoList:params block:block];
    }];
    
}

+ (void)fetchVideoInfo:(NSString *)fileId block:(void(^)(NSDictionary *result))block
{
    if (fileId.length == 0){
        if(block){
            block(@{@"code":@"100", @"msg":@"fileId is nil"});
        }
        return;
    }
    
    [[IQYSDK shareInstance].manager getAccessToken:^(NSString *accessToken, NSString *errorMsg) {
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        if (accessToken.length > 0){
            [params setObject:accessToken forKey:@"access_token"];
        }
        
        [params setObject:fileId forKey:@"file_id"];
        
        [IQYVideoManager fetchVideoInfo:params block:block];
    }];
}

+ (void)fetchVideoUrl:(NSString *)fileId block:(void(^)(NSDictionary *result))block
{
    if (fileId.length == 0){
        if(block){
            block(@{@"code":@"100", @"msg":@"fileId is nil"});
        }
        return;
    }
    
    [[IQYSDK shareInstance].manager getAccessToken:^(NSString *accessToken, NSString *errorMsg) {
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        if (accessToken.length > 0){
            [params setObject:accessToken forKey:@"access_token"];
        }
        
        [params setObject:fileId forKey:@"file_id"];
        
        [IQYVideoManager fetchVideoUrl:params block:block];
    }];
}

@end
