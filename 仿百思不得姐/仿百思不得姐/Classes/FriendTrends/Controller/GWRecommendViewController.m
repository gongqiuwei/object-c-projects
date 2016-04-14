//
//  GWRecommendViewController.m
//  仿百思不得姐
//
//  Created by gongqiuwei on 16/4/14.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//

#import "GWRecommendViewController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "GWRecommendCagetoryCell.h"
#import "GWRecommendCategory.h"
#import "GWRecommendUserCell.h"
#import "GWRecommendUser.h"

@interface GWRecommendViewController ()<UITableViewDataSource, UITableViewDelegate>
/** 左边的类别表格 */
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
/** 右边的用户表格 */
@property (weak, nonatomic) IBOutlet UITableView *userTableView;

/** 左边的类别数据 */
@property (nonatomic, strong) NSArray *categorys;

@end

static NSString *const GWCategoryId = @"category";
static NSString * const GWUserId = @"user";

@implementation GWRecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // UI初始化
    [self initUI];
    
    // 显示指示器
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    // 获取数据
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"category";
    params[@"c"] = @"subscribe";
    
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        
        // 模型转换
        self.categorys = [GWRecommendCategory objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 刷新表格
        [self.categoryTableView reloadData];
        
        // 选中第一行
        [self.categoryTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"加载推荐信息失败!"];
    }];
}

// UI初始化
- (void)initUI
{
    self.title = @"推荐关注";
    self.view.backgroundColor = GWGlobalBgColor;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.categoryTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.userTableView.contentInset = self.categoryTableView.contentInset;
    self.userTableView.rowHeight = 70;
    
    // 注册cell
    [self.categoryTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GWRecommendCagetoryCell class]) bundle:nil] forCellReuseIdentifier:GWCategoryId];
    [self.userTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GWRecommendUserCell class]) bundle:nil] forCellReuseIdentifier:GWUserId];
    
    // 集成刷新控件
    self.userTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreUsers)];
    
    self.userTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewUsers)];
}

/**
 *  获取当前用户选中的类别对应的模型数据
 */
- (GWRecommendCategory *)selectedRecommendCategory
{
    NSIndexPath *path = [self.categoryTableView indexPathForSelectedRow];
    return self.categorys[path.row];
}

/**
 *  实时监测footer的状态
 */
- (void)checkFooterStatus
{
    // 当前选中的类别模型
    GWRecommendCategory *category = [self selectedRecommendCategory];
    
    // 判断刷新控件的隐藏与否(没有数据就需要隐藏)
    self.userTableView.footer.hidden = (category.users.count==0);
    if (self.userTableView.footer.hidden) return;
    
    // 判断刷新状态
    if (category.users.count == category.total) {
        [self.userTableView.footer noticeNoMoreData];
    } else {
        [self.userTableView.footer endRefreshing];
    }
}

#pragma mark - 加载用户数据
/**
 *  header刷新时调用
 */
- (void)loadNewUsers
{
    // 当前选中的类别模型
    GWRecommendCategory *category = [self selectedRecommendCategory];
    
    // 设置页码
    category.currentPage = 1;
    
    // 发送请求给服务器, 加载右侧的数据
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"subscribe";
    params[@"category_id"] = @(category.id);
    params[@"page"] = @(category.currentPage);
    
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        // 清除之前的数据
        [category.users removeAllObjects];
        
        // 数据处理
        NSArray *users = [GWRecommendUser objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 添加新的数据
        [category.users addObjectsFromArray:users];
        category.total = [responseObject[@"total"] integerValue];
        
        // 刷新右边的表格
        [self.userTableView reloadData];
        
        // 结束下拉刷新控件的状态
        [self.userTableView.header endRefreshing];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 提醒用户
        [SVProgressHUD showErrorWithStatus:@"推荐用户信息加载失败"];
        
        // 结束下拉刷新控件的状态
        [self.userTableView.header endRefreshing];
    }];
}

/**
 *  footer控件刷新时调用
 */
- (void)loadMoreUsers
{
    // 当前选中的类别模型
    GWRecommendCategory *category = [self selectedRecommendCategory];
    
    // 发送请求给服务器, 加载右侧的数据
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"subscribe";
    params[@"category_id"] = @(category.id);
    params[@"page"] = @(category.currentPage+1);
    
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        // 数据处理
        NSArray *users = [GWRecommendUser objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        [category.users addObjectsFromArray:users];
        category.currentPage ++;
        
        // 刷新右边的表格
        [self.userTableView reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 提醒用户
        [SVProgressHUD showErrorWithStatus:@"推荐用户信息加载失败"];
        
        // 结束控件的刷新状态
        [self.userTableView.footer endRefreshing];
    }];
}

#pragma mark - <UITableViewDataSource, UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.categoryTableView) {
        return self.categorys.count;
    } else {
        // 当前选中的类别模型
        GWRecommendCategory *category = [self selectedRecommendCategory];
        
        // 实时监测footer的状态
        [self checkFooterStatus];
        
        // 返回
        return category.users.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.categoryTableView) {
        GWRecommendCagetoryCell *cell  = [tableView dequeueReusableCellWithIdentifier:GWCategoryId];
        
        cell.category = self.categorys[indexPath.row];
        
        return cell;
    } else {
        GWRecommendUserCell *cell  = [tableView dequeueReusableCellWithIdentifier:GWUserId];
        
        // 当前选中的类别模型
        GWRecommendCategory *category = [self selectedRecommendCategory];
        cell.user = category.users[indexPath.row];
        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GWRecommendCategory *category = self.categorys[indexPath.row];
    
    // 判断是否已经有用户数据
    if (category.users.count) {
        // 刷新右边的表格
        [self.userTableView reloadData];
        
    } else {
        // 赶紧刷新表格,目的是: 马上显示当前category的用户数据, 不让用户看见上一个category的残留数据
        [self.userTableView reloadData];
        
        // 下拉刷新
        [self.userTableView.header beginRefreshing];
    }
}
@end
