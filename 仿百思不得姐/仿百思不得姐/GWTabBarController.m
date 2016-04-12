//
//  GWTabBarController.m
//  仿百思不得姐
//
//  Created by gongqiuwei on 16/4/12.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//

#import "GWTabBarController.h"

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
    
    
    // vc1
    UIViewController *vc1 = [[UIViewController alloc] init];
    vc1.view.backgroundColor = [UIColor redColor];
    
    // tabbaritem的一些属性设定
    // 文字设定
//    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
//    attr[NSFontAttributeName] = [UIFont systemFontOfSize:12];
//    attr[NSForegroundColorAttributeName] = [UIColor grayColor];
//    [vc1.tabBarItem setTitleTextAttributes:attr forState:UIControlStateNormal];
    
//    NSMutableDictionary *selectAttr = [NSMutableDictionary dictionary];
//    selectAttr[NSFontAttributeName] = [UIFont systemFontOfSize:12];
//    selectAttr[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
//    [vc1.tabBarItem setTitleTextAttributes:selectAttr forState:UIControlStateSelected];
    
    vc1.tabBarItem.title = @"精华";
    
    vc1.tabBarItem.image = [UIImage imageNamed:@"tabBar_essence_icon"];
    
    // 在assets中对图片做了设定
//    UIImage *selectImage = [UIImage imageNamed:@"tabBar_essence_click_icon"];
//    selectImage = [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    vc1.tabBarItem.selectedImage = selectImage;
    vc1.tabBarItem.selectedImage = [UIImage imageNamed:@"tabBar_essence_click_icon"];
    
    [self addChildViewController:vc1];
    
    
    // vc2
    UIViewController *vc2 = [[UIViewController alloc] init];
    vc2.view.backgroundColor = [UIColor greenColor];
    
    // tabbaritem的一些属性设定
    vc2.tabBarItem.title = @"最新";
//    [vc2.tabBarItem setTitleTextAttributes:attr forState:UIControlStateNormal];
//    [vc2.tabBarItem setTitleTextAttributes:selectAttr forState:UIControlStateSelected];
    vc2.tabBarItem.image = [UIImage imageNamed:@"tabBar_new_icon"];
    vc2.tabBarItem.selectedImage = [UIImage imageNamed:@"tabBar_new_click_icon"];
    
    [self addChildViewController:vc2];
    
    // vc3
    UIViewController *vc3 = [[UIViewController alloc] init];
    vc3.view.backgroundColor = [UIColor blueColor];
    
    // tabbaritem的一些属性设定
    vc3.tabBarItem.title = @"关注";
//    [vc3.tabBarItem setTitleTextAttributes:attr forState:UIControlStateNormal];
//    [vc3.tabBarItem setTitleTextAttributes:selectAttr forState:UIControlStateSelected];
    vc3.tabBarItem.image = [UIImage imageNamed:@"tabBar_friendTrends_icon"];
    vc3.tabBarItem.selectedImage = [UIImage imageNamed:@"tabBar_friendTrends_click_icon"];
    
    [self addChildViewController:vc3];
    
    // vc4
    UIViewController *vc4 = [[UIViewController alloc] init];
    vc4.view.backgroundColor = [UIColor purpleColor];
    
    // tabbaritem的一些属性设定
    vc4.tabBarItem.title = @"我";
//    [vc4.tabBarItem setTitleTextAttributes:attr forState:UIControlStateNormal];
//    [vc4.tabBarItem setTitleTextAttributes:selectAttr forState:UIControlStateSelected];
    vc4.tabBarItem.image = [UIImage imageNamed:@"tabBar_me_icon"];
    vc4.tabBarItem.selectedImage = [UIImage imageNamed:@"tabBar_me_click_icon"];
    
    [self addChildViewController:vc4];
    
}


@end
