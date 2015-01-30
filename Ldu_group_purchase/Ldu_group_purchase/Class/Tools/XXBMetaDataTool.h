//
//  XXBMetaDataTool.h
//  Ldu_group_purchase
//
//  Created by Jinhong on 15-1-13.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXBSingleton.h"
@class XXBCity, XXBSort, XXBCategory ,XXBRegion;

@interface XXBMetaDataTool : NSObject

XXBSingletonH(MetaDataTool)
/**
 *  所有的分类
 */
@property (strong, nonatomic, readonly) NSArray *categories;
/**
 *  所有的城市
 */
@property (strong, nonatomic, readonly) NSArray *cities;
/**
 *  所有的城市组
 */
@property (strong, nonatomic, readonly) NSArray *cityGroups;
/**
 *  所有的排序
 */
@property (strong, nonatomic, readonly) NSArray *sorts;

/**
 *  通过分类名称（子分类名称）获得对应的分类模型
 */
- (XXBCategory * )categoryWithName:(NSString *)name;

- (XXBCity *)cityWithName:(NSString *)name;

/**
 *  存储选中的城市名称
 */
- (void)saveSelectedCityName:(NSString *)name;
/**
 *  存储选中的排序
 */
- (void)saveSelectedSort:(XXBSort *)sort;

/**
 *  存储选中的区域
 */
- (void)saveSelectedRegion:(XXBRegion *)name;
/**
 *  存储选中的子区域名字
 */
- (void)saveSelectedSubRegionName:(NSString *)name;
/**
 *  存储选中的分类
 */
- (void)saveSelectedCategory:(XXBCategory *)category;
/**
 *  存储选中的子分类名字
 */
- (void)saveSelectedSubCategoryName:(NSString *)name;

/**
 *  获取选中的城市
 *
 *  @return 选中的城市的数据
 */
- (XXBCity *)selectedCity;
/**
 *  获取朱选中的排序
 *
 *  @return 选中的排序
 */
- (XXBSort *)selectedSort;
/**
 *  获取选中的 地区
 *
 *  @return 选中的地区
 */
- (XXBRegion *)selectedRegion;
/**
 *  获取选中的分类的子地区的名字
 *
 *  @return 子地区的名字
 */
- (NSString *)selectedSubRegionName;
/**
 *  获取选中的分类
 *
 *  @return 选中的分类
 */
- (XXBCategory *)selectedCategory;
/**
 *  获取选中的子分类的名字
 *
 *  @return 选中的子分类的名字
 */
- (NSString *)SelectedSubCategoryName;
@end
