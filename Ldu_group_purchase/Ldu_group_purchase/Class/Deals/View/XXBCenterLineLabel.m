//
//  XXBCenterLineLabel.m
//  Ldu_group_purchase
//
//  Created by Jinhong on 15/1/15.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import "XXBCenterLineLabel.h"

@implementation XXBCenterLineLabel

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    // 设置绘图颜色
    [self.textColor set];
    
    // 矩形框的值
    CGFloat x = 0;
    CGFloat y = self.height * 0.5;
    CGFloat w = self.width;
    CGFloat h = 0.5;
    UIRectFill(CGRectMake(x, y, w, h));
}

@end
