//
//  GWMeCell.m
//  仿百思不得姐
//
//  Created by gongqiuwei on 16/4/28.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//

#import "GWMeCell.h"

@implementation GWMeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UIImageView *bgView = [[UIImageView alloc] init];
        bgView.image = [UIImage imageNamed:@"mainCellBackground"];
        self.backgroundView = bgView;
        
        self.textLabel.textColor = [UIColor darkGrayColor];
        self.textLabel.font = [UIFont systemFontOfSize:16];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!self.imageView.image) return;
    
    self.imageView.width = 30;
    self.imageView.height = 30;
    self.imageView.y = (self.contentView.height - self.imageView.height) * 0.5;
    
    self.textLabel.x = self.imageView.x + self.imageView.width + GWTopicCellMargin;
}
@end
