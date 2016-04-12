//
//  GWEssenceViewController.m
//  仿百思不得姐
//
//  Created by gongqiuwei on 16/4/12.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//

#import "GWEssenceViewController.h"

@interface GWEssenceViewController ()

@end

@implementation GWEssenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
 
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" selectImage:@"MainTagSubIconClick" target:self action:@selector(tagClicked)];
    
    self.view.backgroundColor = GWGlobalBgColor;
}

- (void)tagClicked
{
    GWLogFunc;
}
@end
