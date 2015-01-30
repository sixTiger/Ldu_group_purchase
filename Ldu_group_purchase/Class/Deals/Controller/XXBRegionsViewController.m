//
//  XXBRegionsViewController.m
//  Ldu_group_purchase
//
//  Created by Jinhong on 15/1/14.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import "XXBRegionsViewController.h"
#import "XXBDropdownMenu.h"
#import "XXBCity.h"
#import "XXBCitiesViewController.h"
#import "XXBRegion.h"

@interface XXBRegionsViewController ()<XXBDropdownMenuDelegate>
@property (nonatomic, weak) XXBDropdownMenu *menu;

- (IBAction)changeCity;

@end

@implementation XXBRegionsViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.preferredContentSize = CGSizeMake(400, 480);
}
- (IBAction)changeCity {
#warning ios8会有问题的
    // 1.调用block
//    if (self.changeCityBlock) {
//        self.changeCityBlock();
//    }
    UIPopoverController *popover = [self valueForKeyPath:@"popoverController"];
    [popover dismissPopoverAnimated:YES];
    // 2.弹出城市列表
    XXBCitiesViewController *citiesVc = [[XXBCitiesViewController alloc] init];
    citiesVc.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:citiesVc animated:YES completion:nil];

    
}

#pragma mark - XXBDropdownMenuDelegate
- (void)dropdownMenu:(XXBDropdownMenu *)dropdownMenu didSelectMain:(int)mainRow
{
    XXBRegion *r = dropdownMenu.items[mainRow];
    if (r.subregions.count == 0) {
        // 发出通知，选中了某个区域
        [XXBNotificationCenter postNotificationName:XXBRegionDidSelectNotification object:nil userInfo:@{XXBSelectedRegion : r}];
    }
    else
    { // 右边有子类别
        if (self.selectedRegion == r)
        {
            // 选中右边的子类别
            self.selectedSubRegionName = self.selectedSubRegionName;
        }
    }

}

- (void)dropdownMenu:(XXBDropdownMenu *)dropdownMenu didSelectSub:(int)subRow ofMain:(int)mainRow
{
    // 发出通知，选中了某个分类
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    XXBRegion *r = dropdownMenu.items[mainRow];
    userInfo[XXBSelectedRegion] = r;
    userInfo[XXBSelectedSubRegionName] = r.subregions[subRow];
    [XXBNotificationCenter postNotificationName:XXBRegionDidSelectNotification object:nil userInfo:userInfo];
}

#pragma mark - 公共方法
- (void)setRegions:(NSArray *)regions
{
    _regions = regions;
    
    self.menu.items = regions;
}

- (void)setSelectedRegion:(XXBRegion *)selectedRegion
{
    _selectedRegion = selectedRegion;
    
    int mainRow = [self.menu.items indexOfObject:selectedRegion];
    [self.menu selectMain:mainRow];
}

- (void)setSelectedSubRegionName:(NSString *)selectedSubRegionName
{
    _selectedSubRegionName = [selectedSubRegionName copy];
    
    int subRow = [self.selectedRegion.subregions indexOfObject:selectedSubRegionName];
    [self.menu selectSub:subRow];
}
#pragma mark - 懒加载
- (XXBDropdownMenu *)menu
{
    if (_menu == nil) {
        // 顶部的view
        UIView *topView = [self.view.subviews firstObject];
        
        // 创建菜单
        XXBDropdownMenu *menu = [XXBDropdownMenu menu];
//        menu.delegate = self;
        [self.view addSubview:menu];
        // menu的ALEdgeTop == topView的ALEdgeBottom
        [menu autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:topView];
        // 除开顶部，其他方向距离父控件的间距都为0
        [menu autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        
        menu.delegate = self;
        self.menu = menu;
    }
    return _menu;
}

@end
