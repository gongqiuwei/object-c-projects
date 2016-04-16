//
//  GWLoginRegisterViewController.m
//  仿百思不得姐
//
//  Created by gongqiuwei on 16/4/16.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//

#import "GWLoginRegisterViewController.h"

@interface GWLoginRegisterViewController ()
/** 登录框距离控制器view左边的间距 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginViewLeftMargin;

@end

@implementation GWLoginRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (IBAction)loginRegisterClicked:(UIButton *)button
{
    button.selected = !button.selected;
    [self.view endEditing:YES];
    
    if (button.selected) { // 进入注册框
        self.loginViewLeftMargin.constant = -self.view.width;
    } else { // 进入登录框
        self.loginViewLeftMargin.constant = 0;
    }
    
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.44 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
    
}

/**
 *  状态栏的样式
 */
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
