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
}

#pragma mark - <UITableViewDataSource, UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.categoryTableView) {
        return self.categorys.count;
    } else {
        NSIndexPath *path = [self.categoryTableView indexPathForSelectedRow];
        GWRecommendCategory *category = self.categorys[path.row];
        
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
        
        NSIndexPath *path = [self.categoryTableView indexPathForSelectedRow];
        GWRecommendCategory *category = self.categorys[path.row];
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
        // 发送请求给服务器, 加载右侧的数据
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"a"] = @"list";
        params[@"c"] = @"subscribe";
        params[@"category_id"] = @(category.id);
        
        [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
            
            // 数据处理
            NSArray *users = [GWRecommendUser objectArrayWithKeyValuesArray:responseObject[@"list"]];
            
            [category.users addObjectsFromArray:users];
            
            // 刷新右边的表格
            [self.userTableView reloadData];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            GWLog(@"%@", error);
        }];
    }
}
@end
