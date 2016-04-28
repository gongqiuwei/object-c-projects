//
//  UIImage+Extension.m
//  仿百思不得姐
//
//  Created by gongqiuwei on 16/4/28.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)
/**
 * 圆形图片
 */
- (UIImage *)circleImage
{
    // 开启图形上下文
    // NO表示透明
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 划圆
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(ctx, rect);
    
    // 裁剪
    CGContextClip(ctx);
    
    // 图片绘制
    [self drawInRect:rect];
    
    // 获取图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}
@end
