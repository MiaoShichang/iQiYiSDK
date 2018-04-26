//
//  IQYUploadVideoManager.m
//  iQiYiSDKDemo
//
//  Created by miaoshichang on 2018/4/25.
//  Copyright © 2018年 MiaoShichang. All rights reserved.
//

#import "IQYUploadVideoManager.h"
#import "AFNetworking.h"

@implementation IQYUploadVideoManager

#pragma mark -- 1 获取file_id
+ (void)fetchFileIdWith:(IQYUpLoadVideoDataModel *)model block:(void(^)(IQYUpLoadVideoDataModel *model))block
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager .requestSerializer setValue:model.video_extension forHTTPHeaderField:@"filetype"];
    [manager .requestSerializer setValue:model.video_size forHTTPHeaderField:@"filesize"];
    [manager .requestSerializer setValue:model.access_token forHTTPHeaderField:@"access_token"];
    
    [manager GET:@"http://upload.iqiyi.com/openupload" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(!block){
            return;
        }
        
        if (responseObject == nil){
            block ([self resultCode:10001 msg:@"结果返回为空" model:model]);
        }
        else
        {
            NSError *error;
            NSDictionary *resultData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
            
            if (error){
                block ([self resultCode:10002 msg:@"返回数据结构不是JSON" model:model]);
            }
            else
            {
                if(resultData && [resultData isKindOfClass:[NSDictionary class]])
                {
                    NSString *code = [resultData objectForKey:@"code"];
                    if ([code isEqualToString:@"A00000"])
                    {
                        NSDictionary *data = [resultData objectForKey:@"data"];
                        model.upload_url = [data objectForKey:@"upload_url"];
                        model.file_id = [data objectForKey:@"file_id"];
                        model.code = 0;
                        model.msg = @"获取file_di成功";

                        block(model);
                    }
                    else
                    {
                        NSString *msg = [resultData objectForKey:@"msg"];
                        if (msg.length == 0){
                            msg = [self msgByCode:code];
                        }
                        
                        block([self resultCode:10003 msg:msg model:model]);
                    }
                }
                else
                {
                    if (block){
                        block([self resultCode:10004 msg:@"返回数据结构不是JSON" model:model]);
                    }
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block){
            model.code = 10005;
            model.msg = @"网络错误";
            block (model);
        }
    }];
}


#pragma mark -- 2 上传文件数据
+ (void)updataFileData:(IQYUpLoadVideoDataModel *)model block:(void(^)(IQYUpLoadVideoDataModel *model))block
{
    //
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager .requestSerializer setValue:model.file_id forHTTPHeaderField:@"file_id"];
    [manager .requestSerializer setValue:model.video_size forHTTPHeaderField:@"file_size"];
    [manager .requestSerializer setValue:model.range forHTTPHeaderField:@"range"];
    
    [manager POST:model.upload_url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        // 设置时间格式
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString  stringWithFormat:@"%@.%@", dateString,model.video_extension];
        
        [formData appendPartWithFileData:model.video_data name:@"upload" fileName:fileName mimeType:@"video/mpeg4"];
        //
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"uploadProgress -- %@", uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject == nil){
            if (block){
                model.code = 20001;
                model.msg = @"结果返回为空";
                block (model);
            }
        }
        else
        {
            NSError *error;
            NSDictionary *resultData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
            
            if (error){
                if (block){
                    model.code = 20002;
                    model.msg = @"返回数据结构不是JSON";
                    block (model);
                }
            }
            else
            {
                if(resultData && [resultData isKindOfClass:[NSDictionary class]])
                {
                    NSString *code = [resultData objectForKey:@"code"];
                    if ([code isEqualToString:@"A00000"])
                    {
                        model.range_md5 = [resultData objectForKey:@"range_md5"];
                        model.file_range_accepted = [[resultData objectForKey:@"file_range_accepted"]stringValue];
//                        model.file_id = [resultData objectForKey:@"file_id"];   // 目前不需要
                        
                        model.code = 0;
                        model.msg = @"上传文件成功";
                        if (block){
                            block(model);
                        }
                    }
                    else
                    {
                        if(block){
                            NSString *msg = [resultData objectForKey:@"msg"];
                            model.code = 20004;
                            if (msg.length == 0){
                                [self msgByCode:code];
                            }
                            model.msg = msg;
                            block(model);
                        }
                    }
                }
                else
                {
                    if (block){
                        model.code = 20003;
                        model.msg = @"返回数据结构不是JSON";
                        block (model);
                    }
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block){
            model.code = 20005;
            model.msg = @"网络错误";
            block (model);
        }
    }];
}

#pragma mark -- 3 通知上传完成
+ (void)uploadFinish:(IQYUpLoadVideoDataModel *)model block:(void(^)(IQYUpLoadVideoDataModel *model))block
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager .requestSerializer setValue:@"true" forHTTPHeaderField:@"range_finished"];
    [manager .requestSerializer setValue:model.access_token forHTTPHeaderField:@"access_token"];
    [manager .requestSerializer setValue:model.file_id forHTTPHeaderField:@"file_id"];
    
    NSString *url = @"http://upload.iqiyi.com/uploadfinish";
    
    [manager POST:url parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject == nil){
            if (block){
                model.code = 30001;
                model.msg = @"结果返回为空";
                block (model);
            }
        }
        else
        {
            NSError *error;
            NSDictionary *resultData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
            
            if (error){
                if (block){
                    model.code = 30002;
                    model.msg = @"返回数据结构不是JSON";
                    block (model);
                }
            }
            else
            {
                if(resultData && [resultData isKindOfClass:[NSDictionary class]])
                {
                    NSString *code = [resultData objectForKey:@"code"];
                    if ([code isEqualToString:@"A00000"])
                    {
                        model.code = 0;
                        model.msg = @"通知上传完成";
                        if (block){
                            block(model);
                        }
                    }
                    else
                    {
                        if(block){
                            NSString *msg = [resultData objectForKey:@"msg"];
                            model.code = 30004;
                            if (msg.length == 0){
                                [self msgByCode:code];
                            }
                            model.msg = msg;
                            block(model);
                        }
                    }
                }
                else
                {
                    if (block){
                        model.code = 30003;
                        model.msg = @"返回数据结构不是JSON";
                        block (model);
                    }
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block){
            model.code = 30005;
            model.msg = @"网络错误";
            block (model);
        }
    }];
}

#pragma mark -- 4 取消上传



#pragma mark -- 5 上传文件 meta 信息接口
+ (void)uploadFileMeta:(IQYUpLoadVideoDataModel *)model block:(void(^)(IQYUpLoadVideoDataModel *model))block
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *url = @"http://openapi.iqiyi.com/api/file/info";  //?access_token=ACCESS_TOKEN&file_id=FILE_ID&file_name=FILE_NAME&description=DESC";
    
    [manager GET:url parameters:model.metaData progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject == nil){
            if (block){
                model.code = 50001;
                model.msg = @"结果返回为空";
                block (model);
            }
        }
        else
        {
            NSError *error;
            NSDictionary *resultData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
            
            if (error){
                if (block){
                    model.code = 50002;
                    model.msg = @"返回数据结构不是JSON";
                    block (model);
                }
            }
            else
            {
                if(resultData && [resultData isKindOfClass:[NSDictionary class]])
                {
                    NSString *code = [resultData objectForKey:@"code"];
                    if ([code isEqualToString:@"A00000"])
                    {
                        model.code = 0;
                        model.msg = @"上传meta完成";
                        if (block){
                            block(model);
                        }
                    }
                    else
                    {
                        if(block){
                            NSString *msg = [resultData objectForKey:@"msg"];
                            model.code = 50004;
                            if (msg.length == 0){
                                [self msgByCode:code];
                            }
                            model.msg = msg;
                            block(model);
                        }
                    }
                }
                else
                {
                    if (block){
                        model.code = 50003;
                        model.msg = @"返回数据结构不是JSON";
                        block (model);
                    }
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block){
            model.code = 50005;
            model.msg = @"网络错误";
            block (model);
        }
    }];
}

#pragma mark -- test
+ (void)uploadVideo:(IQYUpLoadVideoDataModel *)model block:(void(^)(IQYUpLoadVideoDataModel *data))block
{
    if (![model validate])
    {
        if (block)
        {
            block(model);
        }
        
        return;
    }
    
    [self fetchFileIdWith:model block:^(IQYUpLoadVideoDataModel *model) { //  获取file_id
        if (model.code == 0)
        {
            [self updataFileData:model block:^(IQYUpLoadVideoDataModel *model) {  // 上传文件
                if (model.code == 0)
                {
                    [self uploadFileMeta:model block:^(IQYUpLoadVideoDataModel *model) {  // 上传文件的元信息
                        if (model.code == 0)
                        {
                            [self uploadFinish:model block:^(IQYUpLoadVideoDataModel *model) { // 通知上传文件完成
                                if (model.code == 0)
                                {
                                    block(model);
                                }
                                else
                                {
                                    block(model);
                                }
                            }];
                        }
                        else
                        {
                            block(model);
                        }
                    }];
                }
                else
                {
                    block(model);
                }
            }];
        }
        else
        {
            block(model);
        }
    }];
    
    
}

+ (NSString *)msgByCode:(NSString *)code
{
    if ([code isEqualToString:@"A00000"]){
        return @"成功";
    }
    else if([code isEqualToString:@"Q00001"]){
        return @"失败";
    }
    else if([code isEqualToString:@"A00007"]){
        return @"系统错误";
    }
    else if([code isEqualToString:@"A21324"]){
        return @"client_id 或 client_secret 参数无效";
    }
    
    return @"返回结果出错";
}

+ (IQYUpLoadVideoDataModel *)resultCode:(NSInteger)code msg:(NSString *)msg model:(IQYUpLoadVideoDataModel *)model
{
    if (model){
        model.code = code;
        model.msg = msg;
    }
    
    return model;
}

@end
