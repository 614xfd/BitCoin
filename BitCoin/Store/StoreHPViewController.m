//
//  StoreHPViewController.m
//  BitCoin
//
//  Created by LBH on 2017/9/29.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import "StoreHPViewController.h"
#import "StoreInfoViewController.h"
#import "WebViewController.h"

@interface StoreHPViewController () {
//    NSArray *_array1;
//    NSArray *_array2;
//    NSArray *_array3;
//    NSArray *_array4;
//    NSArray *_array5;
//    NSArray *_array6;
    NSArray *_dataArray;
    NSArray *_imageArray;
    ImagesScrollView *_adsScrollView;
    UIView *_view;
}

@end

@implementation StoreHPViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setBarBlackColor:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    _array1 = @[@"商城_05.png", @"商城_08.png"];
//    _array2 = @[@"比特币图标.png", @"达世币图标.png"];
//    _array3 = @[@"比特币矿机", @"达世币矿机"];
//    _array4 = @[@"比特币蚂蚁S9矿机14T", @"iBeLink X11达世矿机10.8G"];
//    _array5 = @[@"全新现货（带电源）", @"全新现货、二手现货（运行7天）"];
//    _array6 = @[@"￥ 1300", @"￥ 29000"];
    _dataArray = [NSArray array];
    if (@available(iOS 11.0, *)) {
        [self.tableView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
   _view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 270)];
//    view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:249/255.0 alpha:1];
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 259, self.view.frame.size.width, 1)];
    line.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:249/255.0 alpha:1];
    [_view addSubview:line];
    
    NSArray *array = @[@"用专业的水准", @"供质优的产品", @"做可靠的服务"];
    NSArray *a = @[@"专.png", @"质.png", @"信.png"];
    for (int i = 0; i < array.count; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i*self.view.frame.size.width/3, 200, self.view.frame.size.width/3, 60)];
        label.text = [array objectAtIndex:i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor colorWithRed:217/255.0 green:191/255.0 blue:121/255.0 alpha:1];
        [_view addSubview:label];
        
//        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
//        attach.image = [UIImage imageNamed:[a objectAtIndex:i]];
//        attach.bounds = CGRectMake(0, 0, 16, 18);
//        NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attach];
//        NSAttributedString *t = [[NSMutableAttributedString alloc] initWithString:label.text];
//        NSMutableAttributedString *txt = [[NSMutableAttributedString alloc] initWithAttributedString:attachString];
//        [txt appendAttributedString:t];
//        label.attributedText = txt;
        
        // 创建一个富文本
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", label.text]];
        // 添加表情
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
        // 表情图片
        attch.image = [UIImage imageNamed:[a objectAtIndex:i]];
        // 设置图片大小
        attch.bounds = CGRectMake(0, -5, 19, 18);
        
        // 创建带有图片的富文本
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
        [attri insertAttributedString:string atIndex:0];
        // 用label的attributedText属性来使用富文本
        label.attributedText = attri;

    }
    [self request];
    [self requestImage];
    
    self.tableView.tableHeaderView = _view;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void) creatImageWith:(NSArray *)arr
{
    _adsScrollView = [[ImagesScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200) withImagesArray:arr isRound:NO withImageWidth:self.view.frame.size.width withImageHeight:200 isSmall : NO time:5.0 tag:100];
    _adsScrollView.tag = 100;
    _adsScrollView.delegate = self;
    [_view addSubview:_adsScrollView];

}

- (void) request
{
    __weak __typeof(self) weakSelf = self;
    NSDictionary *dic = @{};
    [[NetworkTool sharedTool] requestWithURLString:@"product/findProduct" parameters:dic method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@", stringData, JSON );
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            _dataArray = [JSON objectForKey:@"Data"];
            if (_dataArray.count) {
                [weakSelf.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            }

        } else {
            [weakSelf performSelectorOnMainThread:@selector(showToastWithMessage:) withObject:[JSON objectForKey:@"msg"] waitUntilDone:YES];
        }
    } failed:^(NSError *error) {
    }];
}

- (void) requestImage
{
    __weak __typeof(self) weakSelf = self;
    [[NetworkTool sharedTool] requestWithURLString:@"FindCarouselFigure/findMallCarousel" parameters:nil method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@", stringData, JSON );
        //        NSString *isError = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            //                        [weakSelf verifyPass];
            NSArray *array = [JSON objectForKey:@"Data"];
            NSMutableArray *arr = [NSMutableArray array];
            for (int i = 0; i < array.count; i++) {
                NSString *str = [[array objectAtIndex:i] objectForKey:@"mallImage"];
                [arr addObject:str];
            }
            _imageArray = [NSArray arrayWithArray:array];
            [weakSelf performSelectorOnMainThread:@selector(creatImageWith:) withObject:[NSArray arrayWithArray:arr] waitUntilDone:YES];
        } else {
            
        }
    } failed:^(NSError *error) {
        //        [weakSelf requestError];
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"store" forIndexPath:indexPath];
    
    NSString *string = [[_dataArray objectAtIndex:indexPath.row] objectForKey:@"productsTitleImg"];
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
//    imageView.image = [UIImage imageNamed:[_array1 objectAtIndex:indexPath.row]];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_URL,string]]];
    
    NSString *str = [[_dataArray objectAtIndex:indexPath.row] objectForKey:@"productsTypeImg"];
    UIImageView *image = (UIImageView *)[cell viewWithTag:2];
//    image.image = [UIImage imageNamed:[_array2 objectAtIndex:indexPath.row]];
    [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_URL,str]]];

    
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:3];
//    nameLabel.text = [_array3 objectAtIndex:indexPath.row];
    nameLabel.text = [[_dataArray objectAtIndex:indexPath.row] objectForKey:@"productsType"];
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:4];
//    titleLabel.text = [_array4 objectAtIndex:indexPath.row];
    titleLabel.text = [[_dataArray objectAtIndex:indexPath.row] objectForKey:@"productsName"];
    
    UILabel *subTitleLabel = (UILabel *)[cell viewWithTag:5];
//    subTitleLabel.text = [_array5 objectAtIndex:indexPath.row];
    subTitleLabel.text = [[_dataArray objectAtIndex:indexPath.row] objectForKey:@"productsTitle"];

    UILabel *priceLabel = (UILabel *)[cell viewWithTag:6];
//    priceLabel.text = [_array6 objectAtIndex:indexPath.row];
    NSString *string1 = [[_dataArray objectAtIndex:indexPath.row] objectForKey:@"productsPrice"];
    double s = [string1 doubleValue];
    priceLabel.text = [NSString stringWithFormat:@"%.2lf USDT", s];

    
    UIButton *infoBtn = (UIButton * ) [cell viewWithTag:7];
    [infoBtn.layer setMasksToBounds:YES];
    infoBtn.layer.cornerRadius = 4;
    [infoBtn.layer setBorderWidth:0.5];
    [infoBtn.layer setBorderColor:[UIColor colorWithRed:140/255.0 green:140/255.0 blue:140/255.0 alpha:1].CGColor];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 380;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StoreInfoViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StoreInfoVC"];
    vc.dic = [_dataArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark  循环scroll广告点击事件跳转
- (void) index:(unsigned long)index tag:(unsigned long)tag
{
    NSString *string;
    if (tag == 100) {
        NSLog(@"1 : %ld, tag = %ld",index, tag);
        string = [[_imageArray objectAtIndex:index] objectForKey:@"url"];
    }
    if (![string isEqualToString:@"0"] && string.length) {
        WebViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WebVC"];
        vc.UrlString = string;
        [self.navigationController pushViewController:vc animated:YES];
    }
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
