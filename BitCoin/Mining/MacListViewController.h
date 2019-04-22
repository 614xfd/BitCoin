//
//  MacListViewController.h
//  BitCoin
//
//  Created by LBH on 2018/8/11.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "BalanceViewController.h"

@protocol MacListDelegate <NSObject>

@optional
- (void) bindingSuccess;

@end

@interface MacListViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource, MacListDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *bgBtn;
@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UILabel *bgLabel;

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, weak) id <MacListDelegate> delegate;

- (void) reSetMacArray : (NSArray *)array;

@end
