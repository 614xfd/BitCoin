//
//  BaseTabBarViewController.m
//  BitCoin
//
//  Created by LBH on 2017/9/28.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import "BaseTabBarViewController.h"

#define WIDTH self.view.frame.size.width
#define BTNWIDTH self.view.frame.size.width/5

@interface BaseTabBarViewController () {
    NSMutableArray *_arr;
    NSMutableArray *_changeArr;
    NSInteger _select;
}

@end

@implementation BaseTabBarViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self.selectedViewController beginAppearanceTransition: YES animated: animated];
}

-(void) viewDidAppear:(BOOL)animated
{
    [self.selectedViewController endAppearanceTransition];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [self.selectedViewController beginAppearanceTransition: NO animated: animated];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [self.selectedViewController endAppearanceTransition];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _arr = [NSMutableArray arrayWithObjects:@"hq1.png", @"sc1.png", @"yd1.png", @"wk1.png", @"me1.png", nil];
    _changeArr = [NSMutableArray arrayWithObjects:@"hq2.png", @"sc2.png", @"yd2.png", @"wk2.png", @"me2.png", nil];
    [self.tabBar setHidden:YES];
    self.tabBar.frame = CGRectMake(0, 10000, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
    _select = 0;
    [self creatView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reBack)name:@"RE_BACK" object:nil];
}

- (void) creatView
{
    if (self.bgView) {
        [self.bgView removeFromSuperview];
    }
    
    //    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-49*scale, self.view.frame.size.width, 49*scale)];
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-49, self.view.frame.size.width, 49)];
    self.bgView.backgroundColor = [UIColor colorWithRed:2/255.0 green:60/255.0 blue:104/255.0 alpha:1];
    self.bgView.tag = 10086;
    [self.view addSubview:self.bgView];
    
    //    self.bgView.layer.shadowColor = [UIColor blackColor].CGColor;
    //    self.bgView.layer.shadowOpacity = 0.1f;
    //    self.bgView.layer.shadowOffset = CGSizeMake(2,2);
    
    //    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, -17, self.view.frame.size.width, 24)];
    //    image.image = [UIImage imageNamed:@"tabbar.png"];
    //    [self.bgView addSubview:image];
    //
    //    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, self.view.frame.size.width, 46)];
    //    label.backgroundColor = [UIColor whiteColor];
    //    [self.bgView addSubview:label];
    
    //    [self.bgView sendSubviewToBack:label];
    //    [self.bgView sendSubviewToBack:image];
    
    //    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0.5)];
    //    line.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    //    [self.bgView addSubview:line];
    NSArray *titleArray = @[@"首页",@"商城",@"矿池",@"快讯",@"个人"];
    //将按钮添加到自定义的_tabbarView中，并为按钮设置tag（tag从0开始）
    for (int i=0; i<_arr.count; i++) {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake((WIDTH/_arr.count-24)/2+BTNWIDTH*i, (self.bgView.frame.size.height-24)/2-6, 24, 24)];
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(BTNWIDTH*i, image.frame.size.height+image.frame.origin.y, BTNWIDTH, self.bgView.frame.size.height-image.frame.size.height-image.frame.origin.y)];
        image.image = [UIImage imageNamed:[_arr objectAtIndex:i]];
        
        titleL.text = [titleArray objectAtIndex:i];
        titleL.font = [UIFont systemFontOfSize:12 weight:UIFontWeightLight];
        titleL.textColor = [UIColor colorWithRed:157/255.0 green:157/255.0 blue:181/255.0 alpha:1];
        titleL.textAlignment = NSTextAlignmentCenter;
        if (i == 0) {
            image.image = [UIImage imageNamed:[_changeArr objectAtIndex:i]];
            titleL.textColor = [UIColor colorWithRed:5/255.0 green:211/255.0 blue:184/255.0 alpha:1];
        }
        image.tag = i+10;
        titleL.tag = i+20;
        [self.bgView addSubview:image];
        [self.bgView addSubview:titleL];
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(BTNWIDTH*i, 0, BTNWIDTH, 49);
        button.tag = i+1;
        //        [button setImage:[UIImage imageNamed:[_arr objectAtIndex:i]] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor clearColor]];
        [button addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:button];
    }
}

- (void)selectedTab:(UIButton *)button
{
    for (int i = 0; i < _arr.count; i++) {
        UIImageView *image = (UIImageView *)[self.bgView viewWithTag:i+10];
        //        [image sd_setImageWithURL:[NSURL URLWithString:[_arr objectAtIndex:i]]];
        //        [image ImageString:[_arr objectAtIndex:i]];
        image.image = [UIImage imageNamed:[_arr objectAtIndex:i]];
        UILabel *label = (UILabel *)[self.bgView viewWithTag:i+20];
        label.textColor = [UIColor colorWithRed:157/255.0 green:157/255.0 blue:181/255.0 alpha:1];
    }
    UIImageView *image = (UIImageView *)[self.bgView viewWithTag:button.tag-1+10];
    //    [image sd_setImageWithURL:[NSURL URLWithString:[_changeArr objectAtIndex:button.tag-1]]];
    //    [image ImageString:[_changeArr objectAtIndex:button.tag-1]];
    image.image = [UIImage imageNamed:[_changeArr objectAtIndex:button.tag-1]];
    UILabel *label = (UILabel *)[self.bgView viewWithTag:button.tag-1+20];
    label.textColor = [UIColor colorWithRed:5/255.0 green:211/255.0 blue:184/255.0 alpha:1];
    
    //    NSMutableDictionary *dic = [AdsViewController stringParse:[[_dataArr objectAtIndex:button.tag-1] objectForKey:@"IconLink"]];
    //    AdsViewController *vc = [[AdsViewController alloc] init];
    //    vc.delegate = self;
    //    NSMutableDictionary *dic = [vc stringParse:[[_dataArr objectAtIndex:button.tag-1] objectForKey:@"IconLink"]];
    //    if (!dic.count) {
    //        return;
    //    }
    
    //    int x = [[dic objectForKey:@"index"] intValue];
    
    //    if (x == 8) {
    //        x = 7;
    //    }
    
    self.selectedIndex = button.tag-1;
    if (button.tag-1 != 3) {
        _select = button.tag-1;
    }
    
}

- (void) reBack
{
    for (int i = 0; i < _arr.count; i++) {
        UIImageView *image = (UIImageView *)[self.bgView viewWithTag:i+10];
        image.image = [UIImage imageNamed:[_arr objectAtIndex:i]];
    }
    
    UIImageView *image = (UIImageView *)[self.bgView viewWithTag:_select+10];
    image.image = [UIImage imageNamed:[_changeArr objectAtIndex:_select]];
    self.selectedIndex = _select;
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
