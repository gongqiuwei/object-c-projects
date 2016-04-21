//
//  GWTopicPictureView.h
//  仿百思不得姐
//
//  Created by gongqiuwei on 16/4/21.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GWTopic;

@interface GWTopicPictureView : UIView

@property (nonatomic, strong) GWTopic *topic;

+ (instancetype)pictureView;
@end
