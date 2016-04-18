//
//  GWEssenceViewController.m
//  仿百思不得姐
//
//  Created by gongqiuwei on 16/4/12.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//

#import "GWEssenceViewController.h"

@interface GWEssenceViewController ()
/** 红色指示器 */
@property (nonatomic, weak) UIView *indicatorView;
/** 选中的按钮 */
@property (nonatomic, weak) UIButton *selectedButton;
@end

@implementation GWEssenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
}

- (void)initUI
{
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
    self.view.backgroundColor = GWGlobalBgColor;
    
    // 标签栏
    [self initTitlesView];
}

- (void)initTitlesView
{
    UIView *titlesView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, 35)];
    [self.view addSubview:titlesView];
    titlesView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    
    // 红色指示器
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.backgroundColor = [UIColor redColor];
    [titlesView addSubview:indicatorView];
    indicatorView.height = 2;
    indicatorView.y = titlesView.height - indicatorView.height;
    self.indicatorView = indicatorView;
    
    // 添加子控件
    NSArray *titles = @[@"全部", @"视频", @"音频", @"图片", @"段子手"];
    CGFloat buttonW = titlesView.width / titles.count;
    CGFloat buttonH = titlesView.height;
    
    for (NSInteger i = 0; i < titles.count; i++) {
        CGFloat buttonX = i * buttonW;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(buttonX, 0, buttonW, buttonH);
        [titlesView addSubview:button];
        
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        // 使用disable状态更新颜色，是为了防止按钮重复点击重复发送请求
        [button setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
        
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            self.selectedButton = button;
            button.enabled = NO;
            
            // 计算titleLabel的尺寸
            [button.titleLabel sizeToFit];
            self.indicatorView.width = button.titleLabel.width;
            self.indicatorView.centerX = button.centerX;
        }
    }
}

- (void)titleClick:(UIButton *)button
{
    // 更改选中按钮
    self.selectedButton.enabled = YES;
    button.enabled = NO;
    self.selectedButton = button;
    
    // 动画
    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorView.width = button.titleLabel.width;
        self.indicatorView.centerX = button.centerX;
    }];
}
@end
