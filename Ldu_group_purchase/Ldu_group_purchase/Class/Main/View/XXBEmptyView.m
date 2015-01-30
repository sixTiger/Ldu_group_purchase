//
//  XXBEmptyView.m
//  Ldu_group_purchase
//
//  Created by Jinhong on 15-1-13.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import "XXBEmptyView.h"

@implementation XXBEmptyView

+ (instancetype)emptyView
{
    return [[self alloc] init];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode = UIViewContentModeCenter;
    }
    return self;
}

/**
 *  当一个控件被添加到父控件或者从父控件移除会调用（一旦从父控件中移除，self.superview是nil）
 */
- (void)didMoveToSuperview
{
#warning 如果父控件不为nil，才需要添加约束
    if (self.superview) {
        // 填充整个父控件
        [self autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    }
}

@end
