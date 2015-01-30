//
//  XXBDealLocalListViewController.m
//  Ldu_group_purchase
//
//  Created by Jinhong on 15/1/15.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import "XXBDealLocalListViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "XXBDeal.h"
#import "XXBDealCell.h"

#define XXBEditText @"编辑"
#define XXBDoneText @"完成"

@interface XXBDealLocalListViewController ()
/**
 *  全选
 */
@property (nonatomic, strong) UIBarButtonItem *selectAllItem;
/**
 *  取消全选
 */
@property (nonatomic, strong) UIBarButtonItem *unselectAllItem;
/**
 *  删除
 */
@property (nonatomic, strong) UIBarButtonItem *deleteItem;
/**
 *  返回
 */
@property (nonatomic, strong) UIBarButtonItem *backItem;

@end

@implementation XXBDealLocalListViewController
#pragma mark - 初始化
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置左上角的返回按钮
    self.navigationItem.leftBarButtonItems = @[self.backItem];
    
    // 设置右上角的编辑按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:XXBEditText style:UIBarButtonItemStylePlain target:self action:@selector(edit)];
}


#pragma mark - 懒加载
- (UIBarButtonItem *)backItem
{
    if (_backItem == nil) {
        self.backItem = [UIBarButtonItem itemWithImageName:@"icon_back" highImageName:@"icon_back_highlighted" target:self action:@selector(back)];
    }
    return _backItem;
}

- (UIBarButtonItem *)selectAllItem
{
    if (_selectAllItem == nil) {
        self.selectAllItem = [[UIBarButtonItem alloc] initWithTitle:@"   全选   " style:UIBarButtonItemStylePlain target:self action:@selector(selectAll)];
    }
    return _selectAllItem;
}

- (UIBarButtonItem *)unselectAllItem
{
    if (_unselectAllItem == nil) {
        self.unselectAllItem = [[UIBarButtonItem alloc] initWithTitle:@"   全不选   " style:UIBarButtonItemStylePlain target:self action:@selector(unselectAll)];
    }
    return _unselectAllItem;
}

- (UIBarButtonItem *)deleteItem
{
    if (_deleteItem == nil) {
        self.deleteItem = [[UIBarButtonItem alloc] initWithTitle:@"   删除   " style:UIBarButtonItemStylePlain target:self action:@selector(delete)];
        self.deleteItem.enabled = NO;
    }
    return _deleteItem;
}

#pragma mark -  事件处理

/**
 *  返回
 */
- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  编辑
 */
- (void)edit
{
    NSString *title = self.navigationItem.rightBarButtonItem.title;
    if ([title isEqualToString:XXBEditText]) {
        self.navigationItem.rightBarButtonItem.title = XXBDoneText;
        
        // 进入编辑状态
        for (XXBDeal *deal in self.deals) {
            deal.editing = YES;
        }
        [self.collectionView reloadData];
        
        // 左边显示4个item
        self.navigationItem.leftBarButtonItems = @[self.backItem, self.selectAllItem, self.unselectAllItem, self.deleteItem];
    } else {
        self.navigationItem.rightBarButtonItem.title = XXBEditText;
        
        // 结束编辑状态
        for (XXBDeal *deal in self.deals) {
            deal.editing = NO;
            deal.checking = NO;
        }
        [self.collectionView reloadData];
        
        // 控制删除item的状态和文字
        [self dealCellDidClickCover:nil];
        
        // 左边显示1个item
        self.navigationItem.leftBarButtonItems = @[self.backItem];
    }
}

/**
 *  全选
 */
- (void)selectAll
{
    for (XXBDeal *deal in self.deals) {
        deal.checking = YES;
    }
    [self.collectionView reloadData];
    
    // 控制删除item的状态和文字
    [self dealCellDidClickCover:nil];
}

/**
 *  删除
 */
- (void)delete
{
    
}

/**
 *  全不选
 */
- (void)unselectAll
{
    for (XXBDeal *deal in self.deals) {
        deal.checking = NO;
    }
    [self.collectionView reloadData];
    
    // 控制删除item的状态和文字
    [self dealCellDidClickCover:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    // 清空状态
    for (XXBDeal *deal in self.deals) {
        deal.editing = NO;
        deal.checking = NO;
    }
}
#pragma mark - XXBDealCellDelegate
- (void)dealCellDidClickCover:(XXBDealCell *)dealCell
{
    BOOL deleteEable = NO;
    int checkingCount = 0;
    // 1.删除item的状态
    for (XXBDeal *deal in self.deals) {
        if (deal.isChecking) {
            deleteEable = YES;
            checkingCount++;
        }
    }
    self.deleteItem.enabled = deleteEable;
    
    // 2.删除item的文字
    if (checkingCount)
    {
        self.deleteItem.title = [NSString stringWithFormat:@"   删除(%d)   ", checkingCount];
    }
    else
    {
        self.deleteItem.title = @"   删除   ";
    }
}

/**
 *  返回即将删除的团购
 */
- (NSArray *)willDeletedDeals
{
    NSMutableArray *checkingDeals = [NSMutableArray array];
    // 取出被打钩的团购
    for (XXBDeal *deal in self.deals) {
        if (deal.isChecking) {
            [checkingDeals addObject:deal];
            deal.checking = NO;
            deal.editing = NO;
        }
    }
    [self.deals removeObjectsInArray:checkingDeals];
    
    [self.collectionView reloadData];
    
    // 控制删除item的状态和文字
    [self dealCellDidClickCover:nil];
    
    return checkingDeals;
}
@end
