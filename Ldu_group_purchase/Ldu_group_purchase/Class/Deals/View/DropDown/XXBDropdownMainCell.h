//
//  XXBDropdownMainCell.h
//  Ldu_group_purchase
//
//  Created by Jinhong on 15/1/14.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//  菜单左边的cell

#import <UIKit/UIKit.h>
#import "XXBDropdownMenu.h"

@interface XXBDropdownMainCell : UITableViewCell
@property (nonatomic, strong) id<XXBDropdownMenuItem> item;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
