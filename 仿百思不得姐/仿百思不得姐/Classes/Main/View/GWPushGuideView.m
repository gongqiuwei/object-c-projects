//
//  GWPushGuideView.m
//  仿百思不得姐
//
//  Created by gongqiuwei on 16/4/18.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//

#import "GWPushGuideView.h"

@implementation GWPushGuideView

+ (instancetype)pushGuideView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}

+ (void)show
{
    NSString *key = @"CFBundleShortVersionString";
    // 获得沙盒中存储的版本号
    NSString *sanboxVersion = [[NSUserDefaults standardUserDefaults] stringForKey:key];
    
    // 获得当前软件的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    
    if (![sanboxVersion isEqualToString:currentVersion]) {
        
        // 显示view
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        GWPushGuideView *guideView = [GWPushGuideView pushGuideView];
        guideView.frame = window.bounds;
        [window addSubview:guideView];
        
        // 存储版本号
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (IBAction)hidden
{
    [self removeFromSuperview];
}

@end
