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

//必填 扩展名（mp4）
@property (nonatomic, copy)NSString *video_extension;

//必填
@property (nonatomic, copy)NSString *video_size;

//必填
@property (nonatomic, strong)NSData *video_data;

//必填 -- 视频名称
@property (nonatomic, copy)NSString *video_name;

// 必填 -- 视频描述
@property (nonatomic, copy)NSString *video_description;

// 选填 -- 用户自定义标签，如"青春、搞笑"等等【以半角逗号分隔】
@property (nonatomic, copy)NSString *video_tags;

/** 选填 -- 分类 id
  *
  * '1' => '电影','2' => '电视剧','3' => '纪录片','4' => '动漫','5' => '音乐','6' => '综艺',
  * '7' => '娱乐','8' => '游戏','9' => '旅游','10' => '片花','12' => '教育','13' => '时尚',
  * '15' => '少儿','16' => '微电影','17' => '体育','20' => '广告','21' => '生活','22' => '搞笑',
  * '24' => '财经','25' => '资讯','26' => '汽车','27' => '原创','28' => '军事' ...
 */
@property (nonatomic, copy)NSString *video_type;





// 每一步的结果信息
@property (nonatomic, assign)NSInteger code; // 0 成功 ，非0  失败
@property (nonatomic, copy)NSString *msg;


- (BOOL)validate;

@end
