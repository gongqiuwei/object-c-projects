//
//  GWPublishViewController.m
//  仿百思不得姐
//
//  Created by gongqiuwei on 16/4/22.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//

#import "GWPublishViewController.h"
#import "GWVerticalButton.h"
#import "POP.h"
#import "GWPostWordViewController.h"
#import "GWNavigationController.h"

static CGFloat const GWAnimationDelay = 0.1;
static CGFloat const GWSpringFactor = 10;

@interface GWPublishViewController ()

@end

@implementation GWPublishViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 让控制器的view不能被点击(正在进行动画，不允许交互)
    self.view.userInteractionEnabled = NO;
    
    // 数据
    NSArray *images = @[@"publish-video", @"publish-picture", @"publish-text", @"publish-audio", @"publish-review", @"publish-offline"];
    NSArray *titles = @[@"发视频", @"发图片", @"发段子", @"发声音", @"审帖", @"离线下载"];
    
    // 中间的6个按钮
    // 每一行最多有多少列
    int maxCols = 3;
    // 按钮宽度
    CGFloat buttonW = 72;
    // 自定义的VerticalButton中，图片是正方形，留下的30是文字的高度
    CGFloat buttonH = buttonW + 30;
    CGFloat buttonStartY = (GWScreenH - 2 * buttonH) * 0.5;
    CGFloat buttonStartX = 20;
    CGFloat xMargin = (GWScreenW - 2 * buttonStartX - maxCols * buttonW) / (maxCols - 1);
    for (int i = 0; i<images.count; i++) {
        GWVerticalButton *button = [[GWVerticalButton alloc] init];
        button.tag = i;
        // 设置内容
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
        // 计算frame(button只做y轴的动画)
        int row = i / maxCols;
        int col = i % maxCols;
        
        CGFloat buttonX = buttonStartX + col * (xMargin + buttonW);
        // 结束的y值
        CGFloat buttonToY = buttonStartY + row * buttonH;
        // 起始的y值
        CGFloat buttonFromY = buttonToY - GWScreenH;
        
        // 添加button的动画
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        // 弹性设定
        anim.springBounciness = GWSpringFactor;
        anim.springSpeed = GWSpringFactor;
        // 动画开始时间
        anim.beginTime = CACurrentMediaTime() + i * GWAnimationDelay;
        // 动画的起始值
        anim.fromValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonFromY, buttonW, buttonH)];
        anim.toValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonToY, buttonW, buttonH)];
        // 添加动画
        [button pop_addAnimation:anim forKey:nil];
    }
    
    // 添加标语
    UIImageView *sloganView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_slogan"]];
    [self.view addSubview:sloganView];
    
    // 给标语添加动画
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    // 弹性设定
    anim.springBounciness = GWSpringFactor;
    anim.springSpeed = GWSpringFactor;
    // 动画开始时间
    anim.beginTime = CACurrentMediaTime() + images.count * GWAnimationDelay;
    // 动画的起始值
    CGFloat centerX = GWScreenW * 0.5;
    CGFloat centerEndY = GWScreenH * 0.2;
    CGFloat centerBeginY = centerEndY - GWScreenH;
    anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(centerX, centerBeginY)];;
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(centerX, centerEndY)];
    // 动画完成的回调
    [anim setCompletionBlock:^(POPAnimation *anim, BOOL isFinished) {
        // 动画执行完毕，允许UI交互
        self.view.userInteractionEnabled = YES;
    }];
    // 添加动画
    [sloganView pop_addAnimation:anim forKey:nil];
}

- (void)buttonClicked:(UIButton *)button
{
    [self cancelWithCompletionBlock:^{
        if (button.tag == 2) {
            
            GWPostWordViewController *word = [[GWPostWordViewController alloc] init];
            GWNavigationController *nav = [[GWNavigationController alloc] initWithRootViewController:word];
            // 弹出控制器
           UIViewController *rootVc = [UIApplication sharedApplication].keyWindow.rootViewController;
            [rootVc presentViewController:nav animated:YES completion:nil];
        }
    }];
}

- (void)cancelWithCompletionBlock:(void(^)())completion
{
    // 准备执行动画，不允许交互
    self.view.userInteractionEnabled = NO;
    
    // 需要根据子控件的加入顺序来定
    NSInteger beginIndex = 2;
    
    // 执行动画然后界面消失
    for (NSInteger i = beginIndex; i < self.view.subviews.count; i++) {
        UIView *subView = self.view.subviews[i];
        
        // 添加动画(消失的时候无需弹簧效果)
        POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
        // 动画开始时间
        anim.beginTime = CACurrentMediaTime() + (i - beginIndex) * GWAnimationDelay;
        // 动画的执行节奏(一开始很慢, 后面很快)
//        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        // 动画的起始值
        CGFloat centerX = subView.centerX;
        CGFloat centerBeginY = subView.centerY;
        CGFloat centerEndY = centerBeginY + GWScreenH;
        anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(centerX, centerBeginY)];;
        anim.toValue = [NSValue valueWithCGPoint:CGPointMake(centerX, centerEndY)];
        
        if (i == self.view.subviews.count - 1) {
            [anim setCompletionBlock:^(POPAnimation *anim, BOOL isFinished) {
                [self dismissViewControllerAnimated:NO completion:nil];
                
                // 执行传入的block， 通知外部
                !completion ? : completion();
            }];
        }
        
        [subView pop_addAnimation:anim forKey:nil];
    }
}

// 退出界面
- (IBAction)cancel
{
    [self cancelWithCompletionBlock:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 退出界面
    [self cancel];
}

@end
