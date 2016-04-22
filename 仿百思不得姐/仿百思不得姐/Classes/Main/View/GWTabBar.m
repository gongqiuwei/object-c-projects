//
//  GWTabBar.m
//  仿百思不得姐
//
//  Created by gongqiuwei on 16/4/12.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//

#import "GWTabBar.h"
#import "GWPublishViewController.h"

@interface GWTabBar()
@property (nonatomic, weak) UIButton *publishButton;
@end

@implementation GWTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        // 设置tabbar的背景图片
        [self setBackgroundImage:[UIImage imageNamed:@"tabbar-light"]];
        
        UIButton *publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:publishButton];
        self.publishButton = publishButton;
        
        [publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        [publishButton addTarget:self action:@selector(publishClicked) forControlEvents:UIControlEventTouchUpInside];
        
        publishButton.size = publishButton.currentBackgroundImage.size;
        
    }
    return self;
}

- (void)publishClicked
{
    GWPublishViewController *publish = [[GWPublishViewController alloc] init];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:publish animated:NO completion:nil];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = self.width;
    CGFloat height = self.height;
    
    // 发布按钮的尺寸
    self.publishButton.center = CGPointMake(width * 0.5, height * 0.5);
    
    // 其他UITabBarButton的尺寸
    CGFloat buttonY = 0;
    CGFloat buttonW = width / 5;
    CGFloat buttonH = height;
    NSInteger index = 0;
    
    for (UIView *button in self.subviews) {
        if (![button isKindOfClass:NSClassFromString(@"UITabBarButton")]) continue;
        
        CGFloat buttonX = buttonW * (index > 1 ? (index + 1) : index);
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        index ++;
    }
}

@end
