//
//  GWTextField.m
//  仿百思不得姐
//
//  Created by gongqiuwei on 16/4/16.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//

#import "GWTextField.h"
#import <objc/runtime.h>

static NSString *const GWPlacerholderColorKeyPath  = @"_placeholderLabel.textColor";

@implementation GWTextField
//+ (void)initialize
//{
//    [self getIvars];
//}

+ (void)getIvars
{
    // 使用runtime查找属性
    unsigned int count = 0;
    
    Ivar *ivars = class_copyIvarList([UITextField class], &count);
    
    for (int i = 0; i < count; i++) {
        
        Ivar ivar = ivars[i];
        
        const char *name = ivar_getName(ivar);
        
        NSLog(@"%s", name);
    }
    
    free(ivars);
}

- (void)awakeFromNib
{
    // 让光标的颜色和文字的颜色一致
    self.tintColor = self.textColor;
    
    // 失去第一响应
    [self resignFirstResponder];
}

/**
 * 当前文本框失去焦点时就会调用
 */
- (BOOL)resignFirstResponder
{
    // 设置placeholder的颜色
    [self setValue:[UIColor grayColor] forKeyPath:GWPlacerholderColorKeyPath];
    
    return [super resignFirstResponder];
}

/**
 * 当前文本框聚焦时就会调用
 */
- (BOOL)becomeFirstResponder
{
    // 设置placeholder的颜色
    [self setValue:self.textColor forKeyPath:GWPlacerholderColorKeyPath];
    
    return [super becomeFirstResponder];
}
@end
