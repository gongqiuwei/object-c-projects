//
//  GWAddTagViewController.m
//  仿百思不得姐
//
//  Created by gongqiuwei on 16/5/3.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//

#import "GWAddTagViewController.h"
#import "GWTagButton.h"
#import "GWTagTextField.h"
#import "SVProgressHUD.h"

@interface GWAddTagViewController ()<UITextFieldDelegate>
/** 内容 */
@property (nonatomic, weak) UIView *contentView;
/** 文本输入框 */
@property (nonatomic, weak) GWTagTextField *textField;
/** 添加按钮 */
@property (nonatomic, weak) UIButton *addButton;
/** 所有的标签按钮 */
@property (nonatomic, strong) NSMutableArray *tagButtons;
@end

@implementation GWAddTagViewController

#pragma mark - 懒加载
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
        addButton.titleLabel.font = GWTagFont;
        addButton.contentEdgeInsets = UIEdgeInsetsMake(0, GWTagMargin, 0, GWTagMargin);
        // 让按钮内部的文字和图片都左对齐
        addButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        addButton.backgroundColor = GWRGBColor(74, 139, 209);
        [self.contentView addSubview:addButton];
        _addButton = addButton;
    }
    return _addButton;
}

#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    [self setupContentView];
    [self setupTextFiled];
    [self setupTags];
}

- (void)setupTags
{
    for (NSString *tag in self.tags) {
        // 模拟在当前界面如何添加标签的
        self.textField.text = tag;
        [self addButtonClick];
    }
}

- (void)setupTextFiled
{
    GWTagTextField *textField = [[GWTagTextField alloc] init];
    textField.width = self.contentView.width;
    [textField addTarget:self action:@selector(textDidChange) forControlEvents:UIControlEventEditingChanged];
    [textField becomeFirstResponder];
    [self.contentView addSubview:textField];
    self.textField = textField;
    textField.delegate = self;
    
    __weak typeof(self) weakSelf = self;
    textField.deleteBlock = ^{
        if (weakSelf.textField.hasText) return;
        
        [weakSelf tagButtonClick:[weakSelf.tagButtons lastObject]];
    };
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

#pragma mark - 事件监听
- (void)done
{
    NSArray *tags = [self.tagButtons valueForKeyPath:@"currentTitle"];
    !self.completionBlock ?: self.completionBlock(tags);
    
    [self.navigationController popViewControllerAnimated:YES];
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
        
        // 判断是不是逗号
        // 获得最后一个字符
        NSString *text = self.textField.text;
        NSUInteger len = text.length;
        NSString *lastLetter = [text substringFromIndex:len - 1];
        if ([lastLetter isEqualToString:@","]
            || [lastLetter isEqualToString:@"，"]) {
            // 去除逗号
            self.textField.text = [text substringToIndex:len - 1];
            
            [self addButtonClick];
        }
    } else { // 没有文字
        self.addButton.hidden = YES;
    }
    
    // 计算textField的位置
    [self updateTextFieldFrame];
}

/**
 * 监听"添加标签"按钮点击
 */
- (void)addButtonClick
{
    // 判断标签是否满了
    if (self.tagButtons.count == 5) {

        [SVProgressHUD showErrorWithStatus:@"最多5个标签" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    // 添加一个"标签按钮"
    GWTagButton *tagButton = [GWTagButton buttonWithType:UIButtonTypeCustom];
    [tagButton addTarget:self action:@selector(tagButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [tagButton setTitle:self.textField.text forState:UIControlStateNormal];
    [self.contentView addSubview:tagButton];
    [self.tagButtons addObject:tagButton];
    
    // 更新其他控件的状态(代码更改text不会调用target方法)
    self.textField.text = nil;
    self.addButton.hidden = YES;
    
    // 更新frame
    [self updateTagButtonFrame];
    [self updateTextFieldFrame];
}

- (void)tagButtonClick:(GWTagButton *)tagButton
{
    [tagButton removeFromSuperview];
    [self.tagButtons removeObject:tagButton];
    
    // 重新更新所有标签按钮的frame
    [UIView animateWithDuration:0.25 animations:^{
        [self updateTagButtonFrame];
        [self updateTextFieldFrame];
    }];
}

#pragma mark - 计算frame
// 计算tagButton的位置
- (void)updateTagButtonFrame
{
    // 计算按钮的位置
    for (NSInteger i = 0; i < self.tagButtons.count; i++) {
        GWTagButton *tagButton = self.tagButtons[i];
        
        if (i == 0) { // 第一个按钮
            tagButton.x = 0;
            tagButton.y = 0;
        } else {
            GWTagButton *lastTagButton = self.tagButtons[i-1];
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
}

// 计算textField的位置
- (void)updateTextFieldFrame
{
    // 最后一个标签按钮
    GWTagButton *lastTagButton = [self.tagButtons lastObject];
    CGFloat leftWidth = CGRectGetMaxX(lastTagButton.frame) + GWTagMargin;
    
    // 更新textField的frame
    if (self.contentView.width - leftWidth >= [self textFieldTextWidth]) {
        self.textField.y = lastTagButton.y;
        self.textField.x = leftWidth;
    } else {
        self.textField.x = 0;
        self.textField.y = CGRectGetMaxY(lastTagButton.frame) + GWTagMargin;
    }
}

/**
 * textField的文字宽度
 */
- (CGFloat)textFieldTextWidth
{
    CGFloat textW = [self.textField.text sizeWithAttributes:@{NSFontAttributeName : self.textField.font}].width;
    
    // 当textField没有文字的时候，默认占用100的宽度
    return MAX(100, textW);
}

#pragma mark - <UITextFieldDelegate>
/**
 * 监听键盘最右下角按钮的点击（return key， 比如“换行”、“完成”等等）
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.hasText) {
        [self addButtonClick];
    }
    return YES;
}
@end
