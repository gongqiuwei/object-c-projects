//
//  GWTopicVideoView.m
//  仿百思不得姐
//
//  Created by gongqiuwei on 16/4/25.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//

#import "GWTopicVideoView.h"
#import "GWTopic.h"
#import "UIImageView+WebCache.h"
#import "GWPictureViewController.h"

@interface GWTopicVideoView()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *voicetimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *playcountLabel;
@end

@implementation GWTopicVideoView

+ (instancetype)videoView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib
{
    // autoresizing属性使得view的frame会被拉伸，而不受外部frame设定的控制
    self.autoresizingMask = UIViewAutoresizingNone;
    
    // 给图片添加监听器
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture)]];
}

// 查看图片
- (void)showPicture
{
    GWPictureViewController *show = [[GWPictureViewController alloc] init];
    show.topic = self.topic;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:show animated:YES completion:nil];
}

- (void)setTopic:(GWTopic *)topic
{
    _topic = topic;
    
    // 图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.large_image]];
    
    // 播放次数
    self.playcountLabel.text = [NSString stringWithFormat:@"%zd播放", topic.playcount];
    
    // 时长
    NSInteger minute = topic.videotime / 60;
    NSInteger second = topic.videotime % 60;
    self.voicetimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", minute, second];
}

@end