//
//  AppDelegate.m
//  仿百思不得姐
//
//  Created by gongqiuwei on 16/4/12.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//

#import "AppDelegate.h"
#import "GWTabBarController.h"
#import "GWPushGuideView.h"
#import "UIView+GWExtension.h"

@interface AppDelegate () <UITabBarControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // 创建窗口
    self.window = [[UIWindow alloc] init];
    [self.window setFrame:[[UIScreen mainScreen] bounds]];
    
    // 创建窗口的根控制器
    GWTabBarController *tabbar = [[GWTabBarController alloc] init];
    tabbar.delegate = self;
    self.window.rootViewController = tabbar;
    
    // 显示窗口
    [self.window makeKeyAndVisible];
    
    // 推送引导页面
    [GWPushGuideView show];
    
    return YES;
}

#pragma mark - <UITabBarControllerDelegate>
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    // 发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:GWTabBarDidSelectNotification object:nil];
}

#pragma mark - 点击状态栏处理
/**
 *  点击了statusBar区域，将当前看到的scrollview回滚，其他的不动
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    CGPoint location = [[[event allTouches] anyObject] locationInView:self.window];
    CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
    if (CGRectContainsPoint(statusBarFrame, location)) {
        [self searchScrollViewInView:self.window];
    }
}

- (void)searchScrollViewInView:(UIView *)superview
{
    for (UIScrollView *subview in superview.subviews) {
        // 如果是scrollview, 滚动最顶部
        if ([subview isKindOfClass:[UIScrollView class]] && subview.isShowingOnKeyWindow) {
            CGPoint offset = subview.contentOffset;
            offset.y = - subview.contentInset.top;
            [subview setContentOffset:offset animated:YES];
        }
        
        // 继续查找子控件
        [self searchScrollViewInView:subview];
    }
}
@end
