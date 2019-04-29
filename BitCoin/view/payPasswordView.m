//
//  payPasswordView.m
//  BitCoin
//
//  Created by CCC on 2019/4/24.
//  Copyright © 2019年 LBH. All rights reserved.
//

#import "payPasswordView.h"

@implementation payPasswordView {
    NSMutableArray *_array;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle] loadNibNamed:@"payPasswordView" owner:self options:nil] lastObject];
    if (self) {
        self.frame = frame;
        _array = [NSMutableArray arrayWithObjects:@"a", @"a", @"a", @"a", @"a", @"a", nil];
    }
    return self;
}


- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 0) {
        textView.text = [textView.text substringToIndex:1];
        [_array replaceObjectAtIndex:textView.tag-20 withObject:textView.text];
    }
    int x = 0;
    for (int i = 20; i < 26; i++) {
        UITextView *tf = (UITextView *)[self viewWithTag:i];
        if (tf.text.length>0) {
            x++;
//            [_array replaceObjectAtIndex:i-20 withObject:tf.text];
            if (x == 6) {
//                NSLog(@"%@", array);
                // 验证支付密码
                //                [self pay:[array componentsJoinedByString:@""]];
//                _payString = [array componentsJoinedByString:@""];
//                [self order];
                [self.delegate returnPayPassword:[self md5:[_array componentsJoinedByString:@""]]];
                [self hiddenPayPasswordView];
            }
            if (x>0) {
                UITextView *t = (UITextView *)[self viewWithTag:i-1];
                t.text = @"•";
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
    }
    return YES;
}

- (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
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
