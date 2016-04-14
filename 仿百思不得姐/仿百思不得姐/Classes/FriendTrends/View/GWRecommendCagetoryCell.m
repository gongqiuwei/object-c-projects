//
//  GWCagetoryCell.m
//  仿百思不得姐
//
//  Created by gongqiuwei on 16/4/14.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//

#import "GWRecommendCagetoryCell.h"
#import "GWRecommendCategory.h"

@interface GWRecommendCagetoryCell()
/** 选中时显示的指示器控件 */
@property (weak, nonatomic) IBOutlet UIView *selectedIndicator;
@end

@implementation GWRecommendCagetoryCell

- (void)awakeFromNib
{
    self.backgroundColor = GWRGBColor(244, 244, 244);
}

- (void)setCategory:(GWRecommendCategory *)category
{
    _category = category;
    
    self.textLabel.text = category.name;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 调整label的位置, 使其不会遮挡自定义的分割线view
    self.textLabel.y = 2;
    self.textLabel.height -= 2 * self.textLabel.y;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // 选中指示器
    self.selectedIndicator.hidden = !selected;
    
    // 文字的颜色
    self.textLabel.textColor = selected ? self.selectedIndicator.backgroundColor : GWRGBColor(78, 78, 78);
}
@end
