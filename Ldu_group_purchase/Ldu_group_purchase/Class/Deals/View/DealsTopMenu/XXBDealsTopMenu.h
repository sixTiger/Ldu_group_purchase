//
//  XXBDealsTopMenu.h
//  Ldu_group_purchase
//
//  Created by Jinhong on 15/1/14.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//  导航栏的菜单

#import <UIKit/UIKit.h>

@interface XXBDealsTopMenu : UIView

@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

+ (instancetype)menu;

- (void)addTarget:(id)target action:(SEL)action;
@end
