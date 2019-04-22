//
//  NewShareViewController.m
//  BitCoin
//
//  Created by mac on 2019/4/20.
//  Copyright © 2019 LBH. All rights reserved.
//

#import "NewShareViewController.h"

@interface NewShareViewController ()

@end

@implementation NewShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"share_bg.png"]];
    self.codeLab.text = self.codeStr;
}
- (IBAction)copyBtnClick:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = @"你好";
    [self showToastWithMessage:@"小蚂蚁:已复制到粘贴板"];
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
