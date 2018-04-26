//
//  IQYUpLoadVideoDataModel.h
//  iQiYiSDKDemo
//
//  Created by miaoshichang on 2018/4/25.
//  Copyright © 2018年 MiaoShichang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IQYUpLoadVideoDataModel : NSObject

//注意： 下面的属性不要赋值，下面的属性不要赋值，下面的属性不要赋值
@property (nonatomic, copy)NSString *access_token;
@property (nonatomic, copy)NSString *file_id;
@property (nonatomic, copy)NSString *upload_url;
@property (nonatomic, strong, readonly)NSString *range;
@property (nonatomic, copy)NSString *range_md5;
@property (nonatomic, copy)NSString *file_range_accepted;
@property (nonatomic, strong,readonly)NSDictionary *metaData;


// 设置下面关于要上传视频的属性
@property (nonatomic, copy)NSString *video_extension; //扩展名 必填（mp4）
@property (nonatomic, copy)NSString *video_size; //必填
@property (nonatomic, strong)NSData *video_data; //必填
@property (nonatomic, copy)NSString *video_name; // 必填
@property (nonatomic, copy)NSString *video_description; //必填
@property (nonatomic, copy)NSString *video_tags; // 选填
@property (nonatomic, copy)NSString *video_type;// 选填




// 每一步的结果信息
@property (nonatomic, assign)NSInteger code; // 0 成功 ，非0  失败
@property (nonatomic, copy)NSString *msg;


- (BOOL)validate;

@end
