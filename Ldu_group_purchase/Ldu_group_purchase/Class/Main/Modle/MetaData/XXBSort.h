//
//  XXBSort.h
//  Ldu_group_purchase
//
//  Created by Jinhong on 15-1-13.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import <Foundation/Foundation.h>

/* 1:默认，2:价格低优先，3:价格高优先，4:购买人数多优先，5:最新发布优先，6:即将结束优先，7:离经纬度坐标距离近优先 */
typedef enum {
    XXBSortValueDefault = 1, 	// 默认排序
    XXBSortValueLowPrice, 		// 价格最低
    XXBSortValueHighPrice,		// 价格最高
    XXBSortValuePopular, 		// 人气最高
    XXBSortValueLatest, 		// 最新发布
    XXBSortValueOver, 			// 即将结束
    XXBSortValueClosest 		// 离我最近
} XXBSortValue;
@interface XXBSort : NSObject
@property (assign, nonatomic) XXBSortValue 		value;
@property (copy, nonatomic) NSString 			*label;
@end
