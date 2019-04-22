//
//  ExamineViewController.m
//  BitCoin
//
//  Created by LBH on 2017/11/2.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import "ExamineViewController.h"

@interface ExamineViewController ()

@end

@implementation ExamineViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setBarBlackColor:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self.status isEqualToString:@"1"]) {
        self.successBG.hidden = NO;
    } else {
        self.successBG.hidden = YES;
    }
    
}

- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
