//
//  XXBRegionsViewController.h
//  Ldu_group_purchase
//
//  Created by Jinhong on 15/1/14.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//  地区选择菜单

#import <UIKit/UIKit.h>
@class XXBRegion;

@interface XXBRegionsViewController : UIViewController
@property (nonatomic, strong) NSArray *regions;

/** 当前选中的区域 */
@property (strong, nonatomic) XXBRegion *selectedRegion;
/** 当前选中的子区域名称 */
@property (copy, nonatomic) NSString *selectedSubRegionName;
@end
