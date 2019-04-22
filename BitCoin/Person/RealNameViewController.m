//
//  RealNameViewController.m
//  BitCoin
//
//  Created by LBH on 2017/11/2.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import "RealNameViewController.h"
#import "AFNetworking.h"

static AFHTTPSessionManager *manager;

@interface RealNameViewController () {
    NSMutableArray *_typeArray;//证件类型
    NSInteger _x;
    UIImage *_FrontalImage;
    UIImage *_BehindImage;
    UIImage *_handImage;
    UIColor *_gColor;
    NSString *_typeTitle;
    NSString *_typeID;
    UILabel *_toast;
}

@end

@implementation RealNameViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setBarBlackColor:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _x = 0;
    _typeArray = [NSMutableArray array];
//    _typeArray = [[NSMutableArray alloc] initWithObjects:@{@"title":@"港澳通行证"}, @{@"title":@"台胞证"}, nil];
    _typeTitle = @"身份证号";
    _typeID = @"1";
    [self request];
    self.nameTF.returnKeyType =UIReturnKeyDone;
    self.numberTF.returnKeyType =UIReturnKeyDone;
    self.nextBtn.userInteractionEnabled = NO;
    _gColor = self.nextBtn.backgroundColor;
    [self.nextBtn.layer setMasksToBounds:YES];
    self.nextBtn.layer.cornerRadius = 8;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTypeLabelColor:) name:UITextFieldTextDidEndEditingNotification object:nil];

    
    _toast = [[UILabel alloc] initWithFrame:CGRectMake(25, (self.view.frame.size.height-70)/2, self.view.frame.size.width-50, 20+30)];
    _toast.text = @"已上传 0%";
    _toast.font = [UIFont systemFontOfSize:14];
    _toast.textAlignment = NSTextAlignmentCenter;
    _toast.textColor = [UIColor whiteColor];
    _toast.backgroundColor = [UIColor blackColor];
    _toast.alpha = 0.5;
    _toast.layer.cornerRadius = 4;
    _toast.layer.masksToBounds = YES;
    _toast.numberOfLines = 0;
    _toast.lineBreakMode = NSLineBreakByCharWrapping;
    _toast.hidden = YES;
    [self.view addSubview:_toast];

}

- (void) request
{
    __weak __typeof(self) weakSelf = self;
    [[NetworkTool sharedTool] requestWithURLString:@"Certificates/findType" parameters:nil method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@", stringData, JSON );
        //        NSString *isError = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            NSArray *array = [JSON objectForKey:@"Data"];
            _typeArray = [NSMutableArray arrayWithArray:array];
        } else {
            [weakSelf performSelectorOnMainThread:@selector(showToastWithMessage:) withObject:[JSON objectForKey:@"msg"] waitUntilDone:YES];
        }
    } failed:^(NSError *error) {
        //        [weakSelf requestError];
    }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"najhvpasdhfahsdfiasdf");
    if (textField == self.nameTF) {
        [self.numberTF becomeFirstResponder];
    } else {
        [self.numberTF resignFirstResponder];
    }
    if (self.nameTF.text.length > 0 && self.numberTF.text.length > 0 && _FrontalImage && _BehindImage && _handImage) {
        [self.nextBtn setBackgroundColor:[UIColor colorWithRed:47/255.0 green:130/255.0 blue:200/255.0 alpha:1]];
        self.nextBtn.userInteractionEnabled = YES;
    } else {
        [self.nextBtn setBackgroundColor:_gColor];
        self.nextBtn.userInteractionEnabled = NO;
    }
    return YES;
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
        [self changeTypeLabel:[_typeArray objectAtIndex:buttonIndex-1]];
    }
}

- (void) changeTypeLabel : (NSDictionary *)dic
{
    _typeTitle = [dic objectForKey:@"CertificatesType"];
    self.IDLabel.text = _typeTitle;
    _typeID = [dic objectForKey:@"typeID"];
}

- (void) changeTypeLabelColor : (UITextField *)tf
{
    if (tf == self.nameTF) {
        return;
    }
    if (self.numberTF.text.length != 18) {
        self.IDLabel.textColor = [UIColor colorWithRed:231/255.0 green:39/255.0 blue:7/255.0 alpha:1];
        self.IDLabel.text = [NSString stringWithFormat:@"%@错误", _typeTitle];
    } else {
        self.IDLabel.textColor = [UIColor colorWithRed:47/255.0 green:130/255.0 blue:200/255.0 alpha:1];
        self.IDLabel.text = _typeTitle;
    }
}

- (IBAction)selectImageBtnClick:(id)sender {
    [self hiddenKeyboard];
    NSInteger i = [(UIButton *)sender tag];
    if (i == 10) {
        _x = 0;
    } else if (i == 11) {
        _x = 1;
    } else if (i == 12) {
        _x = 2;
    }
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: @"相册", @"拍照", nil];
    actionSheet.tag = 1;
    [actionSheet showInView:actionSheet];

}

- (IBAction)changeType:(id)sender {
    [self hiddenKeyboard];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: nil];
    for (int i = 0; i < _typeArray.count; i++) {
        [actionSheet addButtonWithTitle:[[_typeArray objectAtIndex:i] objectForKey:@"CertificatesType"]];
    }
    actionSheet.tag = 2;
    [actionSheet showInView:actionSheet];
}

//- (void) hiddenImageView
//{
//    [self.bgView removeFromSuperview];
//    self.bgView = nil;
//}
//
//- (void) creatImageView
//{
//    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    self.bgView.backgroundColor = [UIColor blackColor];
//    [self.view addSubview:self.bgView];
//
//    self.i = [self scaleImage:self.i toScale:self.view.frame.size.width/self.i.size.width];
//    NSLog(@"%lf, %lf", self.i.size.width, self.i.size.height);
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.i];
//    imageView.center = self.bgView.center;
//    [self.bgView addSubview:imageView];
//
//    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"商城详情1_11.png"]];
//    img.frame = CGRectMake(16, 29, 24, 24);
//    [self.bgView addSubview:img];
//
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(0, 0, 100, 64);
//    [btn addTarget:self action:@selector(hiddenImageView) forControlEvents:UIControlEventTouchUpInside];
//    [self.bgView addSubview:btn];
//
//    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn1.frame = CGRectMake(self.view.frame.size.width-80, 19, 80, 44);
//    [btn1 addTarget:self action:@selector(sandImage) forControlEvents:UIControlEventTouchUpInside];
//    [self.bgView addSubview:btn1];
//}

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
            _FrontalImage = [UIImage imageWithData:imageData];
        } else if (_x == 1) {
            _BehindImage = [UIImage imageWithData:imageData];
        } else if (_x == 2) {
            _handImage = [UIImage imageWithData:imageData];
        }
        [weakSelf performSelectorOnMainThread:@selector(judge) withObject:nil waitUntilDone:YES];
    }];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"取消选取");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void) judge
{
    if (self.nameTF.text.length > 0 && self.numberTF.text.length > 0 && _FrontalImage && _BehindImage && _handImage) {
        [self.nextBtn setBackgroundColor:[UIColor colorWithRed:47/255.0 green:130/255.0 blue:200/255.0 alpha:1]];
        self.nextBtn.userInteractionEnabled = YES;
    } else {
        [self.nextBtn setBackgroundColor:_gColor];
        self.nextBtn.userInteractionEnabled = NO;
    }
}

- (IBAction)nextBtnClick:(id)sender {
    NSArray *array = @[@"Frontal", @"Behind", @"handheld"];
    NSArray *photos = @[_FrontalImage, _BehindImage, _handImage];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *phoneNum = [defaults objectForKey:@"phoneNum"];
    NSDictionary *dic = @{@"phone":phoneNum, @"name":self.nameTF.text, @"typeID":_typeID, @"certificatesNumber":self.numberTF.text};
    
    __weak __typeof(self) weakSelf = self;
    AFHTTPSessionManager *manager = [RealNameViewController sharedHttpSession];
    [manager POST:@"https://bitboss.bitboss.cn/Certificates/fileUpload" parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
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
        [weakSelf performSelectorOnMainThread:@selector(changeToast:) withObject:[NSString stringWithFormat:@"已上传 %lf", s] waitUntilDone:YES];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"上传成功");
        [weakSelf performSelectorOnMainThread:@selector(upLoadSuccess) withObject:nil waitUntilDone:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传失败");
    }];
}

- (void) upLoadSuccess
{
    [_toast removeFromSuperview];
    _toast = nil;
    
    ToastView *messageView = [[ToastView alloc]initWithFrame:self.view.bounds WithMessage:@"提交审核成功"];
    [self.view addSubview:messageView];
    
    double delayInSeconds = 1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_global_queue(0,0), ^(void){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate resetMessage:@"审核中"];
            [self.navigationController popViewControllerAnimated:YES];
        });
    });
}

- (void) changeToast : (NSString *) string
{
    _toast.text = string;
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) hiddenKeyboard
{
    [self.nameTF resignFirstResponder];
    [self.numberTF resignFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hiddenKeyboard];
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
