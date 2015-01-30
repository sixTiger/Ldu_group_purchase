//
//  XXBDealTool.m
//  Ldu_group_purchase
//
//  Created by Jinhong on 15-1-13.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import "XXBDealTool.h"
#import "XXBAPITool.h"

@implementation XXBDealTool
+ (void)findDeals:(XXBFindDealsParam *)param success:(void (^)(XXBFindDealsResult *))success failure:(void (^)(NSError *))failure
{
    [[XXBAPITool sharedAPITool] request:@"v1/deal/find_deals" params:param.keyValues success:^(id json) {
        if (success) {
            XXBFindDealsResult *obj = [XXBFindDealsResult objectWithKeyValues:json];
            success(obj);
        }
    } failure:failure];
}


+ (void)getSingleDeal:(XXBGetSingleDealParam *)param success:(void (^)(XXBGetSingleDealResult *result))success failure:(void (^)(NSError *error))failure
{
    [[XXBAPITool sharedAPITool] request:@"v1/deal/get_single_deal" params:param.keyValues success:^(id json) {
        if (success) {
            XXBGetSingleDealResult *obj = [XXBGetSingleDealResult objectWithKeyValues:json];
            success(obj);
        }
    } failure:failure];
}
@end
