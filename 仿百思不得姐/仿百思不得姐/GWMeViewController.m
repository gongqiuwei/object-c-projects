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
    
    UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingButton setBackgroundImage:[UIImage imageNamed:@"mine-setting-icon"] forState:UIControlStateNormal];
    [settingButton setBackgroundImage:[UIImage imageNamed:@"mine-setting-icon-click"] forState:UIControlStateHighlighted];
    settingButton.size = settingButton.currentBackgroundImage.size;
    [settingButton addTarget:self action:@selector(settingClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *settingItem = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
    
    UIButton *moonButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [moonButton setBackgroundImage:[UIImage imageNamed:@"mine-moon-icon"] forState:UIControlStateNormal];
    [moonButton setBackgroundImage:[UIImage imageNamed:@"mine-moon-icon-click"] forState:UIControlStateHighlighted];
    moonButton.size = moonButton.currentBackgroundImage.size;
    [moonButton addTarget:self action:@selector(moonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *moonItem = [[UIBarButtonItem alloc] initWithCustomView:moonButton];
    
    self.navigationItem.rightBarButtonItems = @[settingItem, moonItem];
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
