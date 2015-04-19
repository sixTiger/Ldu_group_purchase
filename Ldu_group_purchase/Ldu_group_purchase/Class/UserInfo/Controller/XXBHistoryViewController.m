//
//  XXBHistoryViewController.m
//  Ldu_group_purchase
//
//  Created by Jinhong on 15/1/15.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import "XXBHistoryViewController.h"
#import "XXBDealLocalTool.h"
#import "XXBDeal.h"

@interface XXBHistoryViewController ()

@end

@implementation XXBHistoryViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"浏览记录";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 刷新数据（保持顺序）
    [self.deals removeAllObjects];
    NSArray *historyDeals = [XXBDealLocalTool sharedDealLocalTool].historyDeals;
    [self.deals addObjectsFromArray:historyDeals];
    [self.collectionView reloadData];
}
/**
 *  删除
 */
- (void)delete
{
    [[XXBDealLocalTool sharedDealLocalTool] unsaveHistoryDeals:self.willDeletedDeals];
}

#pragma mark - 实现父类方法
- (NSString *)emptyIcon
{
    return @"icon_latestBrowse_empty";
}



@end
