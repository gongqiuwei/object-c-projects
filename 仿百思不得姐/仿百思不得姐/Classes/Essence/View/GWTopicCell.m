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
#import "GWTopicPictureView.h"
#import "GWTopicAudioView.h"
#import "GWTopicVideoView.h"
#import "GWComment.h"
#import "GWUser.h"

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
/** 新浪加V */
@property (weak, nonatomic) IBOutlet UIImageView *sinaVView;
@property (weak, nonatomic) IBOutlet UILabel *my_textLabel;
/** 最热评论的内容 */
@property (weak, nonatomic) IBOutlet UILabel *topCmtContentLabel;
/** 最热评论的整体 */
@property (weak, nonatomic) IBOutlet UIView *topCmtView;

/** 中间的内容是图片 */
@property (nonatomic, weak) GWTopicPictureView *pictureView;
/** 声音帖子中间的内容 */
@property (nonatomic, weak) GWTopicAudioView *audioView;
/** 声音帖子中间的内容 */
@property (nonatomic, weak) GWTopicVideoView *videoView;
@end

@implementation GWTopicCell
/**
 *  快速创建cell（当做普通view使用的情况）
 */
+ (instancetype)cell
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}


- (GWTopicPictureView *)pictureView
{
    if (_pictureView == nil) {
        GWTopicPictureView *view = [GWTopicPictureView pictureView];
        [self.contentView addSubview:view];
        _pictureView = view;
    }
    return _pictureView;
}

- (GWTopicAudioView *)audioView
{
    if (_audioView == nil) {
        GWTopicAudioView *view = [GWTopicAudioView audioView];
        [self.contentView addSubview:view];
        _audioView = view;
    }
    return _audioView;
}

- (GWTopicVideoView *)videoView
{
    if (_videoView == nil) {
        GWTopicVideoView *view = [GWTopicVideoView videoView];
        [self.contentView addSubview:view];
        _videoView = view;
    }
    return _videoView;
}

- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.image = [UIImage imageNamed:@"mainCellBackground"];
    self.backgroundView = bgView;
}


- (void)setTopic:(GWTopic *)topic
{
    _topic = topic;
    
    // 新浪加V
    self.sinaVView.hidden = !topic.isSina_v;
    
    UIImage *placeholder = [[UIImage imageNamed:@"defaultUserIcon"] circleImage];
    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:topic.profile_image] placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        GWLog(@"%@ %@", topic.name, topic.profile_image);
        self.profileImageView.image = (image ? [image circleImage] : placeholder);
    }];
    
    // 设置其他控件
    self.my_textLabel.text = topic.text;
    
    self.nameLabel.text = topic.name;
    self.createTimeLabel.text = topic.create_time;
    
    // 设置按钮文字（评论为0时候显示占位文字）
    [self setupButtonTitle:self.dingButton count:topic.ding placeholder:@"顶"];
    [self setupButtonTitle:self.caiButton count:topic.cai placeholder:@"踩"];
    [self setupButtonTitle:self.shareButton count:topic.repost placeholder:@"分享"];
    [self setupButtonTitle:self.commentButton count:topic.comment placeholder:@"评论"];
    
    if (topic.type == GWTopicTypePicture) { // 中间内容是图片
        self.pictureView.topic = topic;
        self.pictureView.frame = topic.pictureF;
        
        _pictureView.hidden = NO;
        _audioView.hidden = YES;
        _audioView.hidden = YES;
        
    } else if (topic.type == GWTopicTypeAudio) { // 中间内容是声音
        self.audioView.topic = topic;
        self.audioView.frame = topic.audioF;
        
        _audioView.hidden = NO;
        _videoView.hidden = YES;
        _pictureView.hidden = YES;
        
    } else if (topic.type == GWTopicTypeVideo) { // 中间内容是视频
        self.videoView.topic = topic;
        self.videoView.frame = topic.videoF;
        
        _videoView.hidden = NO;
        _pictureView.hidden = YES;
        _audioView.hidden = YES;
    } else { // 中间没有内容(段子帖子)
        
        _videoView.hidden = YES;
        _audioView.hidden = YES;
        _pictureView.hidden = YES;
    }
    
    // 最热评论
    GWComment *cmt = [topic.top_cmt firstObject];
    if (cmt) { // 有最热评论
        self.topCmtView.hidden = NO;
        self.topCmtContentLabel.text = [NSString stringWithFormat:@"%@ : %@", cmt.user.username, cmt.content];
    } else { // 没有最热评论
        self.topCmtView.hidden = YES;
    }
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
//    frame.origin.x = GWTopicCellMargin;
//    frame.size.width -= 2 * GWTopicCellMargin;
    // 所有的cell高度-10，留出分隔
    frame.size.height -= GWTopicCellMargin;
    // 所有的cell下移10
    frame.origin.y += GWTopicCellMargin;
    
    [super setFrame:frame];
}
- (IBAction)shareClicked
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"收藏", @"举报", nil];
    [sheet showInView:self.window];
}

@end
