//
//  AnnouncementInfoViewController.m
//  BitCoin
//
//  Created by LBH on 2018/9/19.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "AnnouncementInfoViewController.h"

@interface AnnouncementInfoViewController ()

@end

@implementation AnnouncementInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@", [self.dic objectForKey:@"title"]];
    
    self.timeLabbel.text = [NSString stringWithFormat:@"发送人: %@", [self.dic objectForKey:@"dateTime"]];
    
    self.content.text = [NSString stringWithFormat:@"%@", [self.dic objectForKey:@"content"]];
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
