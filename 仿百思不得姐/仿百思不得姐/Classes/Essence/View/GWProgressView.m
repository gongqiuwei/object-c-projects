//
//  GWProgressView.m
//  仿百思不得姐
//
//  Created by gongqiuwei on 16/4/22.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//

#import "GWProgressView.h"

@implementation GWProgressView

- (void)awakeFromNib
{
    // 初始设定
    self.roundedCorners = 2;
    self.progressLabel.textColor = [UIColor whiteColor];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated
{
    [super setProgress:progress animated:animated];
    
    NSString *text = [NSString stringWithFormat:@"%.0f%%", progress * 100];
    // sdwebimage的bug，传过来的值可能有负号
    self.progressLabel.text = [text stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

@end
