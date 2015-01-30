//
//  XXBHMFindDealsResult.h
//  Ldu_group_purchase
//
//  Created by Jinhong on 15-1-13.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXBGetSingleDealResult.h"

@interface XXBFindDealsResult : XXBGetSingleDealResult
/** 所有页面团购总数 */
@property (assign, nonatomic) int total_count;
@end
