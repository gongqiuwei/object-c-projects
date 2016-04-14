//
//  GWCagetoryCell.h
//  仿百思不得姐
//
//  Created by gongqiuwei on 16/4/14.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GWRecommendCategory;

@interface GWRecommendCagetoryCell : UITableViewCell
/** 类别模型 */
@property (nonatomic, strong) GWRecommendCategory *category;
@end
