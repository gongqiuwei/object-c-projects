//
//  GWCommentViewController.m
//  仿百思不得姐
//
//  Created by gongqiuwei on 16/4/26.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//

#import "GWCommentViewController.h"
#import "UIBarButtonItem+GWExtension.h"
#import "GWTopicCell.h"
#import "GWTopic.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "GWComment.h"
#import "MJExtension.h"
#import "GWCommentCell.h"
#import "SVProgressHUD.h"

static NSString *const GWCommentCellId = @"comment";

@interface GWCommentViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 工具条底部间距 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolbarBottomSpace;

/** 最热评论 */
@property (nonatomic, strong) NSArray *hotComments;
/** 最新评论 */
@property (nonatomic, strong) NSMutableArray *latestComments;

/** 保存帖子的top_cmt */
@property (nonatomic, strong) NSArray *saved_top_cmt;

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableDictionary *params;
/** 管理者 */
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@end

@implementation GWCommentViewController

- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self initHeader];
}

- (void)initHeader
{
    // 头部
    UIView *header = [[UIView alloc] init];
    
    // 清空top_cmt
    if (self.topic.top_cmt.count) {
        self.saved_top_cmt = self.topic.top_cmt;
        self.topic.top_cmt = nil;
        [self.topic setValue:@0 forKeyPath:@"cellHeight"];
    }
    
    // cell的设定，当做普通的view使用
    GWTopicCell *cell = [GWTopicCell cell];
    cell.topic = self.topic;
    cell.frame = CGRectMake(0, 0, GWScreenW, self.topic.cellHeight);
    [header addSubview:cell];
    
    // view的设定
    header.height = self.topic.cellHeight + GWTopicCellMargin;
    
    self.tableView.tableHeaderView = header;
}

- (void)initUI
{
    self.title = @"评论";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"comment_nav_item_share_icon" selectImage:@"comment_nav_item_share_icon_click" target:nil action:nil];
    
    self.tableView.backgroundColor = GWGlobalBgColor;
    // 去掉分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 内边距
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, GWTopicCellMargin, 0);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    // tableview的初始化
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GWCommentCell class]) bundle:nil] forCellReuseIdentifier:GWCommentCellId];
    
    // iOS8之后才能够使用sizeclass来计算
    // 预估的cell的高度
    self.tableView.estimatedRowHeight = 44;
    // 自动计算cell的高度
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // 刷新控件
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewComments)];
    [self.tableView.header beginRefreshing];
    
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreComments)];
}

- (void)loadNewComments
{
    // 结束刷新
    if ([self.tableView.footer isRefreshing]) {
        [self.tableView.footer endRefreshing];
    }
    
    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.ID;
    params[@"hot"] = @"1";
    self.params = params;
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if (self.params != params) return;
        
        // 最热评论
        self.hotComments = [GWComment objectArrayWithKeyValuesArray:responseObject[@"hot"]];
        
        // 最新评论
        self.latestComments = [GWComment objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
        
        // 控制footer的状态
        NSInteger total = [responseObject[@"total"] integerValue];
        if (self.latestComments.count >= total) { // 全部加载完毕
            [self.tableView.footer noticeNoMoreData];
        }
        
        // 页码控制
        self.page = 1;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (self.params != params) return;
        
        [SVProgressHUD showErrorWithStatus:@"加载失败！！"];
        
        [self.tableView.header endRefreshing];
    }];
}

- (void)loadMoreComments
{
    if ([self.tableView.header isRefreshing]) {
        [self.tableView.header endRefreshing];
    }
    
    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.ID;
    params[@"page"] = @(self.page + 1);
    GWComment *cmt = [self.latestComments lastObject];
    params[@"lastcid"] = cmt.ID;
    self.params = params;
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.params != params) return;
        
        // 最新评论
        NSArray *newComments = [GWComment objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.latestComments addObjectsFromArray:newComments];
        
        // 刷新页面
        [self.tableView reloadData];
        
        // 控制footer的状态
        NSInteger total = [responseObject[@"total"] integerValue];
        if (self.latestComments.count >= total) { // 全部加载完毕
            [self.tableView.footer noticeNoMoreData];
//            self.tableView.footer.hidden = YES;
        } else {
            // 结束刷新状态
            [self.tableView.footer endRefreshing];
        }
        
        // 页码控制
        self.page ++;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.params != params) return;
        
        [SVProgressHUD showErrorWithStatus:@"加载失败！！"];
        
        [self.tableView.footer endRefreshing];
    }];
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger hotCount = self.hotComments.count;
    NSInteger latestCount = self.latestComments.count;
    
    if (hotCount) return 2; // 有"最热评论" + "最新评论" 2组
    if (latestCount) return 1; // 有"最新评论" 1 组
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger hotCount = self.hotComments.count;
    NSInteger latestCount = self.latestComments.count;
    
    // 隐藏尾部控件
    self.tableView.footer.hidden = (latestCount == 0);
    
    if (section == 0) {
        return hotCount ? hotCount : latestCount;
    }
    
    // 非第0组
    return latestCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GWCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:GWCommentCellId];
    
    cell.comment = [self commentInIndexPath:indexPath];
    
    return cell;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    NSInteger hotCount = self.hotComments.count;
//    if (section == 0) {
//        return hotCount ? @"最热评论" : @"最新评论";
//    }
//    return @"最新评论";
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = GWGlobalBgColor;
    
    // 内容
    UILabel *label = [[UILabel alloc] init];
    [header addSubview:label];
    label.width = 200;
    label.textColor = GWRGBColor(67, 67, 67);
    label.x = GWTopicCellMargin;
    label.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    NSInteger hotCount = self.hotComments.count;
    if (section == 0) {
        label.text = hotCount ? @"最热评论" : @"最新评论";
    } else {
       label.text = @"最新评论";
    }
    
    return header;
}

/**
 * 返回第section组的所有评论数组
 */
- (NSArray *)commentsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.hotComments.count ? self.hotComments : self.latestComments;
    }
    return self.latestComments;
}

- (GWComment *)commentInIndexPath:(NSIndexPath *)indexPath
{
    return [self commentsInSection:indexPath.section][indexPath.row];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIMenuController *menuVC = [UIMenuController sharedMenuController];
    
    if (menuVC.isMenuVisible) {
        [menuVC setMenuVisible:NO animated:YES];
    } else {
        // 添加自动义的操作
        UIMenuItem *ding = [[UIMenuItem alloc] initWithTitle:@"顶" action:@selector(ding:)];
        UIMenuItem *replay = [[UIMenuItem alloc] initWithTitle:@"回复" action:@selector(replay:)];
        UIMenuItem *report = [[UIMenuItem alloc] initWithTitle:@"举报" action:@selector(report:)];
        menuVC.menuItems = @[ding, replay, report];
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        // cell成为第一响应者，menuVC才会在它身上显示（需要实现一些方法）
        [cell becomeFirstResponder];
        CGRect rect = CGRectMake(0, cell.height * 0.5, cell.width, cell.height * 0.5);
        [menuVC setTargetRect:rect inView:cell];
        [menuVC setMenuVisible:YES animated:YES];
    }
}

#pragma mark - MenuItem处理
- (void)ding:(UIMenuController *)menu
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSLog(@"%s %@", __func__, [self commentInIndexPath:indexPath].content);
}

- (void)replay:(UIMenuController *)menu
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSLog(@"%s %@", __func__, [self commentInIndexPath:indexPath].content);
}

- (void)report:(UIMenuController *)menu
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSLog(@"%s %@", __func__, [self commentInIndexPath:indexPath].content);
}

#pragma mark - 键盘
- (void)keyBoardFrameChange:(NSNotification *)note
{
    // 键盘显示\隐藏完毕的frame
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 修改底部约束
    self.toolbarBottomSpace.constant = GWScreenH - frame.origin.y;
    // 动画时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 动画
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 恢复帖子的top_cmt
    if (self.saved_top_cmt.count) {
        self.topic.top_cmt = self.saved_top_cmt;
        [self.topic setValue:@0 forKeyPath:@"cellHeight"];
    }
    
    // 取消网络请求的回调操作
//    [self.manager.operationQueue cancelAllOperations];
    
    // 取消网络请求任务
//    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 取消网络请求任务的session
    [self.manager invalidateSessionCancelingTasks:YES];
}
@end
