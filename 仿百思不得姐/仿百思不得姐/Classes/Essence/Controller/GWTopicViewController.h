//
//  GWTopicViewController.h
//  仿百思不得姐
//
//  Created by gongqiuwei on 16/4/20.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GWTopicType) {
    GWTopicTypeAll = 1,
    GWTopicTypePicture = 10,
    GWTopicTypeWord = 29,
    GWTopicTypeVoice = 31,
    GWTopicTypeVideo = 41
};

@interface GWTopicViewController : UITableViewController
/** 帖子类型(交给子类去实现) */
@property (nonatomic, assign) GWTopicType type;
@end
