//
//  XXBDealLocalTool.m
//  Ldu_group_purchase
//
//  Created by Jinhong on 15/1/15.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//  处理团购的本地数据（浏览记录和收藏记录）

#import "XXBDealLocalTool.h"
#import "XXBDeal.h"
#define XXBHistoryDealsFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"history_deals.data"]

#define XXBCollectDealsFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"collect_deals.data"]

@interface XXBDealLocalTool()
{
    NSMutableArray *_historyDeals;
    NSMutableArray *_collectDeals;
}
@end
@implementation XXBDealLocalTool
XXBSingletonM(DealLocalTool)
- (NSMutableArray *)historyDeals
{
    if (!_historyDeals) {
        _historyDeals = [NSKeyedUnarchiver unarchiveObjectWithFile:XXBHistoryDealsFile];
        
        if (!_historyDeals) {
            _historyDeals = [NSMutableArray array];
        }
    }
    return _historyDeals;
}

- (NSMutableArray *)collectDeals
{
    if (!_collectDeals) {
        _collectDeals = [NSKeyedUnarchiver unarchiveObjectWithFile:XXBCollectDealsFile];
        
        if (!_collectDeals) {
            _collectDeals = [NSMutableArray array];
        }
    }
    return _collectDeals;
}

- (void)saveHistoryDeal:(XXBDeal *)deal
{
    [self.historyDeals removeObject:deal];
    [self.historyDeals insertObject:deal atIndex:0];
    
    // 存进沙盒
    [NSKeyedArchiver archiveRootObject:self.historyDeals toFile:XXBHistoryDealsFile];
}

- (void)unsaveHistoryDeal:(XXBDeal *)deal
{
    [self.historyDeals removeObject:deal];
    
    // 存进沙盒
    [NSKeyedArchiver archiveRootObject:self.historyDeals toFile:XXBHistoryDealsFile];
}

- (void)unsaveHistoryDeals:(NSArray *)deals
{
    [self.historyDeals removeObjectsInArray:deals];
    
    // 存进沙盒
    [NSKeyedArchiver archiveRootObject:self.historyDeals toFile:XXBHistoryDealsFile];
}

- (void)saveCollectDeal:(XXBDeal *)deal
{
    [self.collectDeals removeObject:deal];
    [self.collectDeals insertObject:deal atIndex:0];
    
    // 存进沙盒
    [NSKeyedArchiver archiveRootObject:self.collectDeals toFile:XXBCollectDealsFile];
}

- (void)unsaveCollectDeal:(XXBDeal *)deal
{
    [self.collectDeals removeObject:deal];
    
    // 存进沙盒
    [NSKeyedArchiver archiveRootObject:self.collectDeals toFile:XXBCollectDealsFile];
}


- (void)unsaveCollectDeals:(NSArray *)deals
{
    [self.collectDeals removeObjectsInArray:deals];
    
    // 存进沙盒
    [NSKeyedArchiver archiveRootObject:self.collectDeals toFile:XXBCollectDealsFile];
}
@end
