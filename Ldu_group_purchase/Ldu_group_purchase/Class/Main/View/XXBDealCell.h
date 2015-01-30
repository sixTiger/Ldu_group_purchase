//
//  XXBDealCell.h
//  Ldu_group_purchase
//
//  Created by Jinhong on 15-1-13.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XXBDeal,XXBDealCell;

@protocol XXBDealCellDelegate <NSObject>

@optional
- (void)dealCellDidClickCover:(XXBDealCell *)dealCell;

@end

@interface XXBDealCell : UICollectionViewCell

@property (nonatomic, strong) XXBDeal *deal;

@property (nonatomic, weak) id<XXBDealCellDelegate> delegate;

@end
