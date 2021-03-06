//
//  AboutMeViewController.m
//  BitCoin
//
//  Created by LBH on 2017/11/16.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import "AboutMeViewController.h"
#define UILABEL_LINE_SPACE 6
#define HEIGHT [ [ UIScreen mainScreen ] bounds ].size.height

@interface AboutMeViewController ()

@end

@implementation AboutMeViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setBarBlackColor:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.scroll.contentSize = CGSizeMake(self.view.frame.size.width, 800*kScaleH);
    
    
    
    
//    CGSize size = [self.textLabel.text boundingRectWithSize:CGSizeMake(self.textLabel.frame.size.width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
//    AboutMeViewController
    [self setTextLabelText:self.textLabel.text];
    [self requestInfo];
}
- (void)setTextLabelText:(NSString *)text{
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
    NSDictionary *dic = @{NSFontAttributeName:self.textLabel.font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.f};
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:text attributes:dic];
    self.textLabel.attributedText = attributeStr;
}

- (void)requestInfo{
    __weak __typeof(self) weakSelf = self;
    [[NetworkTool sharedTool] requestWithURLString:@"/about/us/info" parameters:nil method:@"POST" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@      ------------- %@", stringData, JSON );
        NSString *code = [NSString stringWithFormat:@"%@", [JSON objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            [weakSelf setTextLabelText:[JSON objectForKey:@"data"]];
        } else {
        }
    } failed:^(NSError *error) {
        //        [weakSelf requestError];
    }];
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
