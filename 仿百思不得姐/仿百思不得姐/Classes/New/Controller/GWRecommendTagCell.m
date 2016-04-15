//
//  GWRecommendTagCell.m
//  仿百思不得姐
//
//  Created by apple on 16/4/14.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//

#import "GWRecommendTagCell.h"
#import "GWRecommendTag.h"
#import "UIImageView+WebCache.h"

@interface GWRecommendTagCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageListImageView;
@property (weak, nonatomic) IBOutlet UILabel *themeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subNumberLabel;
@end

@implementation GWRecommendTagCell

- (void)setRecommendTag:(GWRecommendTag *)recommendTag
{
    _recommendTag = recommendTag;
    
    [self.imageListImageView sd_setImageWithURL:[NSURL URLWithString:recommendTag.image_list] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    self.themeNameLabel.text = recommendTag.theme_name;
    NSString *subNumber = nil;
    if (recommendTag.sub_number < 10000) {
        subNumber = [NSString stringWithFormat:@"%zd人订阅", recommendTag.sub_number];
    } else { // 大于等于10000
        subNumber = [NSString stringWithFormat:@"%.1f万人订阅", recommendTag.sub_number / 10000.0];
    }
    self.subNumberLabel.text = subNumber;
}

- (void)setFrame:(CGRect)frame
{
    // 让cell左边有间距
    frame.origin.x = 5;
    frame.size.width -= 2 * frame.origin.x;
    
    // 让cell的高度减少，留出2个cell之间的空隙，相当于有分割线
    frame.size.height -= 1;
    
    [super setFrame:frame];
}
@end
