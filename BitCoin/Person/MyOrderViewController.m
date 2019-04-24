//
//  MyOrderViewController.m
//  BitCoin
//
//  Created by LBH on 2017/10/27.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import "MyOrderViewController.h"
#import "MyOrderInfoViewController.h"
#import "PayViewController.h"

@interface MyOrderViewController () {
    CGFloat _x;
    UIColor *_color;
    UIColor *_color2;
    NSMutableArray *_paymentArray;
    NSMutableArray *_finishArray;
}

@property (nonatomic)NSInteger status;
@property (nonatomic, strong)NSMutableArray *dataList;
@end

@implementation MyOrderViewController



///v1/mall/product/order/query

- (void)requestQuery:(NSInteger)status{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    if (token.length) {
        __weak __typeof(self) weakSelf = self;
        __weak  index = status;
        NSDictionary *d = @{@"token":token,@"status":[NSString stringWithFormat:@"%ld",status]};
        [[NetworkTool sharedTool] requestWithURLString:@"/v1/mall/product/order/query" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
            NSLog(@"%@      ------------- %@,%ld", stringData, JSON ,index);
            NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
            if ([code isEqualToString:@"1"]) {
                self.dataList[index] = JSON[@"data"];
                
                UITableView *tabView = [self.scroll viewWithTag:1000 + index];
                [tabView reloadData];
            } else {
                
            }
        } failed:^(NSError *error) {
            //        [weakSelf requestError];
        }];
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setBarBlackColor:YES];
}

- (void)viewDidLoad {
    self.status = 0;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.scroll.contentSize = CGSizeMake(self.view.frame.size.width*4, self.scroll.frame.size.height);
    self.scroll.pagingEnabled = YES;
    
    UIView *view = [UIView new];
    
//    self.paymentTableView.tableHeaderView = view;
//    self.paymentTableView.tableFooterView = [[UIView alloc] init];
    _x = self.blueLine.frame.origin.x;
    _color = _nowLabel.textColor;
    _color2 = _onceLabel.textColor;
//    self.paymentTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
//    self.finishTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _paymentArray = [NSMutableArray array];
    _finishArray = [NSMutableArray array];
    
    for (int i = 0; i < 4; i ++) {
        UITableView *tabView = [self.scroll viewWithTag:1000 + i];
        tabView.tableHeaderView = [[UIView alloc] init];
        tabView.separatorStyle=UITableViewCellSeparatorStyleNone;
    }
    
//    [self request];
    self.dataList = [@[@[],@[],@[],@[]] mutableCopy];
    [self requestQuery:self.status];
}

- (void) request
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uid = [defaults objectForKey:@"uid"];
    if (uid.length) {
        __weak __typeof(self) weakSelf = self;
        NSDictionary *d = @{@"uid":uid};
        [[NetworkTool sharedTool] requestWithURLString:@"GoodsOrder/findUserOrder" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
            NSLog(@"%@      ------------- %@", stringData, JSON );
            NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
            if ([code isEqualToString:@"1"]) {
                NSArray *array = [NSArray arrayWithArray:[JSON objectForKey:@"Data"]];
                for (NSDictionary *dic in array) {
                    NSString *string = [NSString stringWithFormat:@"%@", [dic objectForKey:@"orderState"]];
                    if ([string isEqualToString:@"2"]) {
                        [_finishArray addObject:dic];
                    } else{
                        [_paymentArray addObject:dic];
                    }
                }
//                [weakSelf.paymentTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
//                [weakSelf.finishTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            } else {
                
            }
        } failed:^(NSError *error) {
            //        [weakSelf requestError];
        }];
    }
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"myorder" forIndexPath:indexPath];
//    NSDictionary *dic = [NSDictionary dictionary];
//    return cell;
    NSInteger index = tableView.tag - 1000;
    NSDictionary *dic = ((NSArray *)self.dataList[index])[indexPath.row];
    
//    if (tableView == self.paymentTableView) {
//        cell = [tableView dequeueReusableCellWithIdentifier:@"myorder" forIndexPath:indexPath];
//        dic = [NSDictionary dictionaryWithDictionary:[_paymentArray objectAtIndex:indexPath.row]];
//    } else {
//        cell = [tableView dequeueReusableCellWithIdentifier:@"myfinishorder" forIndexPath:indexPath];
//        dic = [NSDictionary dictionaryWithDictionary:[_finishArray objectAtIndex:indexPath.row]];
//    }
    
    UIImageView *icon = (UIImageView *) [cell viewWithTag:1];
    [icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [dic objectForKey:@"smallIcon"]]]];
    
    UILabel *type = (UILabel *) [cell viewWithTag:2];
    type.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"name"]];
    
    UILabel *state = (UILabel *) [cell viewWithTag:3];
    NSString *orderState = [dic objectForKey:@"status"];
    UIButton *lBtn = [cell.contentView viewWithTag:80];
    UIButton *rBtn = [cell.contentView viewWithTag:81];
    
    if ([orderState isEqualToString:@"0"]) {
        lBtn.alpha = 1;
        rBtn.alpha = 1;
        orderState = @"待付款";
        [lBtn setTitle:@"点击付款" forState:UIControlStateNormal];
        [rBtn setTitle:@"取消订单" forState:UIControlStateNormal];
    } else if ([orderState isEqualToString:@"1"]) {
        orderState = @"待收货";
        lBtn.alpha = 1;
        rBtn.alpha = 1;
        [lBtn setTitle:@"确认收货" forState:UIControlStateNormal];
        [rBtn setTitle:@"查看物流" forState:UIControlStateNormal];
    } else if ([orderState isEqualToString:@"2"]) {
        orderState = @"已取消";
//        [lBtn setTitle:@"" forState:UIControlStateNormal];
//        [rBtn setTitle:@"" forState:UIControlStateNormal];
        lBtn.alpha = 0;
        rBtn.alpha = 0;
    }else{
        lBtn.alpha = 0;
        rBtn.alpha = 1;
        orderState = @"已完成";
//        [lBtn setTitle:@"" forState:UIControlStateNormal];
        [rBtn setTitle:@"申请售后" forState:UIControlStateNormal];
    }
//    （0：未支付 1：已支付 3：已取消 4:已完成）
    state.text = orderState;
    
    UIImageView *pic = (UIImageView *) [cell viewWithTag:4];
    [pic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [dic objectForKey:@"titleImage"]]]];

    UILabel *name = (UILabel *) [cell viewWithTag:5];
    name.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"description"]];

    UILabel *productPrice = (UILabel *) [cell viewWithTag:6];
    productPrice.text = [NSString stringWithFormat:@"%@ USDT", [dic objectForKey:@"price"]];
    
    UILabel *productNumber = (UILabel *) [cell viewWithTag:7];
    productNumber.text = [NSString stringWithFormat:@"x%@", [dic objectForKey:@"count"]];
    
//    UILabel *freight = (UILabel *) [cell viewWithTag:8];
    UILabel *productTotal = (UILabel *) [cell viewWithTag:9];
    UILabel *all = (UILabel *) [cell viewWithTag:10];
    productTotal.text = [NSString stringWithFormat:@"%@ USDT", [dic objectForKey:@"totalMoney"]];
    all.text = [NSString stringWithFormat:@"共%@件商品  合计:", [dic objectForKey:@"count"]];
    
//    CGSize nameSize = [freight.text boundingRectWithSize:CGSizeMake(freight.frame.size.width, freight.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:freight.font} context:nil].size;

//    freight.frame = CGRectMake(self.view.frame.size.width-nameSize.width-16, freight.frame.origin.y, nameSize.width, freight.frame.size.height);
//    nameSize = [productTotal.text boundingRectWithSize:CGSizeMake(productTotal.frame.size.width, productTotal.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:productTotal.font} context:nil].size;
//    productTotal.frame = CGRectMake(freight.frame.origin.x-nameSize.width-3, productTotal.frame.origin.y, nameSize.width, productTotal.frame.size.height);
//    nameSize = [all.text boundingRectWithSize:CGSizeMake(all.frame.size.width, all.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:all.font} context:nil].size;
//    all.frame = CGRectMake(productTotal.frame.origin.x-nameSize.width-5, all.frame.origin.y, nameSize.width, all.frame.size.height);

    
    
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    NSInteger index = tableView.tag - 1000;
    return ((NSArray *)self.dataList[index]).count;
//    if (tableView == self.paymentTableView) {
//        return _paymentArray.count;
//    }
//    return _finishArray.count;
//    return 4;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 250*kScaleH;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSDictionary *dic;
    
//    if (tableView == self.paymentTableView) {
//        dic = [NSDictionary dictionaryWithDictionary:[_paymentArray objectAtIndex:indexPath.row]];
//    } else {
//        dic = [NSDictionary dictionaryWithDictionary:[_finishArray objectAtIndex:indexPath.row]];
//    }
//    MyOrderInfoViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MyOrderInfoVC"];
//    vc.dataDic = dic;
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x != 0 && scrollView == self.scroll) {
        CGRect frame = self.blueLine.frame;
        NSInteger x = 4;
        frame.origin.x = scrollView.contentOffset.x/x+_x;
        self.blueLine.frame = frame;
    }
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat f = scrollView.contentOffset.x/self.view.frame.size.width;
    self.status = f;
    for (int i = 0; i < 4; i ++) {
        UILabel *lab = [self.view viewWithTag:50 + i];
        if (i == f) {
            lab.textColor = _color;
        }else{
            lab.textColor = _color2;
        }
    }
    if (((NSArray *)self.dataList[self.status]).count == 0) {
        [self requestQuery:self.status];
    }
//    if (f == 0) {
//        _nowLabel.textColor = _color;
//        _onceLabel.textColor = _color2;
//    } else {
//        _nowLabel.textColor = _color2;
//        _onceLabel.textColor = _color;
//    }
}
//- (IBAction)nowBtnClick:(id)sender {
//    [self.scroll scrollRectToVisible:CGRectMake(0, self.scroll.frame.origin.y, self.scroll.frame.size.width, self.scroll.frame.size.height) animated:YES];
//    _nowLabel.textColor = _color;
//    _onceLabel.textColor = _color2;
//}
//- (IBAction)onceBtnClick:(id)sender {
//    [self.scroll scrollRectToVisible:CGRectMake(self.view.frame.size.width, self.scroll.frame.origin.y, self.scroll.frame.size.width, self.scroll.frame.size.height) animated:YES];
//    _nowLabel.textColor = _color2;
//    _onceLabel.textColor = _color;
//}
- (IBAction)selBtnClick:(id)sender {
    NSInteger index = ((UIButton *)sender).tag - 100;
    
    for (int i = 0; i < 4; i ++) {
        UILabel *lab = [self.view viewWithTag:50 + i];
        if (i == index) {
            lab.textColor = _color;
        }else{
            lab.textColor = _color2;
        }
    }
    [self.scroll setContentOffset:CGPointMake(self.view.frame.size.width * index, 0) animated:YES];
    if (((NSArray *)self.dataList[index]).count == 0) {
        self.status = index;
        [self requestQuery:self.status];
    }
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cellLeftBtnClick:(id)sender {
    UIView *v = (UIView *)sender;
     UITableViewCell *cell;
    for (int i = 0; i < 5; i++) {
        v = v.superview;
        
       
//        [cell]
        if ([v.class isEqual:[UITableViewCell class]]) {
            cell = (UITableViewCell *)v;
        }
        if ([v.class isEqual:[UITableView class]]) {
            UITableView *tabV = (UITableView *)v;
            NSInteger index = tabV.tag - 1000;
            NSIndexPath *indexPath = [tabV indexPathForCell:cell];
            NSArray *data = self.dataList[index];
            NSDictionary *item = data[indexPath.row];
            if (index == 0) {//点击付款
                
                PayViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PayVC"];
                vc.money = [NSString stringWithFormat:@"%@", item[@"totalMoney"]];
                vc.idString = [NSString stringWithFormat:@"%@", [item objectForKey:@"orderId"]];
                [self.navigationController pushViewController:vc animated:YES];
            }else if (index == 1) {//确认收货
                [self requestCerifyGoodsOrderId:item[@"orderId"]];
            }
            
            return;
        }
    }
}
- (IBAction)cdllRightBtnClick:(id)sender {
    UIView *v = (UIView *)sender;
     UITableViewCell *cell;
    for (int i = 0; i < 5; i++) {
        v = v.superview;
        if ([v.class isEqual:[UITableViewCell class]]) {
            cell = (UITableViewCell *)v;
        }
        if ([v.class isEqual:[UITableView class]]) {
           
            
            
            UITableView *tabV = (UITableView *)v;
            NSInteger index = tabV.tag - 1000;
            NSIndexPath *indexPath = [tabV indexPathForCell:cell];
            NSArray *data = self.dataList[index];
            NSDictionary *item = data[indexPath.row];
            if (index == 0) {//取消订单
                [self requestCancelOrderId:item[@"orderId"]];
            }else if (index == 1) {//查看物流
                [self showToastWithMessage:@"小蚂蚁：暂无物流信息"];
            }else if (index == 2) {
                
            }else if (index == 3) {//申请售后
                [self showService];
            }
            
            return;
        }
    }
}
///v1/mall/product/order/verifyGoods

- (void)requestCerifyGoodsOrderId:(NSString *)orderId{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    if (token.length) {
        __weak __typeof(self) weakSelf = self;
        NSDictionary *d = @{@"token":token,@"productOrderId":orderId};
        [[NetworkTool sharedTool] requestWithURLString:@"/v1/mall/product/order/verifyGoods" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
            NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
            if ([code isEqualToString:@"1"]) {
                [self showToastWithMessage:@"小蚂蚁：确认收货成功"];
                [self requestQuery:self.status];
                self.dataList = [@[@[],@[],@[],@[]] mutableCopy];
            } else {
                
            }
        } failed:^(NSError *error) {
            //        [weakSelf requestError];
        }];
    }
}
///v1/mall/product/order/cancel
- (void)requestCancelOrderId:(NSString *)orderId{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    if (token.length) {
        __weak __typeof(self) weakSelf = self;
        NSDictionary *d = @{@"token":token,@"productOrderId":orderId};
        [[NetworkTool sharedTool] requestWithURLString:@"/v1/mall/product/order/cancel" parameters:d method:@"POST" completed:^(id JSON, NSString *stringData) {
            NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
            if ([code isEqualToString:@"1"]) {
                [self showToastWithMessage:@"已取消"];
                [self requestQuery:self.status];
                self.dataList = [@[@[],@[],@[],@[]] mutableCopy];
            } else {
                
            }
        } failed:^(NSError *error) {
            //        [weakSelf requestError];
        }];
    }
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
