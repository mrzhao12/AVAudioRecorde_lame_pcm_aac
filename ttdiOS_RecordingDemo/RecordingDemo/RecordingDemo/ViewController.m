//
//  ViewController.m
//  RecordingDemo
//
//  Created by C2B_Charming on 16/5/18.
//  Copyright © 2016年 C2B_Charming. All rights reserved.
//

#import "ViewController.h"
#import "MBProgressHUD+MJ.h"
#import "AudioTool2.h"
#import "MBProgressHUD+MJ.h"

@interface ViewController ()<AudioToolDelegate>
//录音按钮
@property (weak, nonatomic) IBOutlet UIButton *recordingBtn;

@property(nonatomic,strong)AudioTool2 *audioTool2;

@property(nonatomic,strong)AVAudioRecorder *recorder;

@property(nonatomic,strong)NSString *filePath;

@property(nonatomic,strong)AVAudioPlayer *player;

@end

@implementation ViewController

-(NSString *)filePath{
    if (!_filePath) {
        _filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        _filePath = [_filePath stringByAppendingPathComponent:@"audio"];
    }
    
    return _filePath;
}

-(AudioTool2 *)audioTool2{
    if (!_audioTool2) {
        _audioTool2 = [AudioTool2 new];
        _audioTool2.audioToolDelegate = self;
    }
    
    return _audioTool2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.recordingBtn setTitle:@"按住说话" forState:UIControlStateNormal];
    [self.recordingBtn setTitle:@"松手录音完毕,除出按钮取消录音" forState:UIControlStateHighlighted];
    
    [self.recordingBtn addTarget:self action:@selector(recordingBtnDown:) forControlEvents:UIControlEventTouchDown];
    [self.recordingBtn addTarget:self action:@selector(recordingBtnInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.recordingBtn addTarget:self action:@selector(recordingBtnInside:) forControlEvents:UIControlEventTouchUpOutside];
    
}

-(void)recordingBtnDown:(UIButton *)send{
    NSLog(@"按下");

    self.recorder = [self.audioTool2 getRecorfer:@"test"];
    [self.recorder record];
}

-(void)recordingBtnInside:(id)send{
    NSLog(@"抬起");
    
    if ([self.recorder isRecording]) {
        [self.recorder stop];
    }
    
}

//合成
- (IBAction)synchronise:(id)sender {
    NSLog(@"合成");
    
    NSString *file1 = [self.filePath stringByAppendingPathComponent:@"new.mp3"];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:file1] ) {
        NSString *file2 = [[NSBundle mainBundle] pathForResource:@"A1" ofType:@".mp3"];
        
        [self.audioTool2 synthesisWithSouceFilePath:file1 desFilePath:file2];
        
    }else{
        [MBProgressHUD showError:@"还没录音呢"];
    }
    
}

//播放录音
- (IBAction)playRecord:(id)sender {
    NSLog(@"播放录音");
    
    NSString *file1 = [self.filePath stringByAppendingPathComponent:@"new.mp3"];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:file1]) {

        self.player = [self.audioTool2 getRecorferPlayer];
        [self.player play];
        
    }else{
        [MBProgressHUD showError:@"录音文件不存在"];
    }
    
    
    
}

//播放合成音
- (IBAction)playResultFile:(id)sender {
    NSLog(@"播放合成音");
    
    NSString *file1 = [self.filePath stringByAppendingPathComponent:@"synthesis.mp3"];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:file1]) {
        
        self.player = [self.audioTool2 getSynthesisPlayer];
        [self.player play];
        
    }else{
        [MBProgressHUD showError:@"合成文件不存在"];
    }
    
}

//停止播放
- (IBAction)stopPlay:(id)sender {
    NSLog(@"停止播放");
    
    [self.player stop];
    
}

- (IBAction)cleanFile:(id)sender {
    NSLog(@"清空文件");
    
    NSString *file1 = self.filePath;
    
    NSFileManager *manager = [NSFileManager defaultManager];

    if ([manager fileExistsAtPath:file1]) {
        [manager removeItemAtPath:file1 error:nil];
    }else{
        [MBProgressHUD showError:@"文件已清空"];
    }

}

#pragma mark 转换的回调
-(void)statrPCMtoMP3{
    [MBProgressHUD showMessage:@"正在转换...."];
}

-(void)endPCMtoMP3{
    [MBProgressHUD hideHUD];
}

-(void)startSynthesis{
    [MBProgressHUD showMessage:@"正在合成...."];
}

-(void)endSynthesis{
    [MBProgressHUD hideHUD];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
