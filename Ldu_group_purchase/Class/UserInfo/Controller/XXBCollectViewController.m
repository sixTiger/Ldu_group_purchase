//
//  XXBCollectViewController.m
//  Ldu_group_purchase
//
//  Created by Jinhong on 15/1/15.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import "XXBCollectViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "XXBDealLocalTool.h"
#import "XXBDeal.h"

@interface XXBCollectViewController ()

@end

@implementation XXBCollectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"我的收藏";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 刷新数据（保持顺序）
    [self.deals removeAllObjects];
    NSArray *collectDeals = [XXBDealLocalTool sharedDealLocalTool].collectDeals;
    [self.deals addObjectsFromArray:collectDeals];
    [self.collectionView reloadData];
}

#pragma mark - 实现父类方法
- (NSString *)emptyIcon
{
    return @"icon_collects_empty";
}

/**
 *  删除
 */
- (void)delete
{
    [[XXBDealLocalTool sharedDealLocalTool] unsaveCollectDeals:self.willDeletedDeals];
}

@end
