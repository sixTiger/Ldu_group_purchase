//
//  XXBDealTool.h
//  Ldu_group_purchase
//
//  Created by Jinhong on 15-1-13.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXBFindDealsParam.h"
#import "XXBFindDealsResult.h"
#import "XXBGetSingleDealParam.h"
#import "XXBGetSingleDealResult.h"

@interface XXBDealTool : NSObject


/**
 *  搜索团购
 *
 *  @param param   请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)findDeals:(XXBFindDealsParam *)param success:(void (^)(XXBFindDealsResult *result))success failure:(void (^)(NSError *error))failure;


/**
 *  获得指定团购（获得单个团购信息）
 */
+ (void)getSingleDeal:(XXBGetSingleDealParam *)param success:(void (^)(XXBGetSingleDealResult *result))success failure:(void (^)(NSError *error))failure;
@end
