//
//  MCCatchRedPacketController.m
//  MCCatchRedPacket
//
//  Created by MC on 16/10/29.
//  Copyright © 2016年 MC. All rights reserved.
//

#import "MCCatchRedPacketController.h"
#import "MCCatchView.h"
#import "YGGravity.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreMotion/CoreMotion.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <SceneKit/SceneKit.h>

@interface MCCatchRedPacketController () <SCNSceneRendererDelegate, MCCatchViewDelegate> {

    SCNVector3 forwardDirectionVector;

    UIView *_bgview;
    SCNView *_scnView;
    MCCatchView *imageView;
}
/**
 *  AVCaptureSession对象来执行输入设备和输出设备之间的数据传递
 */
@property (nonatomic, strong) AVCaptureSession *session;
/**
 *  提供来自设备的数据
 */
@property (nonatomic, strong) AVCaptureDeviceInput *videoInput;
/**
 *  用于捕捉静态图片
 */
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;
/**
 *  用于自动显示相机产生的实时图像,它拥有 session (outputs 被 session 所拥有)
 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@end

@implementation MCCatchRedPacketController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAVCaptureSession];
    [self.session startRunning];
    [self intView];

    // Do any additional setup after loading the view.
}

- (void)intView {
    _bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _bgview.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_bgview];

    [self addImgview];

    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 40 - 10, 30, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"btn_close_normal"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(actionBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [_bgview addSubview:backBtn];
}

- (void)addImgview {
    imageView = [[MCCatchView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    imageView.delegate = self;
    [imageView prepareData:nil];

    [_bgview addSubview:imageView];

    [imageView startAnimate];
}

- (void)initAVCaptureSession {

    self.session = [[AVCaptureSession alloc] init];

    NSError *error;

    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];

    //更改这个设置的时候必须先锁定设备，修改完后再解锁，否则崩溃
    [device lockForConfiguration:nil];
    //设置闪光灯为自动
    //    [device setFlashMode:AVCaptureFlashModeAuto];
    [device unlockForConfiguration];

    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
    if (error) {
        NSLog(@"%@", error);
    }
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    //输出设置。AVVideoCodecJPEG   输出jpeg格式图片
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];

    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    if ([self.session canAddOutput:self.stillImageOutput]) {
        [self.session addOutput:self.stillImageOutput];
    }

    //初始化预览图层
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];

    //    NSLog(@"%f",kMainScreenWidth);
    self.previewLayer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view.layer addSublayer:self.previewLayer];
    //    UIView * view  =[[UIView alloc]initWithFrame:CGRectMake(-300, 10, 320*3, 20)];
    //    view.backgroundColor = [UIColor redColor];
    //    [_previewLayer addSubview:view.layer];
}

#pragma mark - MCCatchViewDelegate
- (void)catchRedPacket {
    [self actionBackBtn];
}

- (void)actionBackBtn {
    [self.session stopRunning];
    [imageView.timer invalidate];
    imageView.timer = nil;
    [imageView stopAnimate];
    [imageView.myImageView removeFromSuperview];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
