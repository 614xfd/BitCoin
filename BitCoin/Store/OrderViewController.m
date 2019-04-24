//
//  OrderViewController.m
//  BitCoin
//
//  Created by LBH on 2017/10/13.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import "OrderViewController.h"
#import "PayViewController.h"

@interface OrderViewController () {
    NSString *_phoneNum;
    NSString *_expressageString;
    NSDictionary *_addressDic;
}

@end

@implementation OrderViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setBarBlackColor:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _addressDic = [NSDictionary dictionary];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _phoneNum = [defaults objectForKey:@"phoneNum"];
    
    NSString *str = [self.dic objectForKey:@"titleImage"];
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",str]]];
    
    self.nameLabel.text = [self.dic objectForKey:@"name"];
    self.titleLabel.text = [self.dic objectForKey:@"title"];
    self.priceLabel.text = [NSString stringWithFormat:@"%@ GTSE", [self.dic objectForKey:@"price"]];
    self.numberLabel.text = [NSString stringWithFormat:@"x%@", self.storeNum];
//    self.maintainLabel.text = [self.dic objectForKey:@"productWarranty"];
    [self.storeImageView sd_setImageWithURL:[NSURL URLWithString:str]];
    self.monyeLabel.text = [NSString stringWithFormat:@"%.2lf GTSE", [self.storeNum doubleValue] * [[self.dic objectForKey:@"price"] doubleValue]];
    self.allStoreLabel.text = [NSString stringWithFormat:@"共%@件商品", self.storeNum];
    CGSize size = CGSizeMake(130,2000);
    CGSize labelsize = [self.monyeLabel.text sizeWithFont:self.monyeLabel.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    self.monyeLabel.frame = CGRectMake(self.orderBtn.frame.origin.x-labelsize.width-8, self.monyeLabel.frame.origin.y, labelsize.width, self.monyeLabel.frame.size.height);
    self.xjLabel.frame = CGRectMake(self.monyeLabel.frame.origin.x-self.xjLabel.frame.size.width, self.xjLabel.frame.origin.y, self.xjLabel.frame.size.width, self.xjLabel. frame.size.height);
    [self requestAddress];
    [self requestExpressage];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void) requestAddress
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    __weak __typeof(self) weakSelf = self;
    NSDictionary *dic = @{@"token":token};
    [[NetworkTool sharedTool] requestWithURLString:@"v1/user/ra/findAll" parameters:dic method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@", stringData, JSON );
        //        NSString *isError = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            //            [weakSelf verifyPass];
            NSArray *array = [JSON objectForKey:@"Data"];
            for (int i = 0; i < array.count; i++) {
                NSString *string = [NSString stringWithFormat:@"%@", [[array objectAtIndex:i] objectForKey:@"state"]];
                if ([string isEqualToString:@"1"]) {
                    [weakSelf returnAddressDic:[array objectAtIndex:i]];
                }
            }
            
        } else {
            [weakSelf performSelectorOnMainThread:@selector(showToastWithMessage:) withObject:[JSON objectForKey:@"msg"] waitUntilDone:YES];
        }
    } failed:^(NSError *error) {
        //        [weakSelf requestError];
    }];
}

- (void) setAddress
{
    
}

- (void) requestExpressage
{
//    __weak __typeof(self) weakSelf = self;
//    NSDictionary *dic = @{@"path":@"广东省"};
//    [[NetworkTool sharedTool] requestWithURLString:@"freight/freight" parameters:dic method:@"POST" completed:^(id JSON, NSString *stringData) {
//        NSLog(@"%@      ------------- %@", stringData, JSON );
//        //        NSString *isError = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
//        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
//        if ([code isEqualToString:@"1"]) {
//            _expressageString = [JSON objectForKey:@"Data"];
//            [weakSelf performSelectorOnMainThread:@selector(setExpressage) withObject:nil waitUntilDone:YES];
//            
//        } else {
//            [weakSelf performSelectorOnMainThread:@selector(showToastWithMessage:) withObject:[JSON objectForKey:@"msg"] waitUntilDone:YES];
//        }
//    } failed:^(NSError *error) {
//        //        [weakSelf requestError];
//    }];
}

- (void) requestNewOrder
{
    if (!_addressDic.count) {
        [self showToastWithMessage:@"请选择收货地址"];
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    __weak __typeof(self) weakSelf = self;
    NSDictionary *dic = @{@"productId":[self.dic objectForKey:@"id"], @"receivingAddressId":[_addressDic objectForKey:@"id"], @"token":token, @"message":self.messageTF.text, @"price":[self.dic objectForKey:@"price"], @"number":self.storeNum, @"totalMoney":[NSString stringWithFormat:@"%lf", [self.storeNum doubleValue] * [[self.dic objectForKey:@"price"] doubleValue]]};
    [[NetworkTool sharedTool] requestWithURLString:@"v1/mall/product/order/add" parameters:dic method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@", stringData, JSON );
        //        NSString *isError = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            [weakSelf performSelectorOnMainThread:@selector(gopay:) withObject:JSON waitUntilDone:YES];
        } else {
            [weakSelf performSelectorOnMainThread:@selector(showToastWithMessage:) withObject:[JSON objectForKey:@"msg"] waitUntilDone:YES];
        }
    } failed:^(NSError *error) {
        //        [weakSelf requestError];
    }];
}

- (void) gopay : (NSDictionary *)dic
{
    [self showToastWithMessage:@"下单成功"];
    double delayInSeconds = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_global_queue(0,0), ^(void){
        dispatch_async(dispatch_get_main_queue(), ^{
            PayViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PayVC"];
            vc.money = [NSString stringWithFormat:@"%lf", [self.storeNum doubleValue] * [[self.dic objectForKey:@"price"] doubleValue]];
            vc.idString = [NSString stringWithFormat:@"%@", [dic objectForKey:@"data"]];
            [self.navigationController pushViewController:vc animated:YES];
        });
    });
}

- (IBAction)orderBtnClick:(id)sender {
    [self requestNewOrder];
}

- (void) setExpressage
{
    self.dispatchingLabel.text = _expressageString;
}

- (IBAction)selectAddressBtnClick:(id)sender {
    SelectAddressViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectAddressVC"];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) returnAddressDic:(NSDictionary *)dic
{
    _addressDic = [NSDictionary dictionaryWithDictionary:dic];
    self.pLabel.text = [dic objectForKey:@"userName"];
    self.phoneLabel.text = [dic objectForKey:@"receiptPhone"];
    self.addressLabel.text = [dic objectForKey:@"receivingAddress"];
}

- (IBAction)hiddenBtnClick:(id)sender {
    [self.messageTF resignFirstResponder];
    [self.receiptTF resignFirstResponder];
}

- (void) keyboardWillShow:(NSNotification *)notification {
    self.hiddenBtn.hidden = NO;
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    CGFloat offset = (self.view.frame.size.height - kbHeight);
    if(offset > 0) {
        //        self.tableView.frame = CGRectMake(0.0f, -55*5, self.view.frame.size.width, self.view.frame.size.height);
        self.view.frame = CGRectMake(0, -kbHeight, self.view.frame.size.width, self.view.frame.size.height);
    }
}

- (void) keyboardWillHide:(NSNotification *)notify {
    self.hiddenBtn.hidden = YES;
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);

}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.messageTF resignFirstResponder];
    [self.receiptTF resignFirstResponder];
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
