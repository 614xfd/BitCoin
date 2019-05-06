//
//  NewStoreHPViewController.m
//  BitCoin
//
//  Created by LBH on 2019/4/14.
//  Copyright © 2019年 LBH. All rights reserved.
//

#import "NewStoreHPViewController.h"
#import "ImagesScrollView.h"
#import "StoreInfoViewController.h"

@interface NewStoreHPViewController () <ImagesScrollViewDelegate> {
    NSArray *_dataArray;
    NSArray *_imageArray;
    ImagesScrollView *_adsScrollView;
//    UIView *_view;
}
@property (nonatomic, assign)  CGFloat scale;

@end

@implementation NewStoreHPViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setBarBlackColor:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dataArray = [NSArray array];
    if (@available(iOS 11.0, *)) {
        [self.tableView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
//    if ([UIScreen mainScreen].bounds.size.height == 736) {
//        self.scale = 1.103;
//    } else if ([UIScreen mainScreen].bounds.size.height == 480) {
//        self.scale = 0.7196;
//    } else if ([UIScreen mainScreen].bounds.size.height == 568) {
//        self.scale = 0.851;
//    }
//    _view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200*self.scale)];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self requestImage];
    [self request];

}

- (void) request
{
    __weak __typeof(self) weakSelf = self;
    NSDictionary *dic = @{};
    [[NetworkTool sharedTool] requestWithURLString:@"mall/goods/getAll" parameters:dic method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@", stringData, JSON );
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            _dataArray = [JSON objectForKey:@"data"];
            if (_dataArray.count) {
                [weakSelf.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            }
            
        } else {
//            [weakSelf performSelectorOnMainThread:@selector(showToastWithMessage:) withObject:[JSON objectForKey:@"msg"] waitUntilDone:YES];
        }
    } failed:^(NSError *error) {
    }];
}

- (void) requestImage
{
    __weak __typeof(self) weakSelf = self;
    [[NetworkTool sharedTool] requestWithURLString:@"mall/carouse/getAll" parameters:nil method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@", stringData, JSON );
        //        NSString *isError = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            //                        [weakSelf verifyPass];
            NSArray *array = [JSON objectForKey:@"data"];
            NSMutableArray *arr = [NSMutableArray array];
            for (int i = 0; i < array.count; i++) {
                NSString *str = [NSString stringWithFormat:@"%@%@", [[array objectAtIndex:i] objectForKey:@"url"], [[array objectAtIndex:i] objectForKey:@"imagePath"]];
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


- (void) creatImageWith:(NSArray *)arr
{
    _adsScrollView = [[ImagesScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.headerView.frame.size.height) withImagesArray:arr isRound:NO withImageWidth:self.view.frame.size.width withImageHeight:self.headerView.frame.size.height isSmall : NO time:5.0 tag:100];
    _adsScrollView.tag = 100;
    _adsScrollView.delegate = self;
    [self.headerView addSubview:_adsScrollView];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newstore" forIndexPath:indexPath];

    NSDictionary *dic_L = [_dataArray objectAtIndex:indexPath.row*2];
    NSDictionary *dic_R = @{};
    if (_dataArray.count > indexPath.row*2+1) {
        dic_R = [_dataArray objectAtIndex:indexPath.row*2+1];
    }
    UIView *view_L = (UIView *) [cell.contentView viewWithTag:10];
    [view_L.layer setMasksToBounds:YES];
    view_L.layer.cornerRadius = 6;
    UIImageView *imageView_L = (UIImageView *) [cell.contentView viewWithTag:11];
    [imageView_L sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [dic_L objectForKey:@"titleImage"]]]];
    UILabel *title_L = (UILabel *) [cell.contentView viewWithTag:12];
    title_L.text = [NSString stringWithFormat:@"%@", [dic_L objectForKey:@"title"]];
    UILabel *subTitle_L = (UILabel *) [cell.contentView viewWithTag:13];
    subTitle_L.text = [NSString stringWithFormat:@"%@", [dic_L objectForKey:@"astract"]];
    UILabel *price_L = (UILabel *) [cell.contentView viewWithTag:14];
    price_L.text = [NSString stringWithFormat:@"%.2lf gtse", [[dic_L objectForKey:@"price"] doubleValue]];
    UIButton *btn_L = (UIButton *)[view_L.subviews objectAtIndex:4];
    btn_L.tag = 10000+indexPath.row*2;
    [btn_L addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    if (dic_R.count) {
        UIView *view_R = (UIView *) [cell.contentView viewWithTag:20];
        view_R.hidden = NO;
        [view_R.layer setMasksToBounds:YES];
        view_R.layer.cornerRadius = 6;
        UIImageView *imageView_R = (UIImageView *) [cell.contentView viewWithTag:21];
        [imageView_R sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [dic_R objectForKey:@"titleImage"]]]];
        UILabel *title_R = (UILabel *) [cell.contentView viewWithTag:22];
        title_R.text = [NSString stringWithFormat:@"%@", [dic_R objectForKey:@"title"]];
        UILabel *subTitle_R = (UILabel *) [cell.contentView viewWithTag:23];
        subTitle_R.text = [NSString stringWithFormat:@"%@", [dic_R objectForKey:@"astract"]];
        UILabel *price_R = (UILabel *) [cell.contentView viewWithTag:24];
        price_R.text = [NSString stringWithFormat:@"%.2lf gtse", [[dic_R objectForKey:@"price"] doubleValue]];
        UIButton *btn_R = (UIButton *)[view_R.subviews objectAtIndex:4];
        btn_R.tag = 10000+indexPath.row*2+1;
        [btn_R addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count%2==0?_dataArray.count/2:_dataArray.count/2+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 234;
}

- (void) selectBtn:(UIButton *) btn{
    NSInteger tag = btn.tag-10000;
    StoreInfoViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StoreInfoVC"];
    vc.dic = [_dataArray objectAtIndex:tag];
    [self.navigationController pushViewController:vc animated:YES];
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
