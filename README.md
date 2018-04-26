# iQiYiSDK
爱奇艺 视频托管接口封装，此SDK只是个人封装，非官方SDK，仅供参考学习。

## 【注册key secret】
    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
        // Override point for customization after application launch.
        
        //注册key secret
        [[IQYSDK shareInstance]setAppKey:kQIYIAppKey appSecret:kQIYIAppSecret];
        
        return YES;
    }
    

### 【上传视频】
    NSString* srcPath = [[NSBundle  mainBundle] pathForResource:@"test" ofType:@"mp4"];
    NSData *fileData = [NSData dataWithContentsOfFile:srcPath];
    IQYUpLoadVideoDataModel *model = [[IQYUpLoadVideoDataModel alloc]init];

    model.video_size = [NSString stringWithFormat:@"%ld", fileData.length];
    model.video_extension = @"mp4";
    model.video_data = fileData;
    model.video_name = @"音乐视频";
    model.video_description = @"测试视频测试视频测试视频测试视频测试视频";
    model.video_tags = @"音乐";
    model.video_type = @"6";
    
    [IQYSDK uploadVideo:model block:^(IQYUpLoadVideoDataModel *data){
        NSLog(@"【上传视频】%@", data.msg);
    }];


### 【获取视频列表】

1    获取指定fileid 的视频列表

    [IQYSDK fetchVideoListForFileIds:@[self.fileId] page:1 block:^(NSDictionary *result) {
        NSLog(@"【获取视频列表】 %@", result);
    }];

//2 获取所有的视频列表

    [IQYSDK fetchVideoListForFileIds:nil page:1 block:^(NSDictionary *result) {
        NSLog(@"【获取视频列表】 %@", result);
    }];


### 【获取视频信息】

    [IQYSDK fetchVideoInfo:self.fileId block:^(NSDictionary *result) {
        NSLog(@"【获取视频信息】%@", result);
    }];


### 【获取视频链接】

    [IQYSDK fetchVideoUrl:self.fileId block:^(NSDictionary *result) {
        NSLog(@"【获取视频链接】%@", result);
    }];
