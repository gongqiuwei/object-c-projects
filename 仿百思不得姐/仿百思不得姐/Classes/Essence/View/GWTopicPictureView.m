//
//  GWTopicPictureView.m
//  仿百思不得姐
//
//  Created by gongqiuwei on 16/4/21.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//

#import "GWTopicPictureView.h"
#import "GWTopic.h"
#import "UIImageView+WebCache.h"
#import "GWProgressView.h"
#import "GWPictureViewController.h"

@interface GWTopicPictureView()
/** 图片 */
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
/** gif标识 */
@property (weak, nonatomic) IBOutlet UIImageView *gifView;
/** 查看大图按钮 */
@property (weak, nonatomic) IBOutlet UIButton *seeBigButton;
@property (weak, nonatomic) IBOutlet GWProgressView *progressView;

@end

@implementation GWTopicPictureView
+ (instancetype)pictureView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib
{
    // autoresizing属性使得view的frame会被拉伸，而不受外部frame设定的控制
    self.autoresizingMask = UIViewAutoresizingNone;
    
    // 将按钮的交互禁用，这样点击按钮的事件会传递到后面的图片，就不用再拖线
    self.seeBigButton.userInteractionEnabled = NO;
    
    // 添加点击事件
    self.imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture)];
    [self.imageView addGestureRecognizer:tap];
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
    
    // 设置加载进度
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.large_image] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
        self.progressView.hidden = NO;
        CGFloat progress = 1.0 * receivedSize / expectedSize;
        [self.progressView setProgress:progress animated:YES];
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        self.progressView.hidden = YES;
    }];
    
    // 判断是否为gif
    NSString *extension = topic.large_image.pathExtension;
    self.gifView.hidden = ![extension.lowercaseString isEqualToString:@"gif"];
    
    // 判断是否显示"点击查看全图"
    if (topic.isBigPicture) { // 大图
        self.seeBigButton.hidden = NO;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    } else { // 非大图
        self.seeBigButton.hidden = YES;
        self.imageView.contentMode = UIViewContentModeScaleToFill;
    }
}
@end
