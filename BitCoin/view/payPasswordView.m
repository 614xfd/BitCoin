//
//  payPasswordView.m
//  BitCoin
//
//  Created by CCC on 2019/4/24.
//  Copyright © 2019年 LBH. All rights reserved.
//

#import "payPasswordView.h"

@implementation payPasswordView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle] loadNibNamed:@"payPasswordView" owner:self options:nil] lastObject];
    if (self) {
        self.frame = frame;
        
    }
    return self;
}


- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 0) {
        textView.text = [textView.text substringToIndex:1];
    }
    int x = 0;
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"a", @"a", @"a", @"a", @"a", @"a", nil];
    for (int i = 20; i < 26; i++) {
        UITextView *tf = (UITextView *)[self viewWithTag:i];
        if (tf.text.length>0) {
            x++;
            [array replaceObjectAtIndex:i-20 withObject:tf.text];
            if (x == 6) {
//                NSLog(@"%@", array);
                // 验证支付密码
                //                [self pay:[array componentsJoinedByString:@""]];
//                _payString = [array componentsJoinedByString:@""];
//                [self order];
                [self.delegate returnPayPassword:[array componentsJoinedByString:@""]];
                [self hiddenPayPasswordView];
            }
            continue;
        } else {
            if (textView.text.length < 1) {
                continue;
            }
            NSInteger y = 20;
            if (textView.tag == 6) {
                y = 20;
            } else {
                y = textView.tag;
            }
            UITextView *tv = (UITextView *)[self viewWithTag:y+1];
            [tv becomeFirstResponder];
        }
    }
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSInteger x = textView.tag;
    if (x == 20) {
        x = 27;
    }
    if ([text isEqualToString:@""]) {
        UITextView *tv = (UITextView *)[self viewWithTag:x-1];
        tv.text = @"";
        textView.text = @"";
        [tv becomeFirstResponder];
    } else {
        textView.text = @"•";
    }
    return YES;
}

- (IBAction)hiddenBtnClick:(id)sender {
    [self hiddenPayPasswordView];
}

- (void) hiddenPayPasswordView
{
    [self removeFromSuperview];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
