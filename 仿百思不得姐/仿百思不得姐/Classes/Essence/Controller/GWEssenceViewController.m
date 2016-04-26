//
//  GWEssenceViewController.m
//  仿百思不得姐
//
//  Created by gongqiuwei on 16/4/12.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//

#import "GWEssenceViewController.h"
#import "GWTopicViewController.h"

@interface GWEssenceViewController ()<UIScrollViewDelegate>
/** 红色指示器 */
@property (nonatomic, weak) UIView *indicatorView;
/** 选中的按钮 */
@property (nonatomic, weak) UIButton *selectedButton;
/** 所有标签的视图 */
@property (nonatomic, weak) UIView *titlesView;
/** 中间Scrollview */
@property (nonatomic, weak) UIScrollView *contentView;
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
    // 不要自动调整scrollview的inserts
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 添加子控制器
    [self initChildVcs];
    
    // 标签栏
    [self initTitlesView];
    
    // 底部的scrollview
    [self initContentView];
}

// 添加子控制器
- (void)initChildVcs
{
    // 将title与vc进行绑定，以后随意更换控制器的位置，标签栏也会跟着改变
    GWTopicViewController *all = [[GWTopicViewController alloc] init];
    all.title = @"全部";
    all.type = GWTopicTypeAll;
    [self addChildViewController:all];
    
    GWTopicViewController *video = [[GWTopicViewController alloc] init];
    video.title = @"视频";
    video.type = GWTopicTypeVideo;
    [self addChildViewController:video];
    
    GWTopicViewController *audio = [[GWTopicViewController alloc] init];
    audio.title = @"声音";
    audio.type = GWTopicTypeAudio;
    [self addChildViewController:audio];
    
    GWTopicViewController *picture = [[GWTopicViewController alloc] init];
    picture.title = @"图片";
    picture.type = GWTopicTypePicture;
    [self addChildViewController:picture];
    
    GWTopicViewController *word = [[GWTopicViewController alloc] init];
    word.title = @"段子";
    word.type = GWTopicTypeWord;
    [self addChildViewController:word];
}

// 底部的scrollview
- (void)initContentView
{
    UIScrollView *contentView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view insertSubview:contentView atIndex:0];
    self.contentView = contentView;
    contentView.delegate = self;
    contentView.pagingEnabled = YES;
    contentView.contentSize = CGSizeMake(self.childViewControllers.count * contentView.width, contentView.height);
    
    // 添加第一个控制器的view
    [self scrollViewDidEndScrollingAnimation:contentView];
}

- (void)initTitlesView
{
    UIView *titlesView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, 35)];
    [self.view addSubview:titlesView];
    titlesView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
    self.titlesView = titlesView;
    
    // 红色指示器
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.backgroundColor = [UIColor redColor];
    [titlesView addSubview:indicatorView];
    indicatorView.height = 2;
    indicatorView.y = titlesView.height - indicatorView.height;
    self.indicatorView = indicatorView;
    
    // 添加子控件
//    NSArray *titles = @[@"全部", @"视频", @"音频", @"图片", @"段子手"];
    CGFloat buttonW = titlesView.width / self.childViewControllers.count;
    CGFloat buttonH = titlesView.height;
    
    for (NSInteger i = 0; i < self.childViewControllers.count; i++) {
        CGFloat buttonX = i * buttonW;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(buttonX, 0, buttonW, buttonH);
        [titlesView addSubview:button];
        
        button.tag = i;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        
        UIViewController *vc = self.childViewControllers[i];
        [button setTitle:vc.title forState:UIControlStateNormal];
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
    
    // 滑动scrollView
    CGPoint offset = self.contentView.contentOffset;
    offset.x = button.tag * self.contentView.width;
    [self.contentView setContentOffset:offset animated:YES];
}

#pragma mark - <UIScrollViewDelegate>
// scrollview滑动动画停止
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    UITableViewController *vc = self.childViewControllers[index];
    vc.view.x = index * scrollView.width;
    // UITableViewController：系统对tableview的frame做了修改
    // 设置起点
    vc.view.y = 0;
    // 设置控制器view的height值为整个屏幕的高度(默认是比屏幕高度少个20)
    vc.view.height = scrollView.height;
    
#warning - 待重构的代码，需要放在控制器内部
//    CGFloat top = 64 + self.titlesView.height;
//    CGFloat bottom = self.tabBarController.tabBar.height;
//    vc.tableView.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
//    // 设置滚动条的内边距
//    vc.tableView.scrollIndicatorInsets = vc.tableView.contentInset;
    [scrollView addSubview:vc.view];
}

// 停止减速
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    // +1是因为在添加按钮之前还添加了indicatorView
    NSInteger buttonIndex = scrollView.contentOffset.x / scrollView.width + 1;
    [self titleClick:(UIButton *)self.titlesView.subviews[buttonIndex]];
}
@end
