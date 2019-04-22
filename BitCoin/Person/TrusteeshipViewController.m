//
//  TrusteeshipViewController.m
//  BitCoin
//
//  Created by LBH on 2018/2/6.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "TrusteeshipViewController.h"
#define UILABEL_LINE_SPACE 6
#define HEIGHT [ [ UIScreen mainScreen ] bounds ].size.height

@interface TrusteeshipViewController () {
    NSArray *_titleArray;
    NSArray *_contentArray;
    NSMutableArray *_highArray;
}

@end

@implementation TrusteeshipViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setBarBlackColor:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self request];
    if (@available(iOS 11.0, *)) {
        [self.tableView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    NSString *title = @"托管细则";
    NSString *title1 = @"托管风险";
    NSString *title2 = @"托管维护";
    NSString *title3 = @"矿机下架";
    NSString *title4 = @"联系人";
    _titleArray = @[title, title1, title2, title3, title4];
    
//    NSString *string = @"1.电费0.55元/度，按照理论功耗计算电费:   计算公式：单台每日电费为：0.55元/kWh*1kW*24小时=13.2元\n2.电费为预交模式，以所托管矿机数量乘以单台功耗乘以电费为计算依据，电费账单通过邮件发送至注册邮箱地址\n3.在官方发送电费账单后，请于3天内缴清电费，未及时缴清电费的将停机处理\n4.因电站停电而导致矿场停电的，停电期间不计算电费（以电站所提供停电时间为准）\n5.管理费为收益的10%，以收币的形式结算。";
    NSString *string = @"合规供电，安全稳定！托管用户可以通过Bitboss APP实时24小时远程监控！APP内置蚂蚁矿池，真正做到挖矿无忧躺着赚！";
    NSString *string1 = @"1.矿场可能停电\n2.矿场的局域网和与外部通信的网络都有可能会发生故障\n3.由于法律政策、战争、地震、火灾和电力故障等不可抗原因导致矿场无法继续运营时，提供托管服务的一方不承担赔偿责任。";
    NSString *string2 = @"1.矿场有专业人员对矿机进行定期维护\n2.若矿机出现停机、算力过低等异常情况，可通过矿工名向矿场人员报修\n3.矿场人员在收到报修请求后将会进行处理，处理完成时间取决于机器故障情况\n4.提供托管服务的一方不承担因机器维修而导致的收益损失，且电费仍按照理论功耗进行计算（维修时间超过15天的特殊处理）";
    NSString *stirng3 = @"1.需要取回矿机的用户需提前3个工作日向官方客服申报下架矿机\n2.寄送矿机所产生的运费由用户自行承担\n3.取回矿机前需缴清电费，否则将扣留矿机直至缴清电费";
    NSString *string4 = @"18926761180杨生";
    _contentArray = @[string, string1, string2, stirng3, string4];
    _highArray = [NSMutableArray array];
    
    for (int i = 0; i < _contentArray.count; i++) {
        UIFont *font = [UIFont systemFontOfSize:14];
        NSString *str = [_contentArray objectAtIndex:i];
 
        CGFloat f = [self getSpaceLabelHeight:str withFont:font withWidth:self.view.frame.size.width-24];
        [_highArray addObject:[NSString stringWithFormat:@"%lf", f]];
    }
    
}

- (void) creatImageView:(NSDictionary *)dic
{
    double w = self.view.frame.size.width;
    double h = w/[[dic objectForKey:@"width"] doubleValue]*[[dic objectForKey:@"height"] doubleValue];
    self.scroll.contentSize = CGSizeMake(w, h);
    self.bgImageView.frame = CGRectMake(0, 0, w, h);
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMAGE_URL, [dic objectForKey:@"homePicture"]]]];
    
}

- (void) request
{
    __weak __typeof(self) weakSelf = self;
    [[NetworkTool sharedTool] requestWithURLString:@"/HomePictuer/getTrusteeshipImg" parameters:nil method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@", stringData, JSON );
        if ([JSON[@"code"] isEqualToString:@"1"]) {
            [weakSelf performSelectorOnMainThread:@selector(creatImageView:) withObject:[JSON objectForKey:@"Data"] waitUntilDone:YES];
        }
        
    } failed:^(NSError *error) {
        //        [weakSelf requestError];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"trusteeship" forIndexPath:indexPath];
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:1];
    titleLabel.text = [_titleArray objectAtIndex:indexPath.row];
    
    UILabel *content = (UILabel *)[cell viewWithTag:2];
    NSString *str = [_contentArray objectAtIndex:indexPath.row];
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = UILABEL_LINE_SPACE; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:content.font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f};
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
    content.attributedText = attributeStr;
    
    CGFloat f = [self getSpaceLabelHeight:str withFont:content.font withWidth:content.frame.size.width];
    content.frame = CGRectMake(content.frame.origin.x, content.frame.origin.y, content.frame.size.width, f);

    if (indexPath.row == 0) {
        UIImageView *image = (UIImageView *)[cell viewWithTag:10];
        image.frame = CGRectMake(content.frame.origin.x, content.frame.origin.y+content.frame.size.height+15, self.view.frame.size.width-content.frame.origin.x*2, (self.view.frame.size.width-content.frame.origin.x*2)/1.53);
        image.image = [UIImage imageNamed:@"托管表格.png"];
        image.hidden = NO;
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return (90*kScaleH)+[[_highArray objectAtIndex:indexPath.row] doubleValue] + (self.view.frame.size.width-12*kScaleH*2)/1.53 +25;
    }
    return (90*kScaleH)+[[_highArray objectAtIndex:indexPath.row] doubleValue];
}

//计算UILabel的高度(带有行间距的情况)
-(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = UILABEL_LINE_SPACE;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f};
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
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
