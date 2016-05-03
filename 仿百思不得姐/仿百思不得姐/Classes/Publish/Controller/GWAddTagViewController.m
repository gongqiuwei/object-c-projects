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
/** 所有的标签按钮 */
@property (nonatomic, strong) NSMutableArray *tagButtons;
@end

@implementation GWAddTagViewController

- (NSMutableArray *)tagButtons
{
    if (!_tagButtons) {
        _tagButtons = [NSMutableArray array];
    }
    return _tagButtons;
}

- (UIButton *)addButton
{
    if (!_addButton) {
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        addButton.width = self.contentView.width;
        addButton.height = 35;
        [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
        addButton.titleLabel.font = [UIFont systemFontOfSize:14];
        addButton.contentEdgeInsets = UIEdgeInsetsMake(0, GWTagMargin, 0, GWTagMargin);
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
    contentView.x = GWTagMargin;
    contentView.width = self.view.width - 2 * contentView.x;
    contentView.y = 64 + GWTagMargin;
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
        self.addButton.y = CGRectGetMaxY(self.textField.frame) + GWTagMargin;
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
    // 添加一个"标签按钮"
    UIButton *tagButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tagButton addTarget:self action:@selector(tagButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [tagButton setImage:[UIImage imageNamed:@"chose_tag_close_icon"] forState:UIControlStateNormal];
    tagButton.backgroundColor = GWTagBg;
    [tagButton setTitle:self.textField.text forState:UIControlStateNormal];
    [tagButton sizeToFit];
    [self.contentView addSubview:tagButton];
    [self.tagButtons addObject:tagButton];
    
    // 更新标签按钮的frame
    [self updateTagButtonFrame];
    
    // 更新其他控件的状态(代码更改text不会调用target方法)
    self.textField.text = nil;
    self.addButton.hidden = YES;
}

- (void)updateTagButtonFrame
{
    // 计算按钮的位置
    for (NSInteger i = 0; i < self.tagButtons.count; i++) {
        UIButton *tagButton = self.tagButtons[i];
        
        if (i == 0) { // 第一个按钮
            tagButton.x = 0;
            tagButton.y = 0;
        } else {
            UIButton *lastTagButton = self.tagButtons[i-1];
            // 计算当前行左边被占用的宽度
            CGFloat leftWidth = CGRectGetMaxX(lastTagButton.frame) + GWTagMargin;
            // 计算当前行右边剩余的宽度
            CGFloat rightWidth = self.contentView.width - leftWidth;
            if (rightWidth >= tagButton.width) { // 按钮显示在当前行
                tagButton.y = lastTagButton.y;
                tagButton.x = leftWidth;
            } else { // 按钮显示在下一行
                tagButton.x = 0;
                tagButton.y = CGRectGetMaxY(lastTagButton.frame) + GWTagMargin;
            }
        }
    }
    
    // 计算textField的位置
    UIButton *lastTagButton = [self.tagButtons lastObject];
    self.textField.x = 0;
    self.textField.y = CGRectGetMaxY(lastTagButton.frame) + GWTagMargin;
}

- (void)tagButtonClick:(UIButton *)tagButton
{
    [tagButton removeFromSuperview];
    [self.tagButtons removeObject:tagButton];
    
    [self updateTagButtonFrame];
}
@end
