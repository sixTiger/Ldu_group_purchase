//
//  XXBDealAnnotation.h
//  Ldu_group_purchase
//
//  Created by Jinhong on 15/1/15.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@class XXBDeal;

@interface XXBDealAnnotation : NSObject <MKAnnotation>
/**
 *  大头针的位置
 */
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

/**
 *  这颗大头针绑定的团购模型
 */
@property (nonatomic, strong) XXBDeal *deal;

@end
