//
//  GWWordViewController.m
//  仿百思不得姐
//
//  Created by gongqiuwei on 16/4/18.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//  纯文字的界面（段子）

#import "GWTopicViewController.h"
#import "GWTopic.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"
#import "GWTopicCell.h"
#import "GWCommentViewController.h"

@interface GWTopicViewController ()
/** 帖子数据 */
@property (nonatomic, strong) NSMutableArray *topics;
/** 当前页码 */
@property (nonatomic, assign) NSInteger page;
/** 当加载下一页数据时需要这个参数 */
@property (nonatomic, copy) NSString *maxtime;
/** 上一次的请求参数, 用于甄别处理最后一次网络请求返回的数据 */
@property (nonatomic, strong) NSDictionary *params;

/** 上次选中的索引(或者控制器) */
@property (nonatomic, assign) NSInteger lastSelectedIndex;
@end

static NSString *const GWTopicCellId = @"topic";

@implementation GWTopicViewController

- (NSMutableArray *)topics
{
    if (_topics == nil) {
        _topics = [NSMutableArray array];
    }
    return _topics;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat top = GWTitilesViewY + GWTitilesViewH;
    CGFloat bottom = self.tabBarController.tabBar.height;
    self.tableView.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
    // 设置滚动条的内边距
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GWTopicCell class]) bundle:nil] forCellReuseIdentifier:GWTopicCellId];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    // 监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabbarSelect) name:GWTabBarDidSelectNotification object:nil];
    
    // 集成刷新控件
    [self initRefresh];
}

- (void)tabbarSelect
{
    // 重复选中， 并且当前控制器的view显示在主窗口上 -> 刷新数据
    if (self.lastSelectedIndex == self.tabBarController.selectedIndex && [self.view isShowingOnKeyWindow]) {
        // 刷新页面数据
        [self.tableView.header beginRefreshing];
    }
    
    // 记录这一次选中的索引
    self.lastSelectedIndex = self.tabBarController.selectedIndex;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 集成刷新控件
- (void)initRefresh
{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 设置为yes会自动根据位置隐藏或者显示header
    self.tableView.header.autoChangeAlpha = YES;
    [self.tableView.header beginRefreshing];
    
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)loadNewData
{
    // 结束上拉（有可能同时上拉、下拉请求数据，但是只会处理其中一个，所以要控制另一个的状态）
    [self.tableView.footer endRefreshing];
    
    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"data";
    params[@"type"] = @(self.type);
    self.params = params;
    
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 不是最后一次网络请求，不进行处理
        if (self.params != params) return;
        
        // 存储时间
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        // 获取数据
        self.topics = [GWTopic objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 列表刷新
        [self.tableView reloadData];
        
        // 停止刷新控件
        [self.tableView.header endRefreshing];
        
        // 清空页码
        self.page = 0;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 不是最后一次网络请求，不进行处理
        if (self.params != params) return;
        
        // 停止刷新控件
        [self.tableView.header endRefreshing];
    }];
}

- (void)loadMoreData
{
    // 结束下拉（有可能同时上拉、下拉请求数据，但是只会处理其中一个，所以要控制另一个的状态）
    [self.tableView.header endRefreshing];
    
    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"data";
    params[@"type"] = @(self.type);
    params[@"page"] = @(self.page + 1);
    params[@"maxtime"] = self.maxtime;
    self.params = params;
    
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 不是最后一次网络请求，不进行处理
        if (self.params != params) return;
        
        // 存储时间
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        // 获取数据
        NSArray *topics = [GWTopic objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [self.topics addObjectsFromArray:topics];
        
        // 列表刷新
        [self.tableView reloadData];
        
        // 停止刷新控件
        [self.tableView.footer endRefreshing];
        
        // 页码+1
        self.page++;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 不是最后一次网络请求，不进行处理
        if (self.params != params) return;
        
        // 停止刷新控件
        [self.tableView.footer endRefreshing];
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.topics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GWTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:GWTopicCellId];
    
    cell.topic = self.topics[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GWTopic *topic = self.topics[indexPath.row];
    
    return topic.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GWCommentViewController *commentVc = [[GWCommentViewController alloc] init];
    commentVc.topic = self.topics[indexPath.row];
    [self.navigationController pushViewController:commentVc animated:YES];
}
@end
