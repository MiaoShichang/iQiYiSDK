//
//  IQYUpLoadVideoDataModel.m
//  iQiYiSDKDemo
//
//  Created by miaoshichang on 2018/4/25.
//  Copyright © 2018年 MiaoShichang. All rights reserved.
//

#import "IQYUpLoadVideoDataModel.h"

@implementation IQYUpLoadVideoDataModel

- (NSString *)range
{
    return [NSString stringWithFormat:@"0-%@", self.video_size];
}


- (NSDictionary *)metaData
{
    NSMutableDictionary *meta = [NSMutableDictionary dictionary];
    if(self.access_token.length > 0){
        [meta setObject:self.access_token forKey:@"access_token"];
    }
    
    if(self.file_id.length > 0){
        [meta setObject:self.file_id forKey:@"file_id"];
    }
    
    if(self.video_name.length > 0){
        [meta setObject:self.video_name forKey:@"file_name"];
    }
    
    if (self.video_description.length > 0){
        [meta setObject:self.video_description forKey:@"description"];
    }
    
    if(self.video_tags.length > 0){
        [meta setObject:self.video_tags forKey:@"tags"];
    }
    
    if(self.video_type.length > 0){
        [meta setObject:self.video_type forKey:@"file_type"];
    }
    
    return meta;
}

- (BOOL)validate
{
    NSString *msg = @"error:";
    
    if (self.video_extension.length == 0)
    {
        msg = [NSString stringWithFormat:@"%@[video_extensionn is nil]", msg];
    }
    
    if (self.video_size.length == 0)
    {
        msg = [NSString stringWithFormat:@"%@[video_size is nil]", msg];
    }
    
    if (self.video_data.length == 0)
    {
        msg = [NSString stringWithFormat:@"%@[video_data is nil]", msg];
    }
    
    if (self.video_name.length == 0)
    {
        msg = [NSString stringWithFormat:@"%@[video_name is nil]", msg];
    }
    
    if (self.video_description.length == 0)
    {
        msg = [NSString stringWithFormat:@"%@[video_description is nil]", msg];
    }
    
    if ([msg isEqualToString:@"error:"])
    {
        self.code = 0;
        return YES;
    }
    else
    {
        self.code = 100;
        self.msg = msg;
        return NO;
    }
}

@end
