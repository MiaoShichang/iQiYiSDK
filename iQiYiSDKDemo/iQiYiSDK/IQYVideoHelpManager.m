//
//  IQYVideoHelpManager.m
//  iQiYiSDKDemo
//
//  Created by miaoshichang on 2018/4/26.
//  Copyright © 2018年 MiaoShichang. All rights reserved.
//

#import "IQYVideoHelpManager.h"
#import "AFNetworking.h"

@implementation IQYVideoHelpManager

#pragma mark -- helper
+ (void)GET:(NSString *)url params:(NSDictionary *)params block:(void(^)(NSDictionary *))block
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (!block){
            return;
        }
        
        if (responseObject == nil){
            block ([self resutlWithCode:10001 msg:@"结果返回为空" data:nil]);
        }
        else
        {
            NSError *error;
            NSDictionary *resultData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
            
            if (error){
                block ([self resutlWithCode:10002 msg:@"返回数据结构不是JSON" data:nil]);
            }
            else
            {
                if(resultData && [resultData isKindOfClass:[NSDictionary class]])
                {
                    NSString *code = [resultData objectForKey:@"code"];
                    if ([code isEqualToString:@"A00000"])
                    {
                        id data = [resultData objectForKey:@"data"];
                        block ([self resutlWithCode:0 msg:@"成功" data:data]);
                    }
                    else
                    {
                        NSString *msg = [resultData objectForKey:@"msg"];
                        if (msg.length == 0){
                            msg = @"状态错误";
                        }
                        block ([self resutlWithCode:10003 msg:msg data:nil]);
                    }
                }
                else
                {
                    block ([self resutlWithCode:10004 msg:@"返回数据结构不是JSON" data:nil]);
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block){
            block ([self resutlWithCode:20000 msg:@"网络错误" data:nil]);
        }
    }];
}

+ (NSDictionary *)resutlWithCode:(NSInteger)code msg:(NSString *)msg data:(id)data
{
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [result setObject:@(code) forKey:@"code"];
    
    if (msg.length > 0){
        [result setObject:msg forKey:@"msg"];
    }
    
    if(data){
        [result setObject:data forKey:@"data"];
    }
    
    return result;
}

@end
