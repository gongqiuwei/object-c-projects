//
//  GWRecommendTag.h
//  仿百思不得姐
//
//  Created by apple on 16/4/14.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GWRecommendTag : NSObject
/** 图片 */
@property (nonatomic, copy) NSString *image_list;
/** 名字 */
@property (nonatomic, copy) NSString *theme_name;
/** 订阅数 */
@property (nonatomic, assign) NSInteger sub_number;
@end
