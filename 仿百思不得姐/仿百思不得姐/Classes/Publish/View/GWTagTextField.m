//
//  GWTagTextField.m
//  仿百思不得姐
//
//  Created by apple on 16/5/3.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//

#import "GWTagTextField.h"

@implementation GWTagTextField

- (void)deleteBackward
{
    // 删除之前通知外部
    !self.deleteBlock ?: self.deleteBlock();
    
    // 系统用来删除的方法
    [super deleteBackward];
}

@end
