//
//  GWVerticalButton.m
//  仿百思不得姐
//
//  Created by gongqiuwei on 16/4/16.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//

#import "GWVerticalButton.h"

@implementation GWVerticalButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initButton];
    }
    return self;
}

- (void)awakeFromNib
{
    [self initButton];
}

- (void)initButton
{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 图片尺寸
    self.imageView.x = 0;
    self.imageView.y = 0;
    self.imageView.width = self.width;
    self.imageView.height = self.imageView.height;
    
    // 文字尺寸
    self.titleLabel.x = 0;
    self.titleLabel.y = self.imageView.height;
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.height - self.titleLabel.y;
}

@end
