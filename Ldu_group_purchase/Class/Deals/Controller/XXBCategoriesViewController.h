//
//  XXBCategoriesViewController.h
//  Ldu_group_purchase
//
//  Created by Jinhong on 15/1/14.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//  分类选取菜单

#import <UIKit/UIKit.h>
@class XXBCategory;

@interface XXBCategoriesViewController : UIViewController

/** 当前选中的分类 */
@property (strong, nonatomic) XXBCategory *selectedCategory;
/** 当前选中的子分类名称 */
@property (copy, nonatomic) NSString *selectedSubCategoryName;

@end
