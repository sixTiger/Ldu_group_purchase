//
//  XXBDropdownMenu.m
//  Ldu_group_purchase
//
//  Created by Jinhong on 15/1/14.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import "XXBDropdownMenu.h"
#import "XXBDropdownMainCell.h"
#import "XXBDropdownSubCell.h"

@interface XXBDropdownMenu ()

/** 主表 */
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
/** 从表 */
@property (weak, nonatomic) IBOutlet UITableView *subTableView;

@end

@implementation XXBDropdownMenu

+ (instancetype)menu
{
    return [[[NSBundle mainBundle] loadNibNamed:@"XXBDropdownMenu" owner:nil options:nil] lastObject];
}
/**
 *  一个UI控件即将被添加到窗口中就调用
 */
- (void)willMoveToWindow:(UIWindow *)newWindow
{
//    self.mainTableView.backgroundColor = [UIColor redColor];
//    self.subTableView.backgroundColor = [UIColor blueColor];
}


#pragma mark - 公共方法
- (void)selectMain:(NSInteger)mainRow
{
    [self.mainTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:mainRow inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self.subTableView reloadData];
}

- (void)selectSub:(NSInteger)subRow
{
    [self.subTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:subRow inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)setItems:(NSArray *)items
{
    _items = items;
    
    // 刷新表格
    [self.mainTableView reloadData];
    [self.subTableView reloadData];
}
#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.mainTableView) {
        return self.items.count;
    } else {
        // 得到mainTableView选中的行
        NSInteger mainRow = [self.mainTableView indexPathForSelectedRow].row;
        if (mainRow < 0) {
            return 0;
        }
        else
        {
            id<XXBDropdownMenuItem> item = self.items[mainRow];
            return [item subtitles].count;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.mainTableView)
    { // 左边主表的cell
        XXBDropdownMainCell *mainCell = [XXBDropdownMainCell cellWithTableView:tableView];
        mainCell.item = self.items[indexPath.row];
        return mainCell;
    }
    else
    { // 右边从表的cell
        XXBDropdownSubCell *subCell = [XXBDropdownSubCell cellWithTableView:tableView];
        
        // 得到mainTableView选中的行
        NSInteger mainRow = [self.mainTableView indexPathForSelectedRow].row;
        id<XXBDropdownMenuItem> item = self.items[mainRow];
        subCell.textLabel.text = [item subtitles][indexPath.row];
        return subCell;
    }
}

#pragma mark - 代理方法
#pragma mark - 代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.mainTableView)
    {
        // 刷新右边
        [self.subTableView reloadData];
        // 通知代理
        if ([self.delegate respondsToSelector:@selector(dropdownMenu:didSelectMain:)])
        {
            [self.delegate dropdownMenu:self didSelectMain:indexPath.row];
        }
        
    }
    else
    {
        int mainRow = [self.mainTableView indexPathForSelectedRow].row;
        [self.delegate dropdownMenu:self didSelectSub:indexPath.row ofMain:mainRow];
    }
}
@end
