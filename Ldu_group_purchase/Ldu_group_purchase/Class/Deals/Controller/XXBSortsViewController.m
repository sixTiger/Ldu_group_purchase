//
//  XXBSortsViewController.m
//  Ldu_group_purchase
//
//  Created by Jinhong on 15/1/14.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import "XXBSortsViewController.h"
#import "XXBSort.h"

#warning 一个文件可以写两个类
#pragma mark - 自定义Button
@interface XXBSortButton : UIButton
@property (nonatomic, strong) XXBSort *sort;
@end

@implementation XXBSortButton
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.bgImage = @"btn_filter_normal";
        self.selectedBgImage = @"btn_filter_selected";
        self.titleColor = [UIColor blackColor];
        self.selectedTitleColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{
    
}

- (void)setSort:(XXBSort *)sort
{
    _sort = sort;
    
    self.title = sort.label;
}
@end
#pragma mark - 控制器的代码
@interface XXBSortsViewController ()

@property (weak, nonatomic) XXBSortButton *selectedButton;

@end

@implementation XXBSortsViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置在popover中的尺寸
    self.preferredContentSize = self.view.size;
    
    // 根据排序模型的个数，创建对应的按钮
    CGFloat buttonX = 20;
    CGFloat buttonW = self.view.width - 2 * buttonX;
    CGFloat buttonP = 15;
    NSArray *sorts = [XXBMetaDataTool sharedMetaDataTool].sorts;
    int count = sorts.count;
    CGFloat contentH = 0;
    for (int i = 0; i<count; i++) {
        // 创建按钮
        XXBSortButton *button = [[XXBSortButton alloc] init];
        // 取出模型
        button.sort = sorts[i];
        // 设置尺寸
        button.x = buttonX;
        button.width = buttonW;
        button.height = 30;
        button.y = buttonP + i * (button.height + buttonP);
        // 监听按钮点击
        [button addTarget:self action:@selector(sortButtonClick:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:button];
        
        // 内容的高度
        contentH = button.maxY + buttonP;
    }
    
    // 设置contentSize
    UIScrollView *scrollView = (UIScrollView *)self.view;
    scrollView.contentSize = CGSizeMake(0, contentH);
}

- (void)sortButtonClick:(XXBSortButton *)button
{
    // 1.修改状态
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
    
    
    // 2.发出通知
    [XXBNotificationCenter postNotificationName:XXBSortDidSelectNotification object:nil userInfo:@{XXBSelectedSort : button.sort}];
}
#pragma mark - 选中状态的记录
- (void)setSelectedSort:(XXBSort *)selectedSort
{
    _selectedSort = selectedSort;
    
    for (XXBSortButton *button in self.view.subviews)
    {
        if ([button isKindOfClass:[XXBSortButton class]] && button.sort == selectedSort)
        {
            self.selectedButton.selected = NO;
            button.selected = YES;
            self.selectedButton = button;
        }
    }
}
@end
