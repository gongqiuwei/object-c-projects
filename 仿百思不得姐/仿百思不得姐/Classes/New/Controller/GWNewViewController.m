//
//  GWNewViewController.m
//  仿百思不得姐
//
//  Created by gongqiuwei on 16/4/12.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//

#import "GWNewViewController.h"
#import "GWRecommendTagViewController.h"

@interface GWNewViewController ()

@end

@implementation GWNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" selectImage:@"MainTagSubIconClick" target:self action:@selector(tagClicked)];
    
    self.view.backgroundColor = GWGlobalBgColor;
}

// 推荐标签
- (void)tagClicked
{
    GWRecommendTagViewController *tag = [[GWRecommendTagViewController alloc] init];
    [self.navigationController pushViewController:tag animated:YES];
}

@end
