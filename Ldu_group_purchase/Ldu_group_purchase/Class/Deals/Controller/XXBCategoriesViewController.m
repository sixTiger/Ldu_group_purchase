//
//  XXBCategoriesViewController.m
//  Ldu_group_purchase
//
//  Created by Jinhong on 15/1/14.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import "XXBCategoriesViewController.h"
#import "XXBDropdownMenu.h"

#import "XXBCategory.h"

@interface XXBCategoriesViewController ()<XXBDropdownMenuDelegate>

@property (nonatomic, weak) XXBDropdownMenu *menu;

@end

@implementation XXBCategoriesViewController

- (void)loadView
{
    self.view = self.menu ;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.preferredContentSize = CGSizeMake(350, 480);
}
- (XXBDropdownMenu *)menu
{
    if (_menu == nil) {
        
        XXBDropdownMenu *menu = [XXBDropdownMenu menu];
        menu.delegate = self;
        menu.items = [XXBMetaDataTool sharedMetaDataTool].categories;
        _menu = menu;
    }
    return _menu;
}
#pragma mark - XXBDropdownMenuDelegate
- (void)dropdownMenu:(XXBDropdownMenu *)dropdownMenu didSelectMain:(int)mainRow
{
    XXBCategory *c = dropdownMenu.items[mainRow];
    if (c.subcategories.count == 0)
    {
        // 发出通知，选中了某个分类
        [XXBNotificationCenter postNotificationName:XXBCategoryDidSelectNotification object:nil userInfo:@{XXBSelectedCategory : c}];
    }
    else
    { // 右边有子类别
        if (self.selectedCategory == c)
        {
            // 选中右边的子类别
            self.selectedSubCategoryName = self.selectedSubCategoryName;
        }
    }
}

- (void)dropdownMenu:(XXBDropdownMenu *)dropdownMenu didSelectSub:(int)subRow ofMain:(int)mainRow
{
    // 发出通知，选中了某个分类
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    XXBCategory *c = dropdownMenu.items[mainRow];
    userInfo[XXBSelectedCategory] = c;
    userInfo[XXBSelectedSubCategoryName] = c.subcategories[subRow];
    [XXBNotificationCenter postNotificationName:XXBCategoryDidSelectNotification object:nil userInfo:userInfo];
}
#pragma mark - 公共方法
- (void)setSelectedCategory:(XXBCategory *)selectedCategory
{
    _selectedCategory = selectedCategory;
    
    int mainRow = (int)[self.menu.items indexOfObject:selectedCategory];
    [self.menu selectMain:mainRow];
}

- (void)setSelectedSubCategoryName:(NSString *)selectedSubCategoryName
{
    _selectedSubCategoryName = [selectedSubCategoryName copy];
    
    int subRow = [self.selectedCategory.subcategories indexOfObject:selectedSubCategoryName];
    [self.menu selectSub:subRow];
}

@end
