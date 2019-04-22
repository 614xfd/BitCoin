//
//  AddAddressViewController.m
//  BitCoin
//
//  Created by LBH on 2017/10/21.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import "AddAddressViewController.h"
#import "AddressPickerView.h"

@interface AddAddressViewController ()<AddressPickerViewDelegate>

@property (nonatomic ,strong) AddressPickerView * pickerView;

@end

@implementation AddAddressViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setBarBlackColor:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.isReset) {
        self.nameTF.text = [self.dic objectForKey:@"userName"];
        self.phoneTF.text = [self.dic objectForKey:@"receiptPhone"];
        self.addressTV.text = [self.dic objectForKey:@"ReceivingAddress"];
    }
    [self.view addSubview:self.pickerView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (AddressPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[AddressPickerView alloc]init];
        _pickerView.delegate = self;
        [_pickerView setTitleHeight:50 pickerViewHeight:165];
        // 关闭默认支持打开上次的结果
        //        _pickerView.isAutoOpenLast = NO;
    }
    return _pickerView;
}

- (IBAction)selectRegionBtnClick:(id)sender {
    [self hiddenKeyBoard];

    [self.pickerView show];
}

- (void) request
{
    __weak __typeof(self) weakSelf = self;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    NSDictionary *dic = @{@"token":token, @"userName":self.nameTF.text, @"receiptPhone":self.phoneTF.text, @"receivingAddress":@"小蚂蚁服务器公司矿场统一托管"};
    [[NetworkTool sharedTool] requestWithURLString:@"v1/user/ra/add" parameters:dic method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@", stringData, JSON );
        //        NSString *isError = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            [weakSelf performSelectorOnMainThread:@selector(addSuccess) withObject:nil waitUntilDone:YES];
        } else {
            [weakSelf performSelectorOnMainThread:@selector(showToastWithMessage:) withObject:[JSON objectForKey:@"msg"] waitUntilDone:YES];
        }
    } failed:^(NSError *error) {
        //        [weakSelf requestError];
    }];
}

- (void) reset
{
    __weak __typeof(self) weakSelf = self;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    NSDictionary *dic = @{@"token":token, @"userName":self.nameTF.text, @"receiptPhone":self.phoneTF.text, @"receivingAddress":@"小蚂蚁服务器公司矿场统一托管", @"id":[self.dic objectForKey:@"id"]};
    [[NetworkTool sharedTool] requestWithURLString:@"v1/user/ra/edit" parameters:dic method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@", stringData, JSON );
        //        NSString *isError = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            [weakSelf performSelectorOnMainThread:@selector(addSuccess) withObject:nil waitUntilDone:YES];
        } else {
            [weakSelf performSelectorOnMainThread:@selector(showToastWithMessage:) withObject:[JSON objectForKey:@"msg"] waitUntilDone:YES];
        }
    } failed:^(NSError *error) {
        //        [weakSelf requestError];
    }];
}

- (IBAction)saveBtnClick:(id)sender {
    [self hiddenKeyBoard];

//    if (self.nameTF.text.length && self.phoneTF.text.length && self.regionLabel.text.length && self.addressTV.text.length) {
    if (self.nameTF.text.length && self.phoneTF.text.length) {
        if (self.isReset) {
            [self reset];
            return;
        }
        [self request];
    }
}

- (void) addSuccess
{
    ToastView *messageView = [[ToastView alloc]initWithFrame:self.view.bounds WithMessage:@"添加地址成功成功"];
    [self.view addSubview:messageView];
    
    double delayInSeconds = 1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_global_queue(0,0), ^(void){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    });
}

#pragma mark - AddressPickerViewDelegate
- (void)cancelBtnClick{
    NSLog(@"点击了取消按钮");
    [self.pickerView hide];
}

- (void)sureBtnClickReturnProvince:(NSString *)province City:(NSString *)city Area:(NSString *)area{
    self.regionLabel.text = [NSString stringWithFormat:@"%@%@%@",province,city,area];
//    [self btnClick:_addressBtn];
    [self.pickerView hide];
}

- (void) keyboardWillShow:(NSNotification *)notification {
//    self.tipLabel.hidden = YES;
}

- (void) keyboardWillHide:(NSNotification *)notify {
//    if (self.addressTV.text.length) {
//        self.tipLabel.hidden = YES;
//    } else {
//        self.tipLabel.hidden = NO;
//    }
}

- (void) hiddenKeyBoard
{
    [self.nameTF resignFirstResponder];
    [self.phoneTF resignFirstResponder];
    [self.addressTV resignFirstResponder];
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hiddenKeyBoard];
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
