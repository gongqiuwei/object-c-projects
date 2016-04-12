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
    
    UIButton *friendsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [friendsButton setBackgroundImage:[UIImage imageNamed:@"friendsRecommentIcon"] forState:UIControlStateNormal];
    [friendsButton setBackgroundImage:[UIImage imageNamed:@"friendsRecommentIcon-click"] forState:UIControlStateHighlighted];
    friendsButton.size = friendsButton.currentBackgroundImage.size;
    [friendsButton addTarget:self action:@selector(friendsClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:friendsButton];
}

- (void)friendsClicked
{
    GWLogFunc;
}
@end
