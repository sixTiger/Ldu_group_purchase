//
//  XXBCity.h
//  Ldu_group_purchase
//
//  Created by Jinhong on 15-1-13.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXBCity : NSObject

/** 城市名称 */
@property (copy, nonatomic) NSString 	*name;
/** 区域 */
@property (strong, nonatomic) NSArray 	*regions;
/** 拼音 beijing */
@property (copy, nonatomic) NSString 	*pinYin;
/** 拼音首字母 bj */
@property (copy, nonatomic) NSString 	*pinYinHead;
@end
