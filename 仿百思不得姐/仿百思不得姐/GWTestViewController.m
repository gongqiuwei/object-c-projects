//
//  GWTestViewController.m
//  仿百思不得姐
//
//  Created by gongqiuwei on 16/4/13.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//

#import "GWTestViewController.h"

@implementation GWTestViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"TestViewController";
    self.view.backgroundColor = GWGlobalBgColor;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    GWTestViewController *test = [[GWTestViewController alloc] init];
    [self.navigationController pushViewController:test animated:YES];
}
@end
