//
//  XXBDealLocalTool.h
//  Ldu_group_purchase
//
//  Created by Jinhong on 15/1/15.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXBSingleton.h"
@class XXBDeal;

@interface XXBDealLocalTool : NSObject
XXBSingletonH(DealLocalTool)


/**
 *  返回最近浏览的团购
 */
@property (nonatomic, strong, readonly) NSMutableArray *historyDeals;

/**
 *  保存最近浏览的团购
 */
- (void)saveHistoryDeal:(XXBDeal *)deal;
- (void)unsaveHistoryDeal:(XXBDeal *)deal;
- (void)unsaveHistoryDeals:(NSArray *)deals;

/**
 *  返回收藏的团购
 */
@property (nonatomic, strong, readonly) NSMutableArray *collectDeals;

/**
 *  保存收藏的团购
 */
- (void)saveCollectDeal:(XXBDeal *)deal;
/**
 *  取消收藏的团购
 */
- (void)unsaveCollectDeal:(XXBDeal *)deal;
/**
 *  取消收藏团购
 *
 *  @param deals 要取消的收藏的数组
 */
- (void)unsaveCollectDeals:(NSArray *)deals;
@end
