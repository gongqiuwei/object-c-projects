//
//  GWPostWordViewController.m
//  仿百思不得姐
//
//  Created by gongqiuwei on 16/4/30.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//

#import "GWPostWordViewController.h"

@implementation GWPostWordViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNav];
}

- (void)setupNav
{
    self.title = @"发表文字";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发表" style:UIBarButtonItemStyleDone target:self action:@selector(post)];
}

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)post
{
    GWLogFunc;
}
@end
