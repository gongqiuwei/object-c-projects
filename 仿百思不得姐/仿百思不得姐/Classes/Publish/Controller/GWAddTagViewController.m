//
//  GWAddTagViewController.m
//  仿百思不得姐
//
//  Created by gongqiuwei on 16/5/3.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//

#import "GWAddTagViewController.h"

@interface GWAddTagViewController ()
/** 内容 */
@property (nonatomic, weak) UIView *contentView;
/** 文本输入框 */
@property (nonatomic, weak) UITextField *textField;
/** 添加按钮 */
@property (nonatomic, weak) UIButton *addButton;
@end

@implementation GWAddTagViewController

- (UIButton *)addButton
{
    if (!_addButton) {
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        addButton.width = self.contentView.width;
        addButton.height = 35;
        [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
        addButton.titleLabel.font = [UIFont systemFontOfSize:14];
        addButton.contentEdgeInsets = UIEdgeInsetsMake(0, GWTopicCellMargin, 0, GWTopicCellMargin);
        // 让按钮内部的文字和图片都左对齐
        addButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        addButton.backgroundColor = GWRGBColor(74, 139, 209);
        [self.contentView addSubview:addButton];
        _addButton = addButton;
    }
    return _addButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    [self setupContentView];
    [self setupTextFiled];
}

- (void)setupTextFiled
{
    UITextField *textField = [[UITextField alloc] init];
    textField.width = GWScreenW;
    textField.height = 25;
    textField.placeholder = @"多个标签用逗号或者换行隔开";
    [textField addTarget:self action:@selector(textDidChange) forControlEvents:UIControlEventEditingChanged];
    [textField becomeFirstResponder];
    [self.contentView addSubview:textField];
    self.textField = textField;
}

- (void)setupContentView
{
    UIView *contentView = [[UIView alloc] init];
    contentView.x = GWTopicCellMargin;
    contentView.width = self.view.width - 2 * contentView.x;
    contentView.y = 64 + GWTopicCellMargin;
    contentView.height = GWScreenH;
    [self.view addSubview:contentView];
    self.contentView = contentView;
}

- (void)setupNav
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"添加标签";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
}

- (void)done
{
    
}

/**
 * 监听文字改变
 */
- (void)textDidChange
{
    if (self.textField.hasText) { // 有文字
        self.addButton.hidden = NO;
        self.addButton.y = CGRectGetMaxY(self.textField.frame) + GWTopicCellMargin;
        [self.addButton setTitle:[NSString stringWithFormat:@"添加标签: %@", self.textField.text] forState:UIControlStateNormal];
    } else { // 没有文字
        self.addButton.hidden = YES;
    }
}

/**
 * 监听"添加标签"按钮点击
 */
- (void)addButtonClick
{
    GWLogFunc;
}
@end
