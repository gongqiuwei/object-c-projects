//
//  GWTopic.m
//  仿百思不得姐
//
//  Created by apple on 16/4/18.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//

#import "GWTopic.h"
#import "NSDate+GWExtension.h"
#import "MJExtension.h"

@implementation GWTopic
{
    CGFloat _cellHeight; // 变量申明
}

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"small_image" : @"image0",
             @"large_image" : @"image1",
             @"middle_image" : @"image2"
             };
}


- (NSString *)create_time
{
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
    
    // 日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 设置日期格式(y:年,M:月,d:日,H:时,m:分,s:秒)
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    // 帖子的创建时间
    NSDate *create = [fmt dateFromString:_create_time];
    
    if (create.isThisYear) { // 今年
        if (create.isToday) { // 今天
            NSDateComponents *cmps = [[NSDate date] deltaFrom:create];
            
            if (cmps.hour >= 1) { // 时间差距 >= 1小时
                return [NSString stringWithFormat:@"%zd小时前", cmps.hour];
            } else if (cmps.minute >= 1) { // 1小时 > 时间差距 >= 1分钟
                return [NSString stringWithFormat:@"%zd分钟前", cmps.minute];
            } else { // 1分钟 > 时间差距
                return @"刚刚";
            }
        } else if (create.isYesterday) { // 昨天
            fmt.dateFormat = @"昨天 HH:mm:ss";
            return [fmt stringFromDate:create];
        } else { // 其他
            fmt.dateFormat = @"MM-dd HH:mm:ss";
            return [fmt stringFromDate:create];
        }
    } else { // 非今年
        return _create_time;
    }
}

- (CGFloat)cellHeight
{
    if (!_cellHeight) {
        // 计算cell的高度
        // 文字的Y
        CGFloat textY = GWTopicCellTextY;
        // 文字宽度
        CGFloat textW = [UIScreen mainScreen].bounds.size.width - 4 * GWTopicCellMargin;
        CGSize maxSize = CGSizeMake(textW, MAXFLOAT);
        CGFloat textH = [self.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
        
        // 计算cell的高度
        // 文字部分的高度
        _cellHeight = GWTopicCellTextY + textH + GWTopicCellMargin;
        
        if (self.type == GWTopicTypePicture) { // 是图片
            // 图片显示出来的宽度
            CGFloat pictureW = maxSize.width;
            // 显示显示出来的高度
            CGFloat pictureH = pictureW * self.height / self.width;
            
            if (pictureH >= GWTopicCellPictureMaxH) { // 图片高度过长
                pictureH = GWTopicCellPictureBreakH;
                self.bigPicture = YES; // 大图
            }
            
            // 计算图片控件的frame
            CGFloat pictureX = GWTopicCellMargin;
            CGFloat pictureY = GWTopicCellTextY + textH + GWTopicCellMargin;
            _pictureF = CGRectMake(pictureX, pictureY, pictureW, pictureH);
            
            // margin是图片与bottomBar的间距
            _cellHeight += pictureH + GWTopicCellMargin;
            
        } else if (self.type == GWTopicTypeAudio) { // 声音
            CGFloat audioX = GWTopicCellMargin;
            CGFloat audioY = GWTopicCellTextY + textH + GWTopicCellMargin;
            CGFloat audioW = maxSize.width;
            CGFloat audioH = audioW * self.height / self.width;
            _audioF = CGRectMake(audioX, audioY, audioW, audioH);
            
            // 计算cell的高度
            _cellHeight += audioH + GWTopicCellMargin;
            
        } else if (self.type == GWTopicTypeVideo) { // 视频
            CGFloat videoX = GWTopicCellMargin;
            CGFloat videoY = GWTopicCellTextY + textH + GWTopicCellMargin;
            CGFloat videoW = maxSize.width;
            CGFloat videoH = videoW * self.height / self.width;
            _videoF = CGRectMake(videoX, videoY, videoW, videoH);
            
            // 计算cell的高度
            _cellHeight += videoH + GWTopicCellMargin;
        }
        
        // bottomBar的间距, 2个cell之间的margin
        _cellHeight += GWTopicCellBottomBarH + GWTopicCellMargin;
    }
    return _cellHeight;
}
@end
