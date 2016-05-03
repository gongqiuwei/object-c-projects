//
//  GWTagTextField.h
//  仿百思不得姐
//
//  Created by apple on 16/5/3.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GWTagTextField : UITextField
@property (nonatomic, copy) void(^deleteBlock)();
@end
