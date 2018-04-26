//
//  IQYVideoHelpManager.h
//  iQiYiSDKDemo
//
//  Created by miaoshichang on 2018/4/26.
//  Copyright © 2018年 MiaoShichang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IQYVideoHelpManager : NSObject

+ (void)GET:(NSString *)url params:(NSDictionary *)params block:(void(^)(NSDictionary *))block;


+ (NSDictionary *)resutlWithCode:(NSInteger)code msg:(NSString *)msg data:(id)data;


@end
