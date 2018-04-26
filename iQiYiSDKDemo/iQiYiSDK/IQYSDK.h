//
//  IQYSDK.h
//  iQiYiSDKDemo
//
//  Created by miaoshichang on 2018/4/25.
//  Copyright © 2018年 MiaoShichang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IQYUpLoadVideoDataModel.h"


/*******
 说明：1 此SDK只是简单的封装了【爱奇艺】视频托管的接口
      2 此SDK只供参考学习使用，否则后果自负
 
 参考文档：http://static.iqiyi.com/ext/common/%E8%A7%86%E9%A2%91%E4%BA%91%E6%8F%90%E4%BE%9B%E7%AC%AC%E4%B8%89%E6%96%B9%E6%96%B0%E4%B8%8A%E4%BC%A0%E6%96%87%E6%A1%A3v20.pdf
 
 */

@interface IQYSDK : NSObject

+ (instancetype)shareInstance;

- (void)setAppKey:(NSString *)appKey appSecret:(NSString *)appSecret;

/** 上传视频，
 * 注意:不要同一个视频多次上传，如果同一视频上传多次，此函数是可以上传成功的，但是后台会提示视频重复
 */
+ (void)uploadVideo:(IQYUpLoadVideoDataModel *)model block:(void(^)(IQYUpLoadVideoDataModel *data))block;


/** 获取上传视频列表信息
 * 说明：该接口只返回转码完成，并且审核通过，或者先发后审的视频列表信息
 * @param fileIdsArray 为空或者不传，获取用户所有的视频信息
 *
 * @note 返回结果的字段中 fileStaus 字段说明： 1发布中，2已经发布， 3审核未通过，4视频不存在/已删除， 5上传中， 6客户取消上传
 */
+ (void)fetchVideoListForFileIds:(NSArray *)fileIdsArray page:(NSInteger)page block:(void(^)(NSDictionary *result))block;

/** 获取视频状态
 * 获取个人上传视频状态信息
 */
+ (void)fetchVideoInfo:(NSString *)fileId block:(void(^)(NSDictionary *result))block;

/** 获取视频 URL 列表
 * 说明：用于获取视频多格式 url 播放列表
 * 视频格式：
 *   pc端及移动端 m3u8: 96极速，1流畅，2高清，3超清，4（720P），5（1080P）
 *   移动端 mp4: 1 流畅 (200K），2 高清（400K）
 *
 *@note 1、接口返回的 mp4 和 m3u8 地址，都需要带 IP 二次换取播放地址。
 *      2、mp4 和 m3u8 地址都是有有效期的，一般 15 分钟，建议是每次播放前都重新调用接口获取地址。
 */
+ (void)fetchVideoUrl:(NSString *)fileId block:(void(^)(NSDictionary *result))block;

@end


