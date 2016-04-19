//
//  GWTopicCell.h
//  仿百思不得姐
//
//  Created by gongqiuwei on 16/4/19.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GWTopic;

@interface GWTopicCell : UITableViewCell
/** 帖子模型 */
@property (nonatomic, strong) GWTopic *topic;
@end
