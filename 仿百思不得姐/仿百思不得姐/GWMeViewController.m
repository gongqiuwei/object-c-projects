//
//  GWMeViewController.m
//  仿百思不得姐
//
//  Created by gongqiuwei on 16/4/12.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//

#import "GWMeViewController.h"

@interface GWMeViewController ()

@end

@implementation GWMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的";
    
    UIBarButtonItem *settingItem = [UIBarButtonItem itemWithImage:@"mine-setting-icon" selectImage:@"mine-setting-icon-click" target:self action:@selector(settingClicked)];
    
    UIBarButtonItem *moonItem = [UIBarButtonItem itemWithImage:@"mine-moon-icon" selectImage:@"mine-moon-icon-click" target:self action:@selector(moonClicked)];
    
    self.navigationItem.rightBarButtonItems = @[settingItem, moonItem];
    
    self.view.backgroundColor = GWGlobalBgColor;
}

- (void)settingClicked
{
    GWLogFunc;
}

- (void)moonClicked
{
    GWLogFunc;
}
@end
