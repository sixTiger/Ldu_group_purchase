//
//  XXBNaviaViewController.m
//  Ldu_group_purchase
//
//  Created by Jinhong on 15-1-13.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import "XXBNavigationController.h"

@interface XXBNavigationController ()

@end

@implementation XXBNavigationController

+ (void)initialize
{
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setBackgroundImage:[UIImage imageNamed:@"bg_navigationBar_normal"] forBarMetrics:UIBarMetricsDefault];
    navBar.tintColor = [UIColor grayColor];
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = XXBColor(29, 177, 157);
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    
    NSMutableDictionary *disableAttrs = [NSMutableDictionary dictionary];
    disableAttrs[NSForegroundColorAttributeName] = XXBColor(210, 210, 210);
    [item setTitleTextAttributes:disableAttrs forState:UIControlStateDisabled];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

@end
