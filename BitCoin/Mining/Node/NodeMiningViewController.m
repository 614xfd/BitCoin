//
//  NodeMiningViewController.m
//  BitCoin
//
//  Created by LBH on 2018/8/20.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "NodeMiningViewController.h"
//#import "LoginViewController.h"

@interface NodeMiningViewController () <UITableViewDelegate,UITableViewDataSource>{
//    NSString *_allCoin;
}

@property (nonatomic, strong)NSArray *tabData;
@property (nonatomic, strong)NSDictionary *detailDict;


@property (nonatomic, strong)NSString *numPrice;
@end

@implementation NodeMiningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabData = @[@{@"title":@"昨日团队业绩",@"img":@"city_icon1.png",@"unit":@"GTSE"},
                    @{@"title":@"昨日收益",@"img":@"city_icon3.png",@"unit":@"GTSE"},
                     @{@"title":@"总收益",@"img":@"city_icon2.png",@"unit":@"GTSE"},
                     @{@"title":@"加入天数",@"img":@"city_icon4.png",@"unit":@""}];
    
    [self requestGet];
    
    
    self.earningLab.text = @"+00.00";
    self.earningRatioLab.text = @"30%";
    self.buyBScrollView.alpha = 1;
    self.resultTableView.tableFooterView = [[UIView alloc] init];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payPassWord:) name:UITextFieldTextDidChangeNotification object:nil];
    
    
    if (!self.isSuperNode) {
        self.titleLab.text = @"城市节点";
    }
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
                [self requestAdd:[array componentsJoinedByString:@""]];
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
//- (void) requestWithPW:(NSString *) string {
////    if (self.numberTF.text.length < 1) {
////        [self showToastWithMessage:@"请输入数量"];
////        return;
////    }
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *token = [defaults objectForKey:@"token"];
//    NSString *phoneNum = [defaults objectForKey:@"phoneNum"];
//
//    //    [self md5:[NSString stringWithFormat:@"%@%@",[self.numArray componentsJoinedByString:@""],phoneNum]]
//    if (token.length) {
//        __weak __typeof(self) weakSelf = self;
//        NSString *password = [self md5:[NSString stringWithFormat:@"%@%@",string,phoneNum]];
//        NSDictionary *dic = @{@"token": token, @"money":self.numberTF.text, @"payPass":password, @"toPhone":self.phoneString};
//        [[NetworkTool sharedTool] requestWithURLString:@"/v1/account/transfer" parameters:dic method:@"POST" completed:^(id JSON, NSString *stringData) {
//            NSLog(@"%@      ------------- %@", stringData, JSON );
//            //        NSString *isError = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
//            NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
//            if ([code isEqualToString:@"1"]) {
//                [weakSelf performSelectorOnMainThread:@selector(sendSuccess) withObject:nil waitUntilDone:YES];
//            } else {
//                [weakSelf performSelectorOnMainThread:@selector(showToastWithMessage:) withObject:[JSON objectForKey:@"msg"] waitUntilDone:YES];
//            }
//        } failed:^(NSError *error) {
//            //        [weakSelf requestError];
//        }];
//    }
//}




- (void)createTabView{
    self.resultTableView.delegate = self;
    self.resultTableView.dataSource = self;
    self.resultTableView.bounces = NO;
    self.resultTableView.separatorStyle = UITableViewCellEditingStyleNone;     //让tableview不显示分割线
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tabData.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResultId" forIndexPath:indexPath];
 
    NSDictionary *dict = self.tabData[indexPath.row];
    UIView *bView = [cell.contentView viewWithTag:100];
    
    
    UIImageView *imgV = [bView viewWithTag:101];
    UILabel *titleLab = [bView viewWithTag:102];
    UILabel *rightLab = [bView viewWithTag:103];
    imgV.image = [UIImage imageNamed:dict[@"img"]];
    titleLab.text = dict[@"title"];
    
    
    
    NSArray *keys = @[@"teamMoney",@"money",@"totalMoeny",@"days"];
    if (self.detailDict) {
        rightLab.text = [NSString stringWithFormat:@"%@%@",self.detailDict[keys[indexPath.row]],dict[@"unit"]];
    }else{
        rightLab.text = [NSString stringWithFormat:@"0%@",dict[@"unit"]];
    }
    
    return cell;
}

-(void)requestGet{
    __weak __typeof(self) weakSelf = self;
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    if (!token.length) {
        [self tokenError];
        return;
    }
    NSDictionary *d = @{@"token":token};
    
    [[NetworkTool sharedTool] requestWithURLString:@"/v1/node/get" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@", stringData, JSON );
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            NSDictionary *data = JSON[@"data"];
            if (self.isSuperNode) {
                if ([data[@"userLevel"] isEqualToString: @"2"]){
                    [self createTabView];
                    [self requestDetail];
                    self.buyBScrollView.alpha = 0;
                }else{
                    
                    self.numPrice = data[@"2"] ;
                    self.buyBScrollView.alpha = 1;
                }
            }else{
                if ([data[@"userLevel"] isEqualToString: @"3"]){
                    [self createTabView];
                    [self requestDetail];
                    self.buyBScrollView.alpha = 0;
                }else{
                    self.numPrice = data[@"3"];
                    self.buyBScrollView.alpha = 1;
                }
            }
            

        } else {
            
        }
    } failed:^(NSError *error) {
        //        [weakSelf requestError];
    }];
}
-(void)requestAdd:(NSString *)payPwd{
    __weak __typeof(self) weakSelf = self;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    NSString *phoneNum = [defaults objectForKey:@"phoneNum"];
    NSString *payPass = payPwd;
    NSDictionary *d = @{@"token":token,@"payPass":payPass,@"sumMoney":self.numPrice};
    
    [[NetworkTool sharedTool] requestWithURLString:@"/v1/node/add" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@", stringData, JSON );
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        self.dustView.alpha = 0;
        self.payView.alpha = 0;
        if ([code isEqualToString:@"1"]) {

            NSDictionary *data = JSON[@"data"];
//            if ([data[@"userLevel"] isEqualToString: @"2"] && self.isSuperNode) {
//                [self requestDetail];
//            }else if ([data[@"userLevel"] isEqualToString: @"2"] && !self.isSuperNode) {
                [self requestDetail];
//            }else{
//                self.buyBScrollView.alpha = 1;
//            }
        } else {
            [self showToastWithMessage:JSON[@"msg"]];
        }
    } failed:^(NSError *error) {
        //        [weakSelf requestError];
    }];
}



- (void)requestDetail{
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSDictionary *d = @{@"token":token};
    
    [[NetworkTool sharedTool] requestWithURLString:@"/v1/node/detail" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"requestDetail :%@      ------------- %@", stringData, JSON );
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            self.detailDict = JSON[@"data"];
            
            self.earningLab.text = [NSString stringWithFormat:@"+%@",self.detailDict[@"money"]];
        } else {
            
        }
        [self.resultTableView reloadData];
    } failed:^(NSError *error) {
    }];
}
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)buyButtonClick:(id)sender {
    self.dustView.alpha = 0.4;
    self.buyTipView.alpha = 1;
    self.bgBtn.hidden = NO;
    self.tipLab1.text = self.isSuperNode?@"购买超级节点":@"购买城市节点";
    self.tipLab2.text = [NSString stringWithFormat:@"充值%@GTSE即可成为%@",self.numPrice,self.isSuperNode?@"超级节点":@"城市节点"];
    self.tipLab3.text = [NSString stringWithFormat:@"%@享受%d%%团队购买服务器销售提成" ,self.isSuperNode?@"超级节点":@"城市节点", self.isSuperNode?30:25];
}
- (IBAction)tipCancleBtnClick:(id)sender {
    self.dustView.alpha = 0;
    self.buyTipView.alpha = 0;
    self.bgBtn.hidden = YES;
}
- (IBAction)tipBuyBtnClick:(id)sender {
//    self.buyTipView.alpha = 0;
//    self.payView.alpha = 1;
//    self.payLab.text = [NSString stringWithFormat:@"%@GTSE",self.numPrice];
    [self inputPayPasswordWithPayTip:@"支付" andPrice:[NSString stringWithFormat:@"%@ GTSE",self.numPrice]];
}

- (void) returnPayPassword:(NSString *)string
{
    [self requestAdd:string];
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
- (IBAction)hiddenBuyView:(id)sender {
    self.buyTipView.alpha = 0;
    self.bgBtn.hidden = YES;
}

/*
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setBarBlackColor:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (@available(iOS 11.0, *)) {
        [self.scroll setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.scroll.contentSize = CGSizeMake(self.view.frame.size.width, 670*self.scale);
    self.activationView.layer.cornerRadius = 4;
    self.activationView.layer.masksToBounds = YES;
    self.lineBGLabel.layer.cornerRadius = 4;
    self.lineBGLabel.layer.masksToBounds = YES;
    self.lineBGLabel1.layer.cornerRadius = 4;
    self.lineBGLabel1.layer.masksToBounds = YES;
    [self.lineBGLabel.layer setBorderWidth:0.5];
    [self.lineBGLabel.layer setBorderColor:[UIColor colorWithRed:201/255.0 green:211/255.0 blue:218/255.0 alpha:1].CGColor];
    [self.lineBGLabel1.layer setBorderWidth:0.5];
    [self.lineBGLabel1.layer setBorderColor:[UIColor colorWithRed:201/255.0 green:211/255.0 blue:218/255.0 alpha:1].CGColor];
    
    _allCoin = @"";
    [self requestData];
    [self request];

}

- (void) returnString:(NSString *)string
{
    self.codeFT.text = string;
    [self.numTF becomeFirstResponder];
}

- (void) requestData
{
    __weak __typeof(self) weakSelf = self;
    [[NetworkTool sharedTool] requestWithURLString:@"parameters/GetParameters" parameters:nil method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@", stringData, JSON );
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
           
            
        } else {
            
        }
    } failed:^(NSError *error) {
        //        [weakSelf requestError];
    }];
}

- (void) request
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uid = [defaults objectForKey:@"uid"];
    if (uid.length) {
        __weak __typeof(self) weakSelf = self;
        NSDictionary *d = @{@"id":uid};
        [[NetworkTool sharedTool] requestWithURLString:@"UserAccount/findUserBalanleSum" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
            NSLog(@"%@      ------------- %@", stringData, JSON );
            NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
            if ([code isEqualToString:@"1"]) {
                NSArray *array = [NSArray arrayWithArray:[JSON objectForKey:@"Data"]];
                for (int i = 0; i < array.count; i++) {
                    if ([[[array objectAtIndex:i] objectForKey:@"type"] isEqualToString:@"bbc"]) {
                        _allCoin = [NSString stringWithFormat:@"%@", [[array objectAtIndex:i] objectForKey:@"balance"]];
                    }
                }
                
            } else {
                
            }
        } failed:^(NSError *error) {
            //        [weakSelf requestError];
        }];
    }
}

- (void) requestNode
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uid = [defaults objectForKey:@"uid"];
    __weak __typeof(self) weakSelf = self;
    NSDictionary *d = @{@"uid":uid, @"code":self.codeFT.text, @"sum":self.numTF.text};
    [[NetworkTool sharedTool] requestWithURLString:@"node/nodeActivate" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@", stringData, JSON );
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            
        } else {
            
        }
    } failed:^(NSError *error) {
        //        [weakSelf requestError];
    }];
}

- (IBAction)QRBtnClick:(id)sender {
    QRCodeViewController *qrcodeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"qrcodeview"];
    qrcodeVC.delegate = self;
    
    [self.navigationController pushViewController:qrcodeVC animated:NO];
}
- (IBAction)sendCode:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *s = [defaults objectForKey:@"authenticationStatus"];
    if ([s isEqualToString:@"0"]) {
        //            self.tipLabel.text = @"立即认证";
    } else if ([s isEqualToString:@"1"]) {
        //            self.tipLabel.text = @"审核中";
    } else if ([s isEqualToString:@"2"]) {
        //            self.tipLabel.text = @"认证成功";
        [self requestNode];
    }
}

- (IBAction)allInBtnClick:(id)sender {
    self.numTF.text = [NSString stringWithFormat:@"%d", [_allCoin intValue]];
}

- (IBAction)buyBtnClick:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *value = [defaults objectForKey:@"isLogin"];
    if ([value isEqualToString:@"YES"]) {
        self.activationView.hidden = NO;
        self.bgBtn.hidden = NO;
    } else {
        LoginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
   
}

- (IBAction)cancleBtnClick:(id)sender {
    [self hiddenActivationView];
}

- (IBAction)BGBtnClick:(id)sender {
    [self hiddenActivationView];
}

- (void) hiddenActivationView
{
    self.activationView.hidden = YES;
    self.bgBtn.hidden = YES;
}

-(NSString *)notRounding:(float)price afterPoint:(int)position
{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    NSDecimalNumber *roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)loginBtn:(id)sender {
}
 */
@end
