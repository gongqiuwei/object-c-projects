//
//  GWNewViewController.m
//  仿百思不得姐
//
//  Created by gongqiuwei on 16/4/12.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//

#import "GWNewViewController.h"

@interface GWNewViewController ()

@end

@implementation GWNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
    UIButton *tagButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tagButton setBackgroundImage:[UIImage imageNamed:@"MainTagSubIcon"] forState:UIControlStateNormal];
    [tagButton setBackgroundImage:[UIImage imageNamed:@"MainTagSubIconClick"] forState:UIControlStateHighlighted];
    tagButton.size = tagButton.currentBackgroundImage.size;
    [tagButton addTarget:self action:@selector(tagClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:tagButton];
}

- (void)tagClicked
{
    GWLogFunc;
}

@end
