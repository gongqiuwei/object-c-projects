//
//  GWTagButton.m
//  仿百思不得姐
//
//  Created by apple on 16/5/3.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//

#import "GWTagButton.h"

@implementation GWTagButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setImage:[UIImage imageNamed:@"chose_tag_close_icon"] forState:UIControlStateNormal];
        self.titleLabel.font = GWTagFont;
        self.backgroundColor = GWTagBg;
    }
    return self;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    
    [self sizeToFit];
    
    self.width += 3 * GWTagMargin;
    // 高度需要在title设置完之后改，不然sizetofit调用了高度就不正确了
    self.height = GWTagH;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.x = GWTagMargin;
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame) + GWTagMargin;
}
@end
