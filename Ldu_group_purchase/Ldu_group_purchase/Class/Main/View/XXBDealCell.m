//
//  XXBDealCell.m
//  Ldu_group_purchase
//
//  Created by Jinhong on 15-1-13.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import "XXBDealCell.h"
#import "XXBDeal.h"

#import "UIImageView+WebCache.h"

@interface XXBDealCell ()


@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *listPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *purchaseCountLabel;
/**
 *  属性名不能以new开头
 */
@property (weak, nonatomic) IBOutlet UIImageView *dealNewView;

@property (weak, nonatomic) IBOutlet UIButton *cover;
@property (weak, nonatomic) IBOutlet UIImageView *check;

- (IBAction)coverClick;

@end

@implementation XXBDealCell

- (void)setDeal:(XXBDeal *)deal
{
    _deal = deal;
    
    // 图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:deal.image_url] placeholderImage:[UIImage imageNamed:@"placeholder_deal"]];
    // 标题
    self.titleLabel.text = deal.title;
    // 描述
    self.descLabel.text = deal.desc;
    // 现价
    self.currentPriceLabel.text = [NSString stringWithFormat:@"￥%@", deal.current_price];
    // 原价
    self.listPriceLabel.text = [NSString stringWithFormat:@"￥%@", deal.list_price];
    // 购买数
    self.purchaseCountLabel.text = [NSString stringWithFormat:@"已售出%d", deal.purchase_count];
    
    // 判断是否为最新的团购：发布日期 >= 今天的日期
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *today = [fmt stringFromDate:[NSDate date]];
    // 之前发布的：今天日期 > 发布日期
    self.dealNewView.hidden = ([today compare:deal.publish_date] == NSOrderedDescending);
    
    // 设置编辑状态
    if (deal.isEditing) {
        self.cover.hidden = NO;
    } else {
        self.cover.hidden = YES;
    }
    
    // 设置勾选状态
    self.check.hidden = !self.deal.isChecking;
}

- (void)drawRect:(CGRect)rect
{
    [[UIImage imageNamed:@"bg_dealcell"] drawInRect:rect];
}

- (IBAction)coverClick {
    self.deal.checking = !self.deal.isChecking;
    self.check.hidden = !self.check.hidden;
    
    if ([self.delegate respondsToSelector:@selector(dealCellDidClickCover:)]) {
        [self.delegate dealCellDidClickCover:self];
    }
}

@end
