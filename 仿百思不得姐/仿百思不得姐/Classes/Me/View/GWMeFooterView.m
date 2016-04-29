//
//  GWMeFooterView.m
//  仿百思不得姐
//
//  Created by gongqiuwei on 16/4/29.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//

#import "GWMeFooterView.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "GWSquare.h"
#import "GWSquareButton.h"

@implementation GWMeFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        // 参数
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"a"] = @"square";
        params[@"c"] = @"topic";
        
        // 发送请求
        [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
            NSArray *sqaures = [GWSquare objectArrayWithKeyValuesArray:responseObject[@"square_list"]];
            
            // 创建方块
            [self createSquares:sqaures];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
    return self;
}

- (void)createSquares:(NSArray *)sqaures
{
    // 一行最多4列
    int maxCols = 4;
    
    // 宽度和高度
    CGFloat buttonW = GWScreenW / maxCols;
    CGFloat buttonH = buttonW;
    
    for (int i = 0; i<sqaures.count; i++) {
        // 创建按钮
        GWSquareButton *button = [GWSquareButton buttonWithType:UIButtonTypeCustom];
        // 监听点击
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        // 传递模型
        button.square = sqaures[i];
        [self addSubview:button];
        
        // 计算frame
        int col = i % maxCols;
        int row = i / maxCols;
        
        button.x = col * buttonW;
        button.y = row * buttonH;
        button.width = buttonW;
        button.height = buttonH;
        
        // footerView的高度
        if (i == sqaures.count-1) {
            self.height = CGRectGetMaxY(button.frame);
            
            // 重新设置内容尺寸
            UITableView *superView = (UITableView *)self.superview;
            CGSize wholesize =  superView.contentSize;
            wholesize.height = superView.contentSize.height + self.height;
            superView.contentSize = wholesize;
        }
    }
    
    // 计算自己的高度的另一种方式：获取row的数目，然后乘以buttonW
    // 总页数 == (总个数 + 每页的最大数 - 1) / 每页最大数
//    NSUInteger rows = (sqaures.count + maxCols - 1) / maxCols;
}


- (void)buttonClick:(GWSquareButton *)button
{
    GWLogFunc;
}
@end
