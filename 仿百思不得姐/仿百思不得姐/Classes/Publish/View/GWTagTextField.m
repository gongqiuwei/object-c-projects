//
//  GWTagTextField.m
//  仿百思不得姐
//
//  Created by apple on 16/5/3.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//

#import "GWTagTextField.h"

@implementation GWTagTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.placeholder = @"多个标签用逗号或者换行隔开";
        // placeholder是使用懒加载创建的，如果不设置placeholer是不会创建_placeholderLabel的，下面的设置代码也就不会起作用
        [self setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
        
        self.height = GWTagH;
    }
    return self;
}

- (void)deleteBackward
{
    // 删除之前通知外部
    !self.deleteBlock ?: self.deleteBlock();
    
    // 系统用来删除的方法
    [super deleteBackward];
}

@end
