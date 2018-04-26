//
//  ViewController.m
//  iQiYiSDKDemo
//
//  Created by miaoshichang on 2018/4/25.
//  Copyright © 2018年 MiaoShichang. All rights reserved.
//

#import "ViewController.h"

#import "IQYSDK.h"

@interface ViewController ()

@property (nonatomic, strong)UITextView *textView;
@property (nonatomic, copy)NSString *fileId;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CGFloat width = (self.view.bounds.size.width-30)/2.f;
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(10,44, width, 44);
    btn1.backgroundColor = [UIColor orangeColor];
    [btn1 addTarget:self action:@selector(btn1Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setTitle:@"上传视频" forState:UIControlStateNormal];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(10+(width+10)*1,44, width, 44);
    btn2.backgroundColor = [UIColor orangeColor];
    [btn2 addTarget:self action:@selector(btn2Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 setTitle:@"获取视频列表" forState:UIControlStateNormal];
    [self.view addSubview:btn2];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame = CGRectMake(10+(width+10)*0,90, width, 44);
    btn3.backgroundColor = [UIColor orangeColor];
    [btn3 addTarget:self action:@selector(btn3Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn3 setTitle:@"获取视频信息" forState:UIControlStateNormal];
    [self.view addSubview:btn3];
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn4.frame = CGRectMake(10+(width+10)*1,90, width, 44);
    btn4.backgroundColor = [UIColor orangeColor];
    [btn4 addTarget:self action:@selector(btn4Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn4 setTitle:@"获取视频链接" forState:UIControlStateNormal];
    [self.view addSubview:btn4];

    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 140, self.view.bounds.size.width-20, self.view.bounds.size.height-150)];
    [self.view addSubview:self.textView];
    self.textView.editable = NO;

}

- (void)btn1Clicked:(UIButton *)btn
{
    NSString* srcPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
    NSData *fileData = [NSData dataWithContentsOfFile:srcPath];
    
    IQYUpLoadVideoDataModel *model = [[IQYUpLoadVideoDataModel alloc]init];
    model.video_size = [NSString stringWithFormat:@"%ld", fileData.length];
    model.video_extension = @"mp4";
    model.video_data = fileData;
    model.video_name = @"音乐视频";
    model.video_description = @"测试视频测试视频测试视频测试视频测试视频";
    
    model.video_tags = @"音乐";
    model.video_type = @"6";
    
    [IQYSDK uploadVideo:model block:^(IQYUpLoadVideoDataModel *data) {
        NSLog(@"【上传视频】%@", data.msg);
        [self addMsg:[NSString stringWithFormat:@"【上传视频】%@",data.msg]];
        self.fileId = data.file_id;
    }];
}

- (void)btn2Clicked:(UIButton *)btn
{
    //1 获取指定fileid 的视频列表
//    if (self.fileId.length == 0)
//    {
//        NSLog(@"请先上传视频");
//        [self addMsg:[NSString stringWithFormat:@"【获取视频列表】%@",@"请先上传视频"]];
//        return;
//    }
//
//    [IQYSDK fetchVideoListForFileIds:@[self.fileId] page:1 block:^(NSDictionary *result) {
//        NSLog(@"【获取视频列表】 %@", result);
//        [self addMsg:[NSString stringWithFormat:@"【获取视频列表】\n%@",result]];
//    }];
    
    //2 获取所有的视频列表
    [IQYSDK fetchVideoListForFileIds:nil page:1 block:^(NSDictionary *result) {
        NSLog(@"【获取视频列表】 %@", result);
        [self addMsg:[NSString stringWithFormat:@"【获取视频列表】\n%@",result]];
    }];
}

- (void)btn3Clicked:(UIButton *)btn
{
    if (self.fileId.length == 0)
    {
        NSLog(@"请先上传视频");
        [self addMsg:[NSString stringWithFormat:@"【获取视频信息】%@",@"请先上传视频"]];
        return;
    }
    
    [IQYSDK fetchVideoInfo:self.fileId block:^(NSDictionary *result) {
        NSLog(@"【获取视频信息】%@", result);
        [self addMsg:[NSString stringWithFormat:@"【获取视频信息】\n%@",result]];
    }];
}

- (void)btn4Clicked:(UIButton *)btn
{
    if (self.fileId.length == 0)
    {
        NSLog(@"请先上传视频");
        [self addMsg:[NSString stringWithFormat:@"【获取视频链接】%@",@"请先上传视频"]];
        return;
    }
    
    [IQYSDK fetchVideoUrl:self.fileId block:^(NSDictionary *result) {
        NSLog(@"【获取视频链接】%@", result);
        [self addMsg:[NSString stringWithFormat:@"【获取视频链接】\n%@",result]];
    }];
}

- (void)addMsg:(id)msg
{
    NSString *msgString = [NSString stringWithFormat:@"%@\n%@\n********************************", self.textView.text, msg];
    self.textView.text = msgString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
