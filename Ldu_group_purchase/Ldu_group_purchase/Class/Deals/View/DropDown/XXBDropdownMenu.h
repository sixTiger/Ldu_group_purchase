//
//  XXBDropdownMenu.h
//  Ldu_group_purchase
//
//  Created by Jinhong on 15/1/14.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XXBDropdownMenu;
@protocol XXBDropdownMenuItem <NSObject>
@required
/** 标题 */
- (NSString *)title;
/** 子标题数据 */
- (NSArray *)subtitles;
@optional
/** 图标 */
- (NSString *)image;
/** 选中的图标 */
- (NSString *)highlightedImage;
@end


/** XXBDropdownMenuDelegate  */
@protocol XXBDropdownMenuDelegate <NSObject>
@optional
- (void)dropdownMenu:(XXBDropdownMenu *)dropdownMenu didSelectMain:(int)mainRow;
- (void)dropdownMenu:(XXBDropdownMenu *)dropdownMenu didSelectSub:(int)subRow ofMain:(int)mainRow;
@end


@interface XXBDropdownMenu : UIView

/**
 *  显示的数据模型(里面的模型必须遵守XXBDropdownMenuItem协议)
 */
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, weak) id<XXBDropdownMenuDelegate> delegate;

+ (instancetype)menu;

- (void)selectMain:(int)mainRow;
- (void)selectSub:(int)subRow;
@end
