//
//  GWAddTagToolbar.m
//  仿百思不得姐
//
//  Created by gongqiuwei on 16/5/3.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//

#import "GWAddTagToolbar.h"
#import "GWAddTagViewController.h"

@interface GWAddTagToolbar()
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (nonatomic, strong) NSMutableArray *tagLabels;
@property (nonatomic, weak) UIButton *addButton;
@end

@implementation GWAddTagToolbar

- (NSMutableArray *)tagLabels
{
    if (_tagLabels == nil) {
        _tagLabels = [NSMutableArray array];
    }
    return _tagLabels;
}

+ (instancetype)toolbar
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib
{
    // 添加一个加号按钮
    UIButton *addButton = [[UIButton alloc] init];
    [addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [addButton setImage:[UIImage imageNamed:@"tag_add_icon"] forState:UIControlStateNormal];
    //    addButton.size = [UIImage imageNamed:@"tag_add_icon"].size;
    //    addButton.size = [addButton imageForState:UIControlStateNormal].size;
    addButton.size = addButton.currentImage.size;
    addButton.x = GWTopicCellMargin;
    [self.topView addSubview:addButton];
    self.addButton = addButton;
    
    // 初始化标签
    [self createTagLabels:@[@"糗事", @"搞笑"]];
}

- (void)addButtonClick
{
    __weak typeof(self) weakSelf = self;
    GWAddTagViewController *vc = [[GWAddTagViewController alloc] init];
    vc.completionBlock = ^(NSArray *tags){
        [weakSelf createTagLabels:tags];
    };
    vc.tags = [self.tagLabels valueForKeyPath:@"text"];
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = (UINavigationController *)root.presentedViewController;
    [nav pushViewController:vc animated:YES];
}


/**
 *  在当前方法中取到的frame的信息才是最准确的，awakefromnib中是xib的尺寸信息
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (int i = 0; i < self.tagLabels.count; i++) {
        UILabel *tagLabel = self.tagLabels[i];
        
        // 设置位置
        if (i == 0) { // 最前面的标签
            tagLabel.x = 0;
            tagLabel.y = 0;
        } else { // 其他标签
            UILabel *lastTagLabel = self.tagLabels[i - 1];
            // 计算当前行左边的宽度
            CGFloat leftWidth = CGRectGetMaxX(lastTagLabel.frame) + GWTagMargin;
            // 计算当前行右边的宽度
            CGFloat rightWidth = self.topView.width - leftWidth;
            if (rightWidth >= tagLabel.width) { // 按钮显示在当前行
                tagLabel.y = lastTagLabel.y;
                tagLabel.x = leftWidth;
            } else { // 按钮显示在下一行
                tagLabel.x = 0;
                tagLabel.y = CGRectGetMaxY(lastTagLabel.frame) + GWTagMargin;
            }
        }
    }
    
    // 最后一个标签
    UILabel *lastTagLabel = [self.tagLabels lastObject];
    CGFloat leftWidth = CGRectGetMaxX(lastTagLabel.frame) + GWTagMargin;
    
    // 更新textField的frame
    if (self.topView.width - leftWidth >= self.addButton.width) {
        self.addButton.y = lastTagLabel.y;
        self.addButton.x = leftWidth;
    } else {
        self.addButton.x = 0;
        self.addButton.y = CGRectGetMaxY(lastTagLabel.frame) + GWTagMargin;
    }
    
    // 更新高度
    CGFloat oldH = self.height;
    self.height = CGRectGetMaxY(self.addButton.frame) + GWTagMargin + 35;
    self.y -= self.height - oldH;
}

/**
 * 创建标签
 */
- (void)createTagLabels:(NSArray *)tags
{
    [self.tagLabels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.tagLabels removeAllObjects];
    
    for (int i = 0; i<tags.count; i++) {
        UILabel *tagLabel = [[UILabel alloc] init];
        [self.tagLabels addObject:tagLabel];
        tagLabel.backgroundColor = GWTagBg;
        tagLabel.textAlignment = NSTextAlignmentCenter;
        tagLabel.text = tags[i];
        tagLabel.font = GWTagFont;
        // 应该要先设置文字和字体后，再进行计算
        [tagLabel sizeToFit];
        tagLabel.width += 2 * GWTagMargin;
        tagLabel.height = GWTagH;
        tagLabel.textColor = [UIColor whiteColor];
        [self.topView addSubview:tagLabel];
    }
    
    // 实时更新frame信息，由系统调用layoutsubviews方法
    [self setNeedsLayout];
}
@end
