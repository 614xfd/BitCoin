//
//  CustomAlertView.m
//  BitCoin
//
//  Created by LBH on 2017/9/29.
//  Copyright © 2017年 LBH. All rights reserved.
//

#import "CustomAlertView.h"

@implementation CustomAlertView {
    NSString *_selectString;
    NSArray *_dataArray;
}

- (id) initWithFrame:(CGRect)frame andDataArray:(NSArray *)array
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        
        _dataArray = [NSArray arrayWithArray:array];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake((frame.size.width-270)/2, (frame.size.height-225)/2, 270, 225)];
        view.backgroundColor = [UIColor whiteColor];
        [self addSubview:view];
        [view.layer setMasksToBounds:YES];
        view.layer.cornerRadius = 12;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, 60)];
        label.text = @"选择已购理财";
        label.font = [UIFont boldSystemFontOfSize:16];
        label.textAlignment = NSTextAlignmentCenter;
        [view addSubview:label];

        UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, view.frame.size.width, 115)];
        pickerView.backgroundColor = [UIColor whiteColor];
        pickerView.delegate = self;
        pickerView.dataSource = self;
        [view addSubview:pickerView];

        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, view.frame.size.height-60, view.frame.size.width, 1)];
        line.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [view addSubview:line];
        
        UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width/2-1, line.frame.origin.y, 1, 60)];
        line2.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [view addSubview:line2];
        
        UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancleBtn.frame = CGRectMake(0, line.frame.origin.y, view.frame.size.width/2, 60);
        [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancleBtn setTitleColor:[UIColor colorWithRed:0 green:122/255.0 blue:1 alpha:1] forState:UIControlStateNormal];
        cancleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [cancleBtn addTarget:self action:@selector(hiddenView) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:cancleBtn];
        
        UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selectBtn.frame = CGRectMake(view.frame.size.width/2, line.frame.origin.y, view.frame.size.width/2, 60);
        [selectBtn setTitle:@"确定" forState:UIControlStateNormal];
        [selectBtn setTitleColor:[UIColor colorWithRed:0 green:122/255.0 blue:1 alpha:1] forState:UIControlStateNormal];
        selectBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [selectBtn addTarget:self action:@selector(returnData) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:selectBtn];
        
        
    }
    return self;
}

- (void) returnData
{
    [self.delegate returnSelectDic:[NSDictionary dictionaryWithObjectsAndKeys:_selectString, @"title", nil]];
    [self hiddenView];
}

//UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件包含的列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1; // 返回1表明该控件只包含1列
}

//UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件指定列包含多少个列表项
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    // 由于该控件只包含一列，因此无须理会列序号参数component
    // 该方法返回teams.count，表明teams包含多少个元素，该控件就包含多少行
    return _dataArray.count;
}


// UIPickerViewDelegate中定义的方法，该方法返回的NSString将作为UIPickerView
// 中指定列和列表项的标题文本
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    // 由于该控件只包含一列，因此无须理会列序号参数component
    // 该方法根据row参数返回teams中的元素，row参数代表列表项的编号，
    // 因此该方法表示第几个列表项，就使用teams中的第几个元素
    _selectString = [_dataArray objectAtIndex:row];
    return _selectString;
}

// 当用户选中UIPickerViewDataSource中指定列和列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component
{
    
}

- (void) hiddenView
{
    [self removeFromSuperview];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hiddenView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
