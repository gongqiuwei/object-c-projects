//
//  GWMeViewController.m
//  仿百思不得姐
//
//  Created by gongqiuwei on 16/4/12.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//

#import "GWMeViewController.h"

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
    
    // 对tableview的样式做一些调整，达到设置页面的效果
    // group样式下tableview的section的header和footer都有默认的高度，可以调整
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = GWTopicCellMargin;
    
    // 调整contentInsert是为了是最上面的间距缩小
    // 减35是因为系统自动调整了y的位置，为35
    self.tableView.contentInset = UIEdgeInsetsMake(GWTopicCellMargin - 35, 0, 0, 0);
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
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    cell.textLabel.text = @"me";
    
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
