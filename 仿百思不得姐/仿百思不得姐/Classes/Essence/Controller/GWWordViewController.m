//
//  GWWordViewController.m
//  仿百思不得姐
//
//  Created by gongqiuwei on 16/4/18.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//  纯文字的界面（段子）

#import "GWWordViewController.h"
#import "GWTopic.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"

@interface GWWordViewController ()
/** 帖子数据 */
@property (nonatomic, strong) NSMutableArray *topics;
/** 当前页码 */
@property (nonatomic, assign) NSInteger page;
/** 当加载下一页数据时需要这个参数 */
@property (nonatomic, copy) NSString *maxtime;
/** 上一次的请求参数, 用于甄别处理最后一次网络请求返回的数据 */
@property (nonatomic, strong) NSDictionary *params;
@end

@implementation GWWordViewController

- (NSMutableArray *)topics
{
    if (_topics == nil) {
        _topics = [NSMutableArray array];
    }
    return _topics;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 集成刷新控件
    [self initRefresh];
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
    params[@"type"] = @"29";
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
    params[@"type"] = @"29";
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
    
    static NSString *ID = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    GWTopic *topic = self.topics[indexPath.row];
    cell.textLabel.text = topic.name;
    cell.detailTextLabel.text = topic.text;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:topic.profile_image] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    
    return cell;
}


@end
