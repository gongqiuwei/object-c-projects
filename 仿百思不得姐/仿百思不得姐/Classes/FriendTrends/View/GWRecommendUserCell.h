//
//  GWRecommendUserCellTableViewCell.h
//  仿百思不得姐
//
//  Created by gongqiuwei on 16/4/14.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GWRecommendUser;

@interface GWRecommendUserCell : UITableViewCell
/** 用户模型 */
@property (nonatomic, strong) GWRecommendUser *user;
@end
