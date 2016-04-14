//
//  GWRecommendCagetory.m
//  仿百思不得姐
//
//  Created by gongqiuwei on 16/4/14.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//

#import "GWRecommendCategory.h"

@implementation GWRecommendCategory
- (NSMutableArray *)users
{
    if (!_users) {
        _users = [NSMutableArray array];
    }
    return _users;
}
@end
