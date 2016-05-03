//
//  GWNavigationController.m
//  仿百思不得姐
//
//  Created by gongqiuwei on 16/4/13.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//

#import "GWNavigationController.h"

@implementation GWNavigationController

// 一次性设定的,可以放在initialize方法中,
+ (void)initialize
{
    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedIn:[self class], nil];
    [bar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
    [bar setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:20]}];
    
    // 设置item
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    // UIControlStateNormal
    NSMutableDictionary *itemAttrs = [NSMutableDictionary dictionary];
    itemAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    itemAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    [item setTitleTextAttributes:itemAttrs forState:UIControlStateNormal];
    // UIControlStateDisabled
    NSMutableDictionary *itemDisabledAttrs = [NSMutableDictionary dictionary];
    itemDisabledAttrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    [item setTitleTextAttributes:itemDisabledAttrs forState:UIControlStateDisabled];
}

//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    
//    
//}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 根控制器的左边返回按钮不用设定
    if (self.viewControllers.count > 0) {
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        // 设置图片
        [backButton setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
        // 设置文字
        [backButton setTitle:@"返回" forState:UIControlStateNormal];
        [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [backButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        // 点击事件
        [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        // 尺寸设置
        backButton.size = CGSizeMake(70, 30);
        // 整体内容左对齐
        backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        // 由于系统布局,左边看起来还是有很多间隙,可以用contentEdgeInsets左移
        backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        
        // 隐藏tabbar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    // 讲super的代码放在后面,是为了如果viewController有自己的独特的返回按钮样式的时候,不会被覆盖掉
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}
@end
