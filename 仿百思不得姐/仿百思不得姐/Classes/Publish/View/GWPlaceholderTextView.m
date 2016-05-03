//
//  GWPlaceholderTextView.m
//  仿百思不得姐
//
//  Created by gongqiuwei on 16/5/3.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//

#import "GWPlaceholderTextView.h"

@interface GWPlaceholderTextView()
@property (nonatomic, weak) UILabel *placeholderLabel;
@end

@implementation GWPlaceholderTextView

- (UILabel *)placeholderLabel
{
    if (!_placeholderLabel) {
        // 添加一个用来显示占位文字的label
        UILabel *placeholderLabel = [[UILabel alloc] init];
        placeholderLabel.numberOfLines = 0;
        placeholderLabel.x = 4;  // 预估的数字
        placeholderLabel.y = 7;  // 预估的数字
        [self addSubview:placeholderLabel];
        _placeholderLabel = placeholderLabel;
    }
    return _placeholderLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 垂直方向上永远有弹簧效果
        self.alwaysBounceVertical = YES;
        
        // 默认字体
        self.font = [UIFont systemFontOfSize:15];
        
        // 默认的占位文字颜色
        self.placeholderColor = [UIColor grayColor];
        
        // 监听事件
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)textDidChange
{
    // 有文字的时候隐藏
    self.placeholderLabel.hidden = self.hasText;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 计算placeholderLabel的尺寸
    self.placeholderLabel.width = self.width - self.placeholderLabel.x * 2;
    [self.placeholderLabel sizeToFit];
}

#pragma mark - 重写setter方法
- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = [placeholder copy];
    
    self.placeholderLabel.text = placeholder;
    
    // 向系统声明需要更新尺寸，系统会在恰当的时刻调用layoutSubViews更新尺寸
    [self setNeedsLayout];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    
    self.placeholderLabel.textColor = placeholderColor;
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    self.placeholderLabel.font = font;
    
    // 向系统声明需要更新尺寸，系统会在恰当的时刻调用layoutSubViews更新尺寸
    [self setNeedsLayout];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    
    [self textDidChange];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    
    [self textDidChange];
}
@end
