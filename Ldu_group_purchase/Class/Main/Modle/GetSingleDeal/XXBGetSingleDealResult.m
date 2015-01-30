//
//  XXBGetSingleDealResult.m
//  Ldu_group_purchase
//
//  Created by Jinhong on 15-1-13.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import "XXBGetSingleDealResult.h"
#import "XXBDeal.h"

@implementation XXBGetSingleDealResult
- (NSDictionary *)objectClassInArray
{
    return @{@"deals" : [XXBDeal class]};
}
@end
