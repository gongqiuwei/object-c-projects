//
//  GWRecommendTagViewController.m
//  仿百思不得姐
//
//  Created by apple on 16/4/14.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//

#import "GWRecommendTagViewController.h"
#import "GWRecommendTagCell.h"
#import "GWRecommendTag.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "MJExtension.h"

@interface GWRecommendTagViewController ()
/** 标签数据 */
@property (nonatomic, strong) NSArray *tags;
@end

static NSString *const GWRecommendTagId = @"tag";

@implementation GWRecommendTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化UI界面
    [self initUI];
    
    // 加载tags数据
    [self loadTags];
}

// 初始化UI界面
- (void)initUI
{
    self.title = @"推荐标签";
    self.tableView.backgroundColor = GWGlobalBgColor;
    self.tableView.rowHeight = 70;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GWRecommendTagCell class]) bundle:nil] forCellReuseIdentifier:GWRecommendTagId];
}

// 加载tags数据
- (void)loadTags
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"tag_recommend";
    params[@"action"] = @"sub";
    params[@"c"] = @"topic";
    
    // 发送请求
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        self.tags = [GWRecommendTag objectArrayWithKeyValuesArray:responseObject];
        [self.tableView reloadData];
        
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载标签数据失败!"];
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tags.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GWRecommendTagCell *cell = [tableView dequeueReusableCellWithIdentifier:GWRecommendTagId];
    
    cell.recommendTag = self.tags[indexPath.row];
    
    return cell;
}
@end
