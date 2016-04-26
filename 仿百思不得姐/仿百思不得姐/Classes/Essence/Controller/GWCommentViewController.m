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

@interface GWCommentViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 工具条底部间距 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolbarBottomSpace;

@end

@implementation GWCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

- (void)initUI
{
    self.title = @"评论";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"comment_nav_item_share_icon" selectImage:@"comment_nav_item_share_icon_click" target:nil action:nil];
    
    self.tableView.backgroundColor = GWGlobalBgColor;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    // 头部
    UIView *header = [[UIView alloc] init];
    
    // cell的设定，当做普通的view使用
    GWTopicCell *cell = [GWTopicCell cell];
    cell.topic = self.topic;
    cell.frame = CGRectMake(0, 0, GWScreenW, self.topic.cellHeight);
    [header addSubview:cell];
    
    // view的设定
    header.height = self.topic.cellHeight + GWTopicCellMargin;
    
    self.tableView.tableHeaderView = header;
}

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
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"comment";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
@end
