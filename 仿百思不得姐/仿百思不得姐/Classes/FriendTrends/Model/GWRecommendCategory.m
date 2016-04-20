//
//  GWRecommendCagetory.m
//  仿百思不得姐
//
//  Created by gongqiuwei on 16/4/14.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//

#import "GWRecommendCategory.h"
#import "MJExtension.h"

@implementation GWRecommendCategory
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID":@"id"};
}

- (NSMutableArray *)users
{
    if (!_users) {
        _users = [NSMutableArray array];
    }
    return _users;
}
@end
