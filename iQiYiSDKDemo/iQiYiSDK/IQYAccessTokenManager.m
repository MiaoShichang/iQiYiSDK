//
//  IQYAccessTokenManager.m
//  iQiYiSDKDemo
//
//  Created by miaoshichang on 2018/4/25.
//  Copyright © 2018年 MiaoShichang. All rights reserved.
//

#import "IQYAccessTokenManager.h"

#import "AFNetworking.h"

#import "IQYVideoHelpManager.h"


@interface IQYAccessTokenManager ()

@property (nonatomic, copy)NSString *key;
@property (nonatomic, copy)NSString *secret;

@property (nonatomic, copy)NSString *access_token;
@property (nonatomic, copy)NSString *refresh_token;

@property (nonatomic, assign)NSInteger expires_in;
@property (nonatomic, assign)NSTimeInterval updateTime;


@end


@implementation IQYAccessTokenManager

+ (instancetype)managerWithKey:(NSString *)key withSecret:(NSString *)secret
{
    IQYAccessTokenManager *manager = [[IQYAccessTokenManager alloc]init];
    if (key.length > 0){
        manager.key = key;
    }
    if(secret.length > 0){
        manager.secret = secret;
    }
    
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.key = @"";
        self.secret = @"";
        [self loadData];
    }
    return self;
}

- (void)loadData
{
    NSDictionary *data = [[NSUserDefaults standardUserDefaults]objectForKey:@"IQY_AccessToken_Data"];
    if (data){
        self.access_token = [data objectForKey:@"access_token"];
        self.refresh_token = [data objectForKey:@"refresh_token"];
        self.expires_in = [[data objectForKey:@"expires_in"]integerValue];
        self.updateTime = [[data objectForKey:@"updateTime"]doubleValue];
    }
}

- (void)saveData:(NSDictionary *)data
{
    [[NSUserDefaults standardUserDefaults]setObject:data forKey:@"IQY_AccessToken_Data"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -- 获取 accesstoken
- (void)fetchAccessToken:(void(^)(NSString *accessToken, NSString *msg))Block
{
    NSString *url = @"https://openapi.iqiyi.com/api/iqiyi/authorize";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.key forKey:@"client_id"];
    [params setObject:self.secret forKey:@"client_secret"];
    
    [IQYVideoHelpManager GET:url params:params block:^(NSDictionary *resultData) {
        
        NSString *code = [[resultData objectForKey:@"code"]stringValue];
        if ([code isEqualToString:@"0"])
        {
            NSDictionary *data = [resultData objectForKey:@"data"];
            self.access_token = [data objectForKey:@"access_token"];
            self.refresh_token = [data objectForKey:@"refresh_token"];
            
            self.expires_in = [[data objectForKey:@"expires_in"]integerValue];
            self.updateTime = [[NSDate date]timeIntervalSince1970];
            
            NSMutableDictionary *d = [NSMutableDictionary dictionaryWithDictionary:data];
            [d setObject:@(self.updateTime) forKey:@"updateTime"];
            [self saveData:d];
            
            if (Block){
                Block(self.access_token, [[resultData objectForKey:@"msg"]stringValue]);
            }
        }
        else
        {
            if (Block){
                Block(nil, [[resultData objectForKey:@"msg"]stringValue]);
            }
        }
    }];
}

// 过期时间是30天左右,这只是测试值，具体看官方文档
- (void)updateAccessToken:(void(^)(NSString *accessToken, NSString *msg))Block
{
    NSString *url = @"https://openapi.iqiyi.com/api/oauth2/token";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.key forKey:@"client_id"];
    [params setObject:self.refresh_token forKey:@"refresh_token"];
    [params setObject:@"refresh_token" forKey:@"grant_type"];
    
    
    [IQYVideoHelpManager GET:url params:params block:^(NSDictionary *resultData) {
        
        if(resultData && [resultData isKindOfClass:[NSDictionary class]])
        {
            NSString *code = [[resultData objectForKey:@"code"]stringValue];
            if ([code isEqualToString:@"0"])
            {
                NSDictionary *data = [resultData objectForKey:@"data"];
                self.access_token = [data objectForKey:@"access_token"];
                self.refresh_token = [data objectForKey:@"refresh_token"];
                
                self.expires_in = [[data objectForKey:@"expires_in"]integerValue];
                self.updateTime = [[NSDate date]timeIntervalSince1970];
                
                NSMutableDictionary *d = [NSMutableDictionary dictionaryWithDictionary:data];
                [d setObject:@(self.updateTime) forKey:@"updateTime"];
                [self saveData:d];
                
                if (Block){
                    Block(self.access_token, [[resultData objectForKey:@"msg"]stringValue]);
                }
            }
            else
            {
                if(Block){
                    Block(nil, [[resultData objectForKey:@"msg"]stringValue]);
                }
            }
        }
    }];
}

- (void)getAccessToken:(void(^)(NSString *accessToken, NSString *msg))Block
{
    if (self.access_token.length == 0){
        [self fetchAccessToken:Block];
    }
    else{
        if ([self isExpired]){
            [self updateAccessToken:Block];
        }
        else{
            if(Block){
                Block(self.access_token, @"成功");
            }
        }
    }
}

#pragma mark -- 是否过期
- (BOOL)isExpired
{
    NSTimeInterval current = [[NSDate date]timeIntervalSince1970];
    if ((current - self.updateTime) > self.expires_in){
        return YES;
    }
    
    return NO;
}


@end
