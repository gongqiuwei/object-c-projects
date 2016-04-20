//
//  GWTopic.m
//  仿百思不得姐
//
//  Created by apple on 16/4/18.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//

#import "GWTopic.h"
#import "NSDate+GWExtension.h"

@implementation GWTopic
{
    CGFloat _cellHeight; // 变量申明
}

- (NSString *)create_time
{
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
        
        // 前面的margin是text与bottomBar的间距， 后面的margin是2个cell之间的margin
        _cellHeight = textY + textH + GWTopicCellMargin + GWTopicCellBottomBarH + GWTopicCellMargin;
    }
    return _cellHeight;
}
@end
