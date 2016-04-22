//
//  GWPublishViewController.m
//  仿百思不得姐
//
//  Created by gongqiuwei on 16/4/22.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//

#import "GWPublishViewController.h"
#import "GWVerticalButton.h"

@interface GWPublishViewController ()

@end

@implementation GWPublishViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 添加标语
    UIImageView *sloganView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_slogan"]];
    sloganView.y = GWScreenH * 0.2;
    sloganView.centerX = GWScreenW * 0.5;
    [self.view addSubview:sloganView];
    
    // 数据
    NSArray *images = @[@"publish-video", @"publish-picture", @"publish-text", @"publish-audio", @"publish-review", @"publish-offline"];
    NSArray *titles = @[@"发视频", @"发图片", @"发段子", @"发声音", @"审帖", @"离线下载"];
    
    // 中间的6个按钮
    // 每一行最多有多少列
    int maxCols = 3;
    // 按钮宽度
    CGFloat buttonW = 72;
    // 自定义的VerticalButton中，图片是正方形，留下的30是文字的高度
    CGFloat buttonH = buttonW + 30;
    CGFloat buttonStartY = (GWScreenH - 2 * buttonH) * 0.5;
    CGFloat buttonStartX = 20;
    CGFloat xMargin = (GWScreenW - 2 * buttonStartX - maxCols * buttonW) / (maxCols - 1);
    for (int i = 0; i<images.count; i++) {
        GWVerticalButton *button = [[GWVerticalButton alloc] init];
        // 设置内容
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        
        // 设置frame
        button.width = buttonW;
        button.height = buttonH;
        int row = i / maxCols;
        int col = i % maxCols;
        button.x = buttonStartX + col * (xMargin + buttonW);
        button.y = buttonStartY + row * buttonH;
        [self.view addSubview:button];
    }
}


- (IBAction)cancel
{
    [self dismissViewControllerAnimated:NO completion:nil];
}



@end
