//
//  IQYUploadVideoManager.h
//  iQiYiSDKDemo
//
//  Created by miaoshichang on 2018/4/25.
//  Copyright © 2018年 MiaoShichang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IQYUpLoadVideoDataModel.h"

@interface IQYUploadVideoManager : NSObject

+ (void)uploadVideo:(IQYUpLoadVideoDataModel *)model block:(void(^)(IQYUpLoadVideoDataModel *data))block;

@end
