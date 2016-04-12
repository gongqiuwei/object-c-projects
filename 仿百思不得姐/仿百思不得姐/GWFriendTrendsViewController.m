//
//  GWFriendTrendsViewController.m
//  仿百思不得姐
//
//  Created by gongqiuwei on 16/4/12.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//

#import "GWFriendTrendsViewController.h"

@interface GWFriendTrendsViewController ()

@end

@implementation GWFriendTrendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的关注";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"friendsRecommentIcon" selectImage:@"friendsRecommentIcon-click" target:self action:@selector(friendsClicked)];
    
    self.view.backgroundColor = GWGlobalBgColor;
}

- (void)friendsClicked
{
    GWLogFunc;
}
@end
