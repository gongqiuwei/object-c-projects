//
//  GWAddTagToolbar.m
//  仿百思不得姐
//
//  Created by gongqiuwei on 16/5/3.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//

#import "GWAddTagToolbar.h"
#import "GWAddTagViewController.h"

@interface GWAddTagToolbar()
@property (weak, nonatomic) IBOutlet UIView *topView;
@end

@implementation GWAddTagToolbar
+ (instancetype)toolbar
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib
{
    // 添加一个加号按钮
    UIButton *addButton = [[UIButton alloc] init];
    [addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [addButton setImage:[UIImage imageNamed:@"tag_add_icon"] forState:UIControlStateNormal];
    //    addButton.size = [UIImage imageNamed:@"tag_add_icon"].size;
    //    addButton.size = [addButton imageForState:UIControlStateNormal].size;
    addButton.size = addButton.currentImage.size;
    addButton.x = GWTopicCellMargin;
    [self.topView addSubview:addButton];
}

- (void)addButtonClick
{
    GWAddTagViewController *vc = [[GWAddTagViewController alloc] init];
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = (UINavigationController *)root.presentedViewController;
    [nav pushViewController:vc animated:YES];
    
    // a modal 出 b
    //    [a presentViewController:b animated:YES completion:nil];
    //    a.presentedViewController -> b
    //    b.presentingViewController -> a
}
@end
