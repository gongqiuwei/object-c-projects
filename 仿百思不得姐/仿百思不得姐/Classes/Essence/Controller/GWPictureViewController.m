//
//  GWPictureViewController.m
//  仿百思不得姐
//
//  Created by gongqiuwei on 16/4/22.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//

#import "GWPictureViewController.h"
#import "GWTopic.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"

@interface GWPictureViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) UIImageView *imageView;
@end

@implementation GWPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 屏幕参数
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    
    // 添加imageView
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.topic.large_image]];
    [self.scrollView addSubview:imageView];
    self.imageView = imageView;
    
    // 计算显示图片尺寸
    CGFloat imageW = screenW;
    CGFloat imageH = self.topic.height * imageW / self.topic.width;
    
    if (imageH > screenH) { // 大图，超出屏幕
        imageView.frame = CGRectMake(0, 0, imageW, imageH);
        self.scrollView.contentSize = CGSizeMake(0, imageH);
    } else { // 小图，居中显示
        imageView.size = CGSizeMake(imageW, imageH);
        imageView.centerY = screenH * 0.5;
    }
}


- (IBAction)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 保存图片
- (IBAction)save
{
    // 写入相册
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

// 写入相册回调方法, 方法的命名在上面的方法注释中有推荐，需要知道能接受三个参数的方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"保存失败!"];
    } else {
        [SVProgressHUD showSuccessWithStatus:@"保存成功!"];
    }
}
@end
