//
//  XXBCategory.m
//  Ldu_group_purchase
//
//  Created by Jinhong on 15-1-13.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import "XXBCategory.h"

@implementation XXBCategory

- (NSString *)title
{
    return self.name;
}

- (NSArray *)subtitles
{
    return self.subcategories;
}

- (NSString *)image
{
    return self.small_icon;
}

- (NSString *)highlightedImage
{
    return self.small_highlighted_icon;
}
MJCodingImplementation
@end
