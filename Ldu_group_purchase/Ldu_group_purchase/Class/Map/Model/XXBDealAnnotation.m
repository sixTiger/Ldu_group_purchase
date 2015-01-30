//
//  XXBDealAnnotation.m
//  Ldu_group_purchase
//
//  Created by Jinhong on 15/1/15.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import "XXBDealAnnotation.h"

@implementation XXBDealAnnotation

- (BOOL)isEqual:(XXBDealAnnotation *)other
{
    return self.coordinate.latitude == other.coordinate.latitude && self.coordinate.longitude == other.coordinate.longitude;
}
@end
