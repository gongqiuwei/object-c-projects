//
//  GWPostWordViewController.m
//  仿百思不得姐
//
//  Created by gongqiuwei on 16/4/30.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//

#import "GWPostWordViewController.h"
#import "GWPlaceholderTextView.h"

@interface GWPostWordViewController()
@property (nonatomic, weak) GWPlaceholderTextView *textView;
@end

@implementation GWPostWordViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNav];
    
    [self setupTextView];
}

- (void)setupTextView
{
    GWPlaceholderTextView *textView = [[GWPlaceholderTextView alloc] init];
    textView.frame = self.view.bounds;
    textView.placeholder = @"把好玩的图片，好笑的段子或糗事发到这里，接受千万网友膜拜吧！发布违反国家法律内容的，我们将依法提交给有关部门处理。";
    [self.view addSubview:textView];
    self.textView = textView;
}

- (void)setupNav
{
    self.title = @"发表文字";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发表" style:UIBarButtonItemStyleDone target:self action:@selector(post)];
    self.navigationItem.rightBarButtonItem.enabled = NO; // 默认不能点击
    
    // 刷新布局，UIAppearance设置了item的enabled状态下的情况，但是这个设置需要view显示完成之后再由runloop循环捕捉然后生效，如果要立刻看到效果，需要强制刷新布局
//    [self.navigationController.navigationBar setNeedsLayout];
    [self.navigationController.navigationBar layoutIfNeeded];
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
