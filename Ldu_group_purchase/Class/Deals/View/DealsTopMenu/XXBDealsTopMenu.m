//
//  XXBDealsTopMenu.m
//  Ldu_group_purchase
//
//  Created by Jinhong on 15/1/14.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import "XXBDealsTopMenu.h"

@interface XXBDealsTopMenu ()
@end
@implementation XXBDealsTopMenu
+ (instancetype)menu
{
    return [[[NSBundle mainBundle] loadNibNamed:@"XXBDealsTopMenu" owner:nil options:nil] lastObject];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.autoresizingMask = UIViewAutoresizingNone;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.autoresizingMask = UIViewAutoresizingNone;
    }
    return self;
}
- (void)addTarget:(id)target action:(SEL)action
{
    [self.imageButton addTarget:target action:action];
}
@end
