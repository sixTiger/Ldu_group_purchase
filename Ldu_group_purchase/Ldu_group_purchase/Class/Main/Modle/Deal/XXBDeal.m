//
//  XXBDeal.m
//  Ldu_group_purchase
//
//  Created by Jinhong on 15-1-13.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import "XXBDeal.h"
#import "XXBBusiness.h"

@implementation XXBDeal
- (NSDictionary *)objectClassInArray
{
    return @{@"businesses" : [XXBBusiness class]};
}

- (NSDictionary *)replacedKeyFromPropertyName
{
    // 模型的desc属性对应着字典中的description
    return @{@"desc" : @"description"};
}
/**
 *  重写isEqual方法 为了在从本地取出来的数据能根内存中的数据继续那个判断
 *
 *  @param other 要比较的数据
 *
 *  @return 是否相等
 */
- (BOOL)isEqual:(XXBDeal *)other
{
    return [self.deal_id isEqualToString:other.deal_id];
}

- (NSNumber *)dealNumber:(NSNumber *)sourceNumber
{
    NSString *str = [sourceNumber description];
    
    // 小数点的位置
    NSUInteger dotIndex = [str rangeOfString:@"."].location;
    if (dotIndex != NSNotFound && str.length - dotIndex > 2) { // 小数超过2位
        str = [str substringToIndex:dotIndex + 3];
        //去掉末尾的0
        NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"0"];
        str = [str stringByTrimmingCharactersInSet:set];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        return [formatter numberFromString:[NSString stringWithFormat:@"%@5",str]];
    }
    return sourceNumber;
}

- (void)setList_price:(NSNumber *)list_price
{
    _list_price = [self dealNumber:list_price];
    
}

- (void)setCurrent_price:(NSNumber *)current_price
{
    _current_price = [self dealNumber:current_price];
}

MJCodingImplementation
@end
