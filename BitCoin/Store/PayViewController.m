//
//  PayViewController.m
//  BitCoin
//
//  Created by LBH on 2018/7/12.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "PayViewController.h"
#import "MacAddressListViewController.h"

static AFHTTPSessionManager *manager;

@interface PayViewController () {
//    NSString *_numberString;
//    UIImage *_image;
//    NSData *_immageData;
    NSString *_bbcBalance;
}

@end

@implementation PayViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.orderIdLab.text = self.idString;
    self.moneyLab.text = self.money;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payPassWord:) name:UITextFieldTextDidChangeNotification object:nil];
    [self requestBalance];
}
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)payBtnClick:(id)sender {
//    self.dustView.alpha = 0.4;
//    self.tipView.alpha = 1;
    [self inputPayPasswordWithPayTip:@"支付" andPrice:[NSString stringWithFormat:@"%@ GTSE", self.money]];
}

- (void) returnPayPassword:(NSString *)string
{
    [self requestPay:string];
}

- (void) creatBalance
{
    self.canUse.text = [NSString stringWithFormat:@"余额：%.2lf（GTSE）", [_bbcBalance doubleValue]];
}

- (void) requestBalance
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    if (token.length) {
        __weak __typeof(self) weakSelf = self;
        NSDictionary *d = @{@"token":token};
        [[NetworkTool sharedTool] requestWithURLString:@"v1/user/account/info" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
            NSLog(@"%@      ------------- %@", stringData, JSON );
            NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
            if ([code isEqualToString:@"1"]) {
                _bbcBalance = [NSString stringWithFormat:@"%.2lf", [[[JSON objectForKey:@"data"] objectForKey:@"normal"] doubleValue]];
                [weakSelf performSelectorOnMainThread:@selector(creatBalance) withObject:nil waitUntilDone:YES];
            } else {
                
            }
        } failed:^(NSError *error) {
            //        [weakSelf requestError];
        }];
    }
}


- (void) requestPay:(NSString *)pwd{
    __weak __typeof(self) weakSelf = self;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    NSString *phone = [defaults objectForKey:@"phoneNum"];
    pwd = pwd;
    //    NSDictionary *dic = @{@"phone":self.phoneNum.text, @"pwd":string, @"mac":uuid};
    NSDictionary *dic = @{@"token":token, @"productOrderId":self.idString,@"payPwd":pwd};
    [[NetworkTool sharedTool] requestWithURLString:@"/v1/mall/product/order/pay" parameters:dic method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@", stringData, JSON );
        //        NSString *isError = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        self.dustView.alpha = 0;
        self.tipView.alpha = 0;
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            [self showToastWithMessage:@"完成支付"];
//            [self.navigationController popToRootViewControllerAnimated:YES];
            [weakSelf performSelectorOnMainThread:@selector(intoMacVC) withObject:nil waitUntilDone:YES];
        } else {
            [self showToastWithMessage:JSON[@"msg"]];
        }
    } failed:^(NSError *error) {
        //        [weakSelf requestError];
    }];
}

- (void) intoMacVC
{
    ToastView *messageView = [[ToastView alloc]initWithFrame:self.view.bounds WithMessage:@"支付成功"];
    [self.view addSubview:messageView];
    
    double delayInSeconds = 1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_global_queue(0,0), ^(void){
        dispatch_async(dispatch_get_main_queue(), ^{
            MacAddressListViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MacAddressListVC"];
            [self.navigationController pushViewController:vc animated:YES];
        });
    });
}

- (void) payPassWord : (NSNotification *)obj
{
    UITextField *tf = obj.object;
    
    if (tf.text.length > 0) {
        tf.text = [tf.text substringToIndex:1];
    }
    int x = 0;
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"a", @"a", @"a", @"a", @"a", @"a", nil];
    for (int i = 20; i < 26; i++) {
        UITextField *t = (UITextField *)[self.view viewWithTag:i];
        if (t.text.length>0) {
            x++;
            [array replaceObjectAtIndex:i-20 withObject:t.text];
            if (x == 6) {
                NSLog(@"%@", array);
                // 验证支付密码
//                [self requestPay:[array componentsJoinedByString:@""]];
            }
            continue;
        } else {
            break;
        }
    }
    NSInteger y = tf.tag;
    if (y == 25) {
        return;
    }
    UITextField *tv = (UITextField *)[self.view viewWithTag:y+1];
    [tv becomeFirstResponder];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@""]) {
        for (int i = 20; i < 26; i++) {
            UITextField *tv = (UITextField *)[self.view viewWithTag:i];
            tv.text = @"";
        }
        UITextField *tv = (UITextField *)[self.view viewWithTag:20];
        [tv becomeFirstResponder];
    }
    return YES;
}

///v1/mall/product/order/pay
/*
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setBarBlackColor:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _numberString = @"6217007200020309962";
    self.numLabel.text = [self formatterBankCardNum:_numberString];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBigImageView)];
    [self.payImageView addGestureRecognizer:tap];

}

-(NSString *)formatterBankCardNum:(NSString *)string {
    NSString *tempStr=string;
    NSInteger size =(tempStr.length / 4);
    NSMutableArray *tmpStrArr = [[NSMutableArray alloc] init];
    
    for (int n = 0;n < size; n++) {
        [tmpStrArr addObject:[tempStr substringWithRange:NSMakeRange(n*4, 4)]];
    }
    
    
    [tmpStrArr addObject:[tempStr substringWithRange:NSMakeRange(size*4, (tempStr.length % 4))]];
    tempStr = [tmpStrArr componentsJoinedByString:@" "];
    return tempStr;
}

- (IBAction)upDataBtnClick:(id)sender {
    
    NSArray *array = @[@"payImg"];
    NSArray *photos = @[_image];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *phoneNum = [defaults objectForKey:@"uid"];
    NSDictionary *dic = @{@"orderId":self.idString, @"uid":phoneNum};

    __weak __typeof(self) weakSelf = self;
    AFHTTPSessionManager *manager = [PayViewController sharedHttpSession];
    [manager POST:@"https://bitboss.bitboss.cn/GoodsOrder/payOrder" parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
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
//        [weakSelf performSelectorOnMainThread:@selector(changeToast:) withObject:[NSString stringWithFormat:@"已上传 %lf", s] waitUntilDone:YES];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"上传成功");
        [weakSelf performSelectorOnMainThread:@selector(upLoadSuccess:) withObject:responseObject waitUntilDone:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传失败");
    }];
}

- (void) upLoadSuccess : (NSDictionary *)dic
{
    [self showToastWithMessage:[dic objectForKey:@"msg"]];
}

- (IBAction)copyBtnClick:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _numberString;
}

- (IBAction)selectBtnClick:(id)sender {
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    imagePicker.delegate = self;
    //    imagePicker.allowsEditing = YES;
    
    [self presentViewController:imagePicker animated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];

}

- (IBAction)reSelectBtnClick:(id)sender {
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    imagePicker.delegate = self;
    //    imagePicker.allowsEditing = YES;
    
    [self presentViewController:imagePicker animated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];
}

- (void) creatImageView
{
    UIImage *img = [self clipImage:_image toRect:CGSizeMake(120, 120)];
    self.payImageView.image = img;
    self.payImageView.hidden = NO;
    self.reSelectBtn.hidden = NO;
}

- (void) showBigImageView
{
    self.bgLabel.hidden = NO;
//    self.bgBtn.hidden = NO;
    self.scroll.hidden = NO;
    self.bigImage.image = _image;
    self.bigImage.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width/_image.size.width*_image.size.height);
    self.scroll.contentSize = CGSizeMake(self.view.frame.size.width, self.bigImage.frame.size.height);
    self.bgBtn.frame = CGRectMake(0, 0, self.view.frame.size.width, self.bigImage.frame.size.height);
//    self.bigImage.center = self.scroll.center;
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
    
//    i = [self scaleImage:i toScale:self.view.frame.size.width/i.size.width];
    _image = i;
    NSData *imageData = UIImageJPEGRepresentation(i, 1);
    _immageData = imageData;
    [picker dismissViewControllerAnimated:NO completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        //        [self performSelectorOnMainThread:@selector(photoSelect) withObject:nil waitUntilDone:NO];
        //        [weakSelf performSelectorOnMainThread:@selector(creatImageView) withObject:nil waitUntilDone:YES];
       
        [weakSelf performSelectorOnMainThread:@selector(creatImageView) withObject:nil waitUntilDone:YES];
    }];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"取消选取");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

-(UIImage *)clipImage:(UIImage *)image toRect:(CGSize)size{
    
    //被切图片宽比例比高比例小 或者相等，以图片宽进行放大
    if (image.size.width*size.height <= image.size.height*size.width) {
        
        //以被剪裁图片的宽度为基准，得到剪切范围的大小
        CGFloat width  = image.size.width;
        CGFloat height = image.size.width * size.height / size.width;
        
        // 调用剪切方法
        // 这里是以中心位置剪切，也可以通过改变rect的x、y值调整剪切位置
        return [self imageFromImage:image inRect:CGRectMake(0, (image.size.height -height)/2, width, height)];
        
    }else{ //被切图片宽比例比高比例大，以图片高进行剪裁
        
        // 以被剪切图片的高度为基准，得到剪切范围的大小
        CGFloat width  = image.size.height * size.width / size.height;
        CGFloat height = image.size.height;
        
        // 调用剪切方法
        // 这里是以中心位置剪切，也可以通过改变rect的x、y值调整剪切位置
        return [self imageFromImage:image inRect:CGRectMake((image.size.width -width)/2, 0, width, height)];
    }
    return nil;
}

- (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect{
    
    //将UIImage转换成CGImageRef
    CGImageRef sourceImageRef = [image CGImage];
    
    //按照给定的矩形区域进行剪裁
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    
    //将CGImageRef转换成UIImage
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    //返回剪裁后的图片
    return newImage;
}

- (IBAction)bgBtnClick:(id)sender {
    self.bgLabel.hidden = YES;
    self.scroll.hidden = YES;
}

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

*/

@end
