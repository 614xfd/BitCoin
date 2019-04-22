//
//  NewRealNameViewController.m
//  BitCoin
//
//  Created by CCC on 2019/4/20.
//  Copyright © 2019年 LBH. All rights reserved.
//

#import "NewRealNameViewController.h"
static AFHTTPSessionManager *manager;

@interface NewRealNameViewController () {
    NSInteger _x;
    UIImage *_FrontalImage;
    UIImage *_BehindImage;
    UIImage *_handImage;
}

@end

@implementation NewRealNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *authenticationStatus = [NSString stringWithFormat:@"%@", [self.infoDic objectForKey:@"authenticationStatus"]];
    if (![authenticationStatus isEqualToString:@"0"]) {
        self.stautsView.hidden = NO;
        if ([authenticationStatus isEqualToString:@"2"]) {
            self.tipLabel.text = @"审核已通过";
        }
    }
    
}
- (IBAction)holdBtn:(id)sender {
    _x = 0;
    [self showMassage];
}
- (IBAction)frontBtn:(id)sender {
    _x = 1;
    [self showMassage];

}
- (IBAction)contraryBtn:(id)sender {
    _x = 2;
    [self showMassage];

}
- (IBAction)upBtn:(id)sender {
    if (!_FrontalImage&&!_BehindImage&&!_handImage) {
        [self showToastWithMessage:@"请选择相应相片"];
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    NSArray *array = @[@"frontal", @"behind", @"handheld"];
    NSArray *photos = @[_FrontalImage, _BehindImage, _handImage];
    NSDictionary *dic = @{@"token":token};
    
    __weak __typeof(self) weakSelf = self;
    AFHTTPSessionManager *manager = [NewRealNameViewController sharedHttpSession];
    [manager POST:@"http://api.zg960.com.cn/v1/user/certificates/auth" parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i < photos.count; i ++) {
            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
            formatter.dateFormat=@"yyyyMMddHHmmss";
            NSString *str=[formatter stringFromDate:[NSDate date]];
            NSString *fileName=[NSString stringWithFormat:@"%@.jpg",str];
            UIImage *image = photos[i];
            NSData *imageData = UIImageJPEGRepresentation(image, 1);
            [formData appendPartWithFileData:imageData name:[array objectAtIndex:i] fileName:fileName mimeType:@"image/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //        NSLog(@"uploadProgress is %lld,总字节 is %lld",uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
        
        double s = uploadProgress.completedUnitCount/uploadProgress.totalUnitCount;
        [weakSelf performSelectorOnMainThread:@selector(showToastWithMessage:) withObject:[NSString stringWithFormat:@"上传中，请稍后。"] waitUntilDone:YES];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"上传成功");
        [weakSelf performSelectorOnMainThread:@selector(upLoadSuccess) withObject:nil waitUntilDone:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传失败");
    }];

}

- (void) upLoadSuccess
{
    ToastView *messageView = [[ToastView alloc]initWithFrame:self.view.bounds WithMessage:@"提交审核成功"];
    [self.view addSubview:messageView];
    
    double delayInSeconds = 1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_global_queue(0,0), ^(void){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    });
}

- (void) showMassage
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: @"相册", @"拍照", nil];
    actionSheet.tag = 1;
    [actionSheet showInView:actionSheet];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1) {
        if (buttonIndex == 0) {
            [self fromPhotos];
        } else if (buttonIndex == 1) {
            [self fromCamera];
        }
    } else if (actionSheet.tag == 2) {
        if (buttonIndex == 0) {
            return;
        }
//        [self changeTypeLabel:[_typeArray objectAtIndex:buttonIndex-1]];
    }
}
- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

//为了防止内存泄露
+ (AFHTTPSessionManager *)sharedHttpSession
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        manager.requestSerializer.timeoutInterval = 10;
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                             @"text/html",
                                                             @"image/jpeg",
                                                             @"image/png",
                                                             @"application/octet-stream",
                                                             @"text/json", nil];
    });
    return manager;
}

- (void) sandImage
{
    //        [SVProgressHUD showProgress:-1 status:@"正在上传,请稍等."]
    
}

-(void) fromPhotos
{
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    imagePicker.delegate = self;
    //    imagePicker.allowsEditing = YES;
    
    [self presentViewController:imagePicker animated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];
}

-(void) fromCamera
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]==NO){
        return;
    }
    
    //    self.i = [[UIImage alloc] init];
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    imagePicker.delegate = self;
    //    imagePicker.allowsEditing = YES;
    
    [self presentViewController:imagePicker animated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];
    
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"选取图片调用");
    //
    //    CGSize screenBounds = [UIScreen mainScreen].bounds.size;
    //    CGFloat cameraAspectRatio = 4.0f/3.0f;
    //    CGFloat camViewHeight = screenBounds.width * cameraAspectRatio;
    //    CGFloat scale = screenBounds.height / camViewHeight;
    //    picker.cameraViewTransform = CGAffineTransformMakeTranslation(0, (screenBounds.height - camViewHeight) / 2.0);
    //    picker.cameraViewTransform = CGAffineTransformScale(picker.cameraViewTransform, scale, scale);
    
    __weak __typeof(self) weakSelf = self;
    
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
    
    i = [self scaleImage:i toScale:self.view.frame.size.width/i.size.width];
    NSData *imageData = UIImageJPEGRepresentation(i, 1);
    [picker dismissViewControllerAnimated:NO completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        //        [self performSelectorOnMainThread:@selector(photoSelect) withObject:nil waitUntilDone:NO];
        //        [weakSelf performSelectorOnMainThread:@selector(creatImageView) withObject:nil waitUntilDone:YES];
        if (_x == 0) {
            _handImage = [UIImage imageWithData:imageData];
            self.holdImageView.image = _handImage;
        } else if (_x == 1) {
            _FrontalImage = [UIImage imageWithData:imageData];
            self.frontImageView.image = _FrontalImage;
        } else if (_x == 2) {
            _BehindImage = [UIImage imageWithData:imageData];
            self.contraryImageView.image = _BehindImage;
        }
//        [weakSelf performSelectorOnMainThread:@selector(judge) withObject:nil waitUntilDone:YES];
    }];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"取消选取");
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
