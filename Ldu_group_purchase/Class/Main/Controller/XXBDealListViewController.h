//
//  XXBDealListViewController.h
//  Ldu_group_purchase
//
//  Created by Jinhong on 15/1/15.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXBDealListViewController : UICollectionViewController

/** 存放所有的团购数据 */
@property (nonatomic, strong) NSMutableArray *deals;

- (NSString *)emptyIcon;
@end
