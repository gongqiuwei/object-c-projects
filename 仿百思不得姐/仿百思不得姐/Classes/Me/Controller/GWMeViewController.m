//
//  GWMeViewController.m
//  仿百思不得姐
//
//  Created by gongqiuwei on 16/4/12.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//

#import "GWMeViewController.h"
#import "GWMeCell.h"
#import "UIImage+Extension.h"
#import "GWMeFooterView.h"

static NSString *const GWMeCellId = @"me";

@interface GWMeViewController ()

@end

@implementation GWMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    [self setupTableView];
}

- (void)setupTableView
{
    self.tableView.backgroundColor = GWGlobalBgColor;
    
    [self.tableView registerClass:[GWMeCell class] forCellReuseIdentifier:GWMeCellId];
    
    // 对tableview的样式做一些调整，达到设置页面的效果
    // group样式下tableview的section的header和footer都有默认的高度，可以调整
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = GWTopicCellMargin;
    
    // 调整contentInsert是为了是最上面的间距缩小
    // 减35是因为系统自动调整了y的位置，为35
    self.tableView.contentInset = UIEdgeInsetsMake(GWTopicCellMargin - 35, 0, 0, 0);
    
    // 底部视图
    GWMeFooterView *footer = [[GWMeFooterView alloc] init];
    self.tableView.tableFooterView = footer;
}

- (void)setupNav
{
    self.navigationItem.title = @"我的";
    
    UIBarButtonItem *settingItem = [UIBarButtonItem itemWithImage:@"mine-setting-icon" selectImage:@"mine-setting-icon-click" target:self action:@selector(settingClicked)];
    
    UIBarButtonItem *moonItem = [UIBarButtonItem itemWithImage:@"mine-moon-icon" selectImage:@"mine-moon-icon-click" target:self action:@selector(moonClicked)];
    
    self.navigationItem.rightBarButtonItems = @[settingItem, moonItem];
}

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GWMeCell *cell = [tableView dequeueReusableCellWithIdentifier:GWMeCellId];
    
    if (indexPath.section == 0) {
        cell.imageView.image = [[UIImage imageNamed:@"defaultUserIcon"] circleImage];
        cell.textLabel.text = @"登录/注册";
        
    } else if (indexPath.section == 1) {
        cell.textLabel.text = @"离线下载";
    }
    
    return cell;
}

- (void)settingClicked
{
    GWLogFunc;
}

- (void)moonClicked
{
    GWLogFunc;
}
@end
