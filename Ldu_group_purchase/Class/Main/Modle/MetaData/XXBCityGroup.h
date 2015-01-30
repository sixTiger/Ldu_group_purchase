//
//  XXBCityGroup.h
//  Ldu_group_purchase
//
//  Created by Jinhong on 15-1-13.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXBCityGroup : NSObject
/** 组标题 */
@property (copy, nonatomic) NSString 	*title;
/** 这组显示的城市 */
@property (strong, nonatomic) NSArray 	*cities;
@end
