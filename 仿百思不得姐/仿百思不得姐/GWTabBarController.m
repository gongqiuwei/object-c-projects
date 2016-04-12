//
//  GWTabBarController.m
//  仿百思不得姐
//
//  Created by gongqiuwei on 16/4/12.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//

#import "GWTabBarController.h"
#import "GWEssenceViewController.h"
#import "GWNewViewController.h"
#import "GWFriendTrendsViewController.h"
#import "GWMeViewController.h"
#import "GWTabBar.h"

@interface GWTabBarController ()

@end

@implementation GWTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 使用appearance设定tabbaritem的title的一些属性
    UITabBarItem *item = [UITabBarItem appearance];
    
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    attr[NSForegroundColorAttributeName] = [UIColor grayColor];
    [item setTitleTextAttributes:attr forState:UIControlStateNormal];
    
    NSMutableDictionary *selectAttr = [NSMutableDictionary dictionary];
    selectAttr[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    selectAttr[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    [item setTitleTextAttributes:selectAttr forState:UIControlStateSelected];
    
    [self setupChildVc:[[GWEssenceViewController alloc] init] title:@"精华" image:@"tabBar_essence_icon" selectImage:@"tabBar_essence_click_icon"];
    
    [self setupChildVc:[[GWNewViewController alloc] init] title:@"最新" image:@"tabBar_new_icon" selectImage:@"tabBar_new_click_icon"];
    
    [self setupChildVc:[[GWFriendTrendsViewController alloc] init] title:@"关注" image:@"tabBar_friendTrends_icon" selectImage:@"tabBar_friendTrends_click_icon"];
    
    [self setupChildVc:[[GWMeViewController alloc] init] title:@"我" image:@"tabBar_me_icon" selectImage:@"tabBar_me_click_icon"];
    
    // 自定义tabbar
    // readonly无法通过set方法设定,只能使用kvc
//    self.tabBar = [[GWTabBar alloc] init];
    [self setValue:[[GWTabBar alloc] init] forKeyPath:@"tabBar"];
}

// 这种方法扩展性强一点
- (void)setupChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectImage:(NSString *)selectImage
{
    childVc.view.backgroundColor = [self randomColor];
    childVc.tabBarItem.title = title;
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [UIImage imageNamed:selectImage];
    
    [self addChildViewController:childVc];
}

// childVc的创建方式单一,只能通过alloc init创建
- (void)setupChildVcWithClass:(Class)childVcClass title:(NSString *)title image:(NSString *)image selectImage:(NSString *)selectImage
{
    UIViewController *childVc = [[childVcClass alloc] init];
    childVc.view.backgroundColor = [self randomColor];
    childVc.tabBarItem.title = title;
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [UIImage imageNamed:selectImage];
    
    [self addChildViewController:childVc];
}

// 颜色随机
- (UIColor *)randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}
@end
