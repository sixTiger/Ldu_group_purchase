//
//  XXBMetaDataTool.m
//  Ldu_group_purchase
//
//  Created by Jinhong on 15-1-13.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import "XXBMetaDataTool.h"

#import "XXBCategory.h"
#import "XXBCity.h"
#import "XXBCityGroup.h"
#import "XXBSort.h"
#import "XXBRegion.h"


#define XXBSelectedCityNamesFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"selected_city_names.plist"]
#define XXBSelectedSortFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"selected_sort.data"]
#define XXBSelectedRegionFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"selected_region.data"]
#define XXBSelectedSubRegionNameFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"selected_subRegionName.data"]
#define XXBSelectedCategoryFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"selected_categoryFile.data"]

@interface XXBMetaDataTool()
{
    /** 所有的分类 */
    NSArray *_categories;
    /** 所有的城市 */
    NSArray *_cities;
    /** 所有的城市组 */
    NSArray *_cityGroups;
    /** 所有的排序 */
    NSArray *_sorts;
}
@property (nonatomic, strong) NSMutableArray *selectedCityNames;

@end

@implementation XXBMetaDataTool
XXBSingletonM(MetaDataTool)

- (NSMutableArray *)selectedCityNames
{
    if (!_selectedCityNames) {
        _selectedCityNames = [NSMutableArray arrayWithContentsOfFile:XXBSelectedCityNamesFile];
        
        if (!_selectedCityNames) {
            _selectedCityNames = [NSMutableArray array];
        }
    }
    return _selectedCityNames;
}

- (NSArray *)categories
{
    if (!_categories) {
        _categories = [XXBCategory objectArrayWithFilename:@"categories.plist"];
    }
    return _categories;
}

- (NSArray *)cityGroups
{
    NSMutableArray *cityGroups = [NSMutableArray array];
    
    // 添加最近访问
    if (self.selectedCityNames.count) {
        XXBCityGroup *recentCityGroup = [[XXBCityGroup alloc] init];
        recentCityGroup.title = @"最近";
        recentCityGroup.cities = self.selectedCityNames;
        [cityGroups addObject:recentCityGroup];
    }
    
    // 添加plist里面的城市组数据
    NSArray *plistCityGroups = [XXBCityGroup objectArrayWithFilename:@"cityGroups.plist"];
    [cityGroups addObjectsFromArray:plistCityGroups];
    return cityGroups;
}

- (NSArray *)cities
{
    if (!_cities) {
        _cities = [XXBCity objectArrayWithFilename:@"cities.plist"];
    }
    return _cities;
}

- (NSArray *)sorts
{
    if (!_sorts) {
        _sorts = [XXBSort objectArrayWithFilename:@"sorts.plist"];
    }
    return _sorts;
}


- (XXBCity *)cityWithName:(NSString *)name
{
    if (name.length == 0) return nil;
    
    for (XXBCity *city in self.cities) {
        if ([city.name isEqualToString:name]) return city;
    }
    return nil;
}

#pragma mark - 存储方法
- (void)saveSelectedCityName:(NSString *)name
{
    if (name.length == 0) return;
    
    // 存储城市名字
    [self.selectedCityNames removeObject:name];
    [self.selectedCityNames insertObject:name atIndex:0];
    
    // 写入plist
    [self.selectedCityNames writeToFile:XXBSelectedCityNamesFile atomically:YES];
}

- (void)saveSelectedSort:(XXBSort *)sort
{
    if (sort == nil) return;
    
    [NSKeyedArchiver archiveRootObject:sort toFile:XXBSelectedSortFile];
}
/**
 *  存储选中的区域
 */
- (void)saveSelectedRegion:(XXBRegion *)region
{
    if (region)
    {
        [NSKeyedArchiver archiveRootObject:region toFile:XXBSelectedRegionFile];
    }
}
- (void)saveSelectedSubRegionName:(NSString *)regionName
{
    if (regionName.length == 0) return;
    // 写入plist
    [regionName writeToFile:XXBSelectedSubRegionNameFile atomically:YES encoding:NSUTF32StringEncoding error:nil];
}

- (void)saveSelectedCategory:(XXBCategory *)category
{
    if (category)
    {
        [NSKeyedArchiver archiveRootObject:category toFile:XXBSelectedCategoryFile];
    }
}
- (void)saveSelectedSubCategoryName:(NSString *)subCategoryName
{
    if (subCategoryName.length)
    [[NSUserDefaults standardUserDefaults] setObject:subCategoryName forKey:@"subCategoryName"];
}
- (XXBCity *)selectedCity
{
    NSString *cityName = [self.selectedCityNames firstObject];
    XXBCity *city = [self cityWithName:cityName];
    if (city == nil) {
        city = [self cityWithName:@"北京"];
    }
    return city;
}

- (XXBRegion *)selectedRegion
{
    XXBRegion *region = [NSKeyedUnarchiver unarchiveObjectWithFile:XXBSelectedRegionFile];
    if (region == nil) {
        region = [[self  selectedCity].regions firstObject];
    }
    return region;
}
- (XXBSort *)selectedSort
{
    XXBSort *sort = [NSKeyedUnarchiver unarchiveObjectWithFile:XXBSelectedSortFile];
    if (sort == nil) {
        sort = [self.sorts firstObject];
    }
    return sort;
}
- (NSString *)selectedSubRegionName
{
    NSString *regionName = [NSString stringWithContentsOfFile:XXBSelectedSubRegionNameFile encoding:NSUTF32StringEncoding error:nil];
    if (regionName == nil) {
        regionName = @"全部";
    }
    return regionName;
}
- (XXBCategory *)selectedCategory
{
    XXBCategory *category = [NSKeyedUnarchiver unarchiveObjectWithFile:XXBSelectedCategoryFile];
    if (category == nil) {
        category = [self.categories firstObject];
    }
    return category;
}
- (NSString *)SelectedSubCategoryName
{
    NSString *subCategoryName = [[NSUserDefaults standardUserDefaults] stringForKey:@"subCategoryName"];
    if (!subCategoryName.length)
        subCategoryName = @"";
    return subCategoryName;
}
/**
 *  根据城市的名字获取城市的详细信息
 */
- (XXBCategory *)categoryWithName:(NSString *)name
{
    for (XXBCategory *category in self.categories) {
        if ([category.name isEqualToString:name]) return category;
        
        // 遍历子类别
        for (NSString *subcategory in category.subcategories) {
            if ([subcategory isEqualToString:name]) return category;
        }
    }
    return nil;
}

@end
