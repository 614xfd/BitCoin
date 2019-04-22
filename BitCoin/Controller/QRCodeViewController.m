//
//  QRCodeViewController.m
//  newHNW
//
//  Created by hnwlbh on 16/6/8.
//  Copyright © 2016年 hnwlbh. All rights reserved.
//

#import "QRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ScanResultViewController.h"

//#import "AppDelegate.h"

#define AUTH_ALERT_TAG (int)281821
#define  ScreenHeight  [UIScreen mainScreen].bounds.size.height
#define  ScreenWidth   [UIScreen mainScreen].bounds.size.width
@interface QRCodeViewController () <AVCaptureMetadataOutputObjectsDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate> {
    AVCaptureSession * session;//输入输出的中间桥梁
    int line_tag;
    UIView *highlightView;
    NSTimer *_timer;
    BOOL _isBack;
    BOOL _isOpen;
}

@end

@implementation QRCodeViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    
    NSArray *array=self.tabBarController.view.subviews;
    
    for (UIView *view in array) {
        if (view.tag == 10086) {
            view.hidden = YES;
        }
    }
    [session startRunning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isBack = NO;
//    [self hiddenCustomView];
    [self instanceDevice];

    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        if (!granted) {
            
        }
    }];
}

/**
 *  @author Whde
 *
 *  配置相机属性
 */
- (void)instanceDevice{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    line_tag = 1872637;
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //初始化链接对象
    session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    if (input) {
        [session addInput:input];
    }
    if (output) {
        [session addOutput:output];
        //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
        NSMutableArray *a = [[NSMutableArray alloc] init];
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode]) {
            [a addObject:AVMetadataObjectTypeQRCode];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN13Code]) {
            [a addObject:AVMetadataObjectTypeEAN13Code];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN8Code]) {
            [a addObject:AVMetadataObjectTypeEAN8Code];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeCode128Code]) {
            [a addObject:AVMetadataObjectTypeCode128Code];
        }
        output.metadataObjectTypes=a;
    }
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    
    [self setOverlayPickerView];
    
    [session addObserver:self forKeyPath:@"running" options:NSKeyValueObservingOptionNew context:nil];
    
    //开始捕获
    [session startRunning];
}

/**
 *  @author Whde
 *
 *  监听扫码状态-修改扫描动画
 *
 *  @param keyPath
 *  @param object
 *  @param change
 *  @param context
 */
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context{
    if ([object isKindOfClass:[AVCaptureSession class]]) {
        BOOL isRunning = ((AVCaptureSession *)object).isRunning;
        if (isRunning) {
            [self addAnimation];
        }else{
            [self removeAnimation];
        }
    }
}

/**
 *  @author Whde
 *
 *  获取扫码结果
 *
 *  @param captureOutput
 *  @param metadataObjects
 *  @param connection
 */
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        [session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex :0];
        
        //输出扫描字符串
        NSString *data = metadataObject.stringValue;
        [self.delegate returnString:data];
        if (self.isCode) {
            [self.navigationController popViewControllerAnimated:YES];
        }
//        ScanResultViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"scabresultVC"];
//        vc.text = data;
//        [self.navigationController pushViewController:vc animated:YES];
        
//        AdsViewController *vc = [[AdsViewController alloc] init];
//        vc.delegate = self;
//        [self parseAds:[vc stringParse:data]];
        //        [vc returnDictionary:^(NSDictionary *dic) {
        //            [self returnDictionary:dic];
        //        }];
        //        NSMutableDictionary *dic = [AdsViewController stringParse:data];
    }
}

/**
 *  @author Whde
 *
 *  未识别(其他)的二维码提示点击"好",继续扫码
 *
 *  @param alertView
 */
- (void)alertViewCancel:(UIAlertView *)alertView{
    [session startRunning];
}

/**
 *  @author Whde
 *
 *  didReceiveMemoryWarning
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 *  @author Whde
 *
 *  创建扫码页面
 */
- (void)setOverlayPickerView
{
    //左侧的view
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, ScreenHeight)];
    leftView.alpha = 0.5;
    leftView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:leftView];
    //右侧的view
    UIImageView *rightView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-50, 0, 50, ScreenHeight)];
    rightView.alpha = 0.5;
    rightView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:rightView];
    
    //最上部view
    UIImageView* upView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 0, ScreenWidth-100, (self.view.center.y-(ScreenWidth-100)/2))];
    upView.alpha = 0.5;
    upView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:upView];
    
    //底部view
    UIImageView * downView = [[UIImageView alloc] initWithFrame:CGRectMake(50, (self.view.center.y+(ScreenWidth-100)/2), (ScreenWidth-100), (ScreenHeight-(self.view.center.y-(ScreenWidth-100)/2)))];
    downView.alpha = 0.5;
    downView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:downView];
    
    _isOpen = NO;
    NSArray *array = [NSArray arrayWithObjects:@"icon_19_sm.png", @"icon_23_sm.png", nil];
    for (int i = 0; i < 2; i++) {
        //        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-32*3-15*2)/2+i*(32+15), downView.frame.origin.y+15, 32, 32)];
        //        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", [array objectAtIndex:i]]];
        //        imageView.tag = i+10;
        //        [self.view addSubview:imageView];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((self.view.frame.size.width-32*2-15)/2+i*(32+15), downView.frame.origin.y+15, 32, 32);
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", [array objectAtIndex:i]]] forState:UIControlStateNormal];
        btn.tag = i+10;
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, self.view.frame.size.height-20-17, 100, 17)];
    label.text = @"正在扫描二维码/条码";
    label.font = [UIFont systemFontOfSize:14];
    label.alpha = 0.75;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    CGSize size = CGSizeMake(self.view.frame.size.width,2000);
    CGSize labelsize = [label.text sizeWithFont:label.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    label.frame = CGRectMake((self.view.frame.size.width-labelsize.width+5+17)/2, label.frame.origin.y, labelsize.width, 17);
    [self.view addSubview:label];
    
    //    UIImageView *turnImage = [[UIImageView alloc] initWithFrame:CGRectMake(label.frame.origin.x-5-17, label.frame.origin.y, 17, 17)];
    //    turnImage.image = [UIImage imageNamed:@"icon_29_sm.png"];
    //    [self.view addSubview:turnImage];
    
    UIButton *turnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    turnBtn.frame = CGRectMake(label.frame.origin.x-5-17, label.frame.origin.y, 17, 17);
    [turnBtn setBackgroundImage:[UIImage imageNamed:@"icon_29_sm.png"] forState:UIControlStateNormal];
    turnBtn.tag = 7;
    [self.view addSubview:turnBtn];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(imageTurn) userInfo:nil repeats:YES];
    
    //返回上层页面按钮
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 33, 10, 18)];
    [backImage setImage:[UIImage imageNamed:@"icon_1_sm.png"]];
    [self.view addSubview:backImage];
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 20, 90, 44);
    [back setBackgroundColor:[UIColor clearColor]];
    [back addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    //    //扫描历史
    //    UIImageView *historyImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-20-20, 32, 20, 20)];
    //    [historyImage setImage:[UIImage imageNamed:@"icon_2_sm.png"]];
    //    [self.view addSubview:historyImage];
    
    //    UIButton *history = [UIButton buttonWithType:UIButtonTypeCustom];
    //    history.frame = CGRectMake(self.view.frame.size.width-20-20-20, 20, 60, 44);
    //    [history addTarget:self action:@selector(historyClick) forControlEvents:UIControlEventTouchUpInside];
    //    [history setBackgroundColor:[UIColor clearColor]];
    //    [self.view addSubview:history];
    
    UIImageView *centerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-100, ScreenWidth-100)];
    centerView.center = self.view.center;
    centerView.image = [UIImage imageNamed:@"扫描框.png"];
    centerView.contentMode = UIViewContentModeScaleAspectFit;
    centerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:centerView];
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(upView.frame), ScreenWidth-100, 2)];
    line.tag = line_tag;
    line.image = [UIImage imageNamed:@"扫描线.png"];
    line.contentMode = UIViewContentModeScaleAspectFill;
    line.backgroundColor = [UIColor clearColor];
    [self.view addSubview:line];
    
    UILabel *msg = [[UILabel alloc] initWithFrame:CGRectMake(0, upView.frame.size.height-15-18, self.view.frame.size.width, 18)];
    msg.backgroundColor = [UIColor clearColor];
    msg.textColor = [UIColor whiteColor];
    msg.textAlignment = NSTextAlignmentCenter;
    msg.font = [UIFont systemFontOfSize:14];
    msg.text = @"将二维码/条形码放入框内";
    size = CGSizeMake(self.view.frame.size.width,2000);
    labelsize = [msg.text sizeWithFont:msg.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    msg.frame = CGRectMake((self.view.frame.size.width-labelsize.width+4+18)/2, msg.frame.origin.y, labelsize.width, 18);
    [self.view addSubview:msg];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(msg.frame.origin.x-4-18, msg.frame.origin.y, 18, 18)];
    image.image = [UIImage imageNamed:@"icon_11_sm"];
    [self.view addSubview:image];
    
}

/**
 *  @author Whde
 *
 *  添加扫码动画
 */
- (void)addAnimation{
    UIView *line = [self.view viewWithTag:line_tag];
    line.hidden = NO;
    CABasicAnimation *animation = [QRCodeViewController moveYTime:2 fromY:[NSNumber numberWithFloat:0] toY:[NSNumber numberWithFloat:ScreenWidth-100-5] rep:OPEN_MAX];
    [line.layer addAnimation:animation forKey:@"LineAnimation"];
}

+ (CABasicAnimation *)moveYTime:(float)time fromY:(NSNumber *)fromY toY:(NSNumber *)toY rep:(int)rep
{
    CABasicAnimation *animationMove = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    [animationMove setFromValue:fromY];
    [animationMove setToValue:toY];
    animationMove.duration = time;
    animationMove.delegate = self;
    animationMove.repeatCount  = rep;
    animationMove.fillMode = kCAFillModeForwards;
    animationMove.removedOnCompletion = NO;
    animationMove.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return animationMove;
}

- (void) imageTurn
{
    UIButton *btn = (UIButton *) [self.view viewWithTag:7];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    btn.transform = CGAffineTransformRotate(btn.transform, M_PI);
    [UIView commitAnimations];
}

//- (void) historyClick
//{
//
//}

- (void) buttonClick : (UIButton *)btn
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [device lockForConfiguration:nil];
    if (btn.tag == 11) {
        if (_isOpen) {
            _isOpen = NO;
            [device setTorchMode: AVCaptureTorchModeOff];
            [btn setBackgroundImage:[UIImage imageNamed:@"icon_23_sm.png"] forState:UIControlStateNormal];
        } else {
            _isOpen = YES;
            [device setTorchMode: AVCaptureTorchModeOn];
            [btn setBackgroundImage:[UIImage imageNamed:@"icon_21_sm.png"] forState:UIControlStateNormal];
        }
    } else if (btn.tag == 10) {
        [self fromPhotos];
    }
    [device unlockForConfiguration];
}

-(void) fromPhotos
{
    
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    imagePicker.delegate = self;
    
    [self presentViewController:imagePicker animated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }];
    
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"选取图片调用");
    UIImage *i = [info valueForKey:@"UIImagePickerControllerOriginalImage"];
    UIImageOrientation imageOrientation=i.imageOrientation;
    if(imageOrientation!=UIImageOrientationUp)
    {
        // 原始图片可以根据照相时的角度来显示，但UIImage无法判定，于是出现获取的图片会向左转９０度的现象。
        // 以下为调整图片角度的部分
        UIGraphicsBeginImageContext(i.size);
        [i drawInRect:CGRectMake(0, 0, i.size.width, i.size.height)];
        i = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        // 调整图片角度完毕
    }
    
    //    NSData *imageData = UIImageJPEGRepresentation(self.i , 1);
    __weak __typeof(&*self)weakSelf = self;
    [picker dismissViewControllerAnimated:NO completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        [weakSelf performSelectorOnMainThread:@selector(QRCodeImageSelectFinish:) withObject:i waitUntilDone:NO];
    }];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void) QRCodeImageSelectFinish : (UIImage *)image
{
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    CIQRCodeFeature *feature = [features objectAtIndex:0];
    NSString *scannedResult = feature.messageString;
    ScanResultViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"scabresultVC"];
    vc.text = scannedResult;
    [self.navigationController pushViewController:vc animated:YES];
    

}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"取消选取");
    //    [picker dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void) parseQRCode
{
    [self removeAnimation];
}

/**
 *  @author Whde
 *
 *  去除扫码动画
 */
- (void)removeAnimation{
    UIView *line = [self.view viewWithTag:line_tag];
    [line.layer removeAnimationForKey:@"LineAnimation"];
    line.hidden = YES;
}

- (void) backBtnClick
{
    [session removeObserver:self forKeyPath:@"running" context:nil];
    //    [self.view removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

///**
// *  @author Whde
// *
// *  扫码取消button方法
// *
// *  @return
// */
//- (void)dismissOverlayView:(id)sender{
//    [self selfRemoveFromSuperview];
//}
//
///**
// *  @author Whde
// *
// *  从父视图中移出
// */
//- (void)selfRemoveFromSuperview{
//    [session removeObserver:self forKeyPath:@"running" context:nil];
//    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        self.view.alpha = 0;
//    } completion:^(BOOL finished) {
//        [self.view removeFromSuperview];
//        [self removeFromParentViewController];
//    }];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
//}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
