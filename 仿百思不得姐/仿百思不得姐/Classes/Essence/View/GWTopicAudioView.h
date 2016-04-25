//
//  GWAudioView.h
//  仿百思不得姐
//
//  Created by gongqiuwei on 16/4/25.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GWTopic;

@interface GWTopicAudioView : UIView

@property (nonatomic, strong) GWTopic *topic;

+ (instancetype)audioView;

@end
