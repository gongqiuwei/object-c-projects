//
//  GWTopicCell.m
//  仿百思不得姐
//
//  Created by gongqiuwei on 16/4/19.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//

#import "GWTopicCell.h"
#import "GWTopic.h"
#import "UIImageView+WebCache.h"

@interface GWTopicCell()
/** 头像 */
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
/** 昵称 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/** 时间 */
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
/** 顶 */
@property (weak, nonatomic) IBOutlet UIButton *dingButton;
/** 踩 */
@property (weak, nonatomic) IBOutlet UIButton *caiButton;
/** 分享 */
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
/** 评论 */
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@end

@implementation GWTopicCell

- (void)awakeFromNib
{
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.image = [UIImage imageNamed:@"mainCellBackground"];
    self.backgroundView = bgView;
}

/**
 日期时间处理
    今年
        今天
            1分钟内
                刚刚
            1小时内
                xx分钟前
            其他
                xx小时前
        昨天
            昨天 18:56:34
        其他
            06-23 19:56:23
 
    非今年
        2014-05-08 18:45:30
 
 在模型中进行处理
 */

- (void)setTopic:(GWTopic *)topic
{
    _topic = topic;
    
    // 设置其他控件
    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:topic.profile_image] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    self.nameLabel.text = topic.name;
    self.createTimeLabel.text = topic.create_time;
    
    // 设置按钮文字（评论为0时候显示占位文字）
    [self setupButtonTitle:self.dingButton count:topic.ding placeholder:@"顶"];
    [self setupButtonTitle:self.caiButton count:topic.cai placeholder:@"踩"];
    [self setupButtonTitle:self.shareButton count:topic.repost placeholder:@"分享"];
    [self setupButtonTitle:self.commentButton count:topic.comment placeholder:@"评论"];
}

- (void)setupButtonTitle:(UIButton *)button count:(NSInteger)count placeholder:(NSString *)placeholder
{
    if (count > 10000) {
        placeholder = [NSString stringWithFormat:@"%.1f万", count / 10000.0];
    } else if (count > 0) {
        placeholder = [NSString stringWithFormat:@"%zd", count];
    }
    [button setTitle:placeholder forState:UIControlStateNormal];
}

- (void)setFrame:(CGRect)frame
{
    static CGFloat margin = 10;
    frame.origin.x = margin;
    frame.size.width -= 2 * margin;
    // 所有的cell高度-10，留出分隔
    frame.size.height -= margin;
    // 所有的cell下移10
    frame.origin.y += margin;
    
    [super setFrame:frame];
}

@end
