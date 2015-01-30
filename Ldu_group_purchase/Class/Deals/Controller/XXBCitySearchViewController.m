//
//  XXBCitySearchViewController.m
//  Ldu_group_purchase
//
//  Created by Jinhong on 15/1/14.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import "XXBCitySearchViewController.h"
#import "XXBCity.h"

@interface XXBCitySearchViewController ()

@property (nonatomic, strong) NSArray *resultCities;
@end

@implementation XXBCitySearchViewController

- (void)setSearchText:(NSString *)searchText
{
    _searchText = [searchText copy];
    
    // 根据搜索条件进行过滤
    NSArray *allCities = [XXBMetaDataTool sharedMetaDataTool].cities;
    
    // 将搜索条件转为小写
    NSString *lowerSearchText = searchText.lowercaseString;
    //    NSMutableArray *cities = [NSMutableArray array];
    //    for (HMCity *city in allCities) {
    //        BOOL d1 = [city.name.lowercaseString rangeOfString:lowerSearchText].length != 0;
    //        BOOL d2 = [city.pinYin.lowercaseString rangeOfString:lowerSearchText].length != 0;
    //        BOOL d3 = [city.pinYinHead.lowercaseString rangeOfString:lowerSearchText].length != 0;
    //        if (d1 || d2 || d3) {
    //            [cities addObject:city];
    //        }
    //    }
    //    self.resultCities = cities;
    
    //    NSPredicate * 预言\过滤器\谓词
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name.lowercaseString contains %@ or pinYin.lowercaseString contains %@ or pinYinHead.lowercaseString contains %@", lowerSearchText, lowerSearchText, lowerSearchText];
    self.resultCities = [allCities filteredArrayUsingPredicate:predicate];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultCities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"city";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    XXBCity *city = self.resultCities[indexPath.row];
    cell.textLabel.text = city.name;
    
    return cell;
}

#pragma mark - 代理方法
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"共有%d个搜索结果", self.resultCities.count];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.关闭控制器
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // 2.发出通知
    XXBCity *city = self.resultCities[indexPath.row];
    [XXBNotificationCenter postNotificationName:XXBCityDidSelectNotification object:nil userInfo:@{XXBSelectedCity : city}];
}
@end
