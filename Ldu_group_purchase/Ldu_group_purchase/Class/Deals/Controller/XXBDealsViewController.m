//
//  XXBDealsViewController.m
//  Ldu_group_purchase
//
//  Created by Jinhong on 15-1-13.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import "XXBDealsViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "AwesomeMenu.h"
#import "AwesomeMenuItem.h"
#import "XXBDealsTopMenu.h"
#import "XXBCategoriesViewController.h"
#import "XXBRegionsViewController.h"
#import "XXBSortsViewController.h"
#import "XXBCity.h"
#import "XXBSort.h"
#import "XXBRegion.h"
#import "XXBCategory.h"

#import "XXBDealTool.h"
#import "XXBDealCell.h"


#import "MJRefresh.h"

#import "XXBCollectViewController.h"
#import "XXBNavigationController.h"
#import "XXBHistoryViewController.h"
#import "XXBCollectViewController.h"
#import "XXBSearchViewController.h"
#import "XXBMapViewController.h"
#import "XXBLoginViewController.h"

@interface XXBDealsViewController ()<AwesomeMenuDelegate>

/** 分类菜单 */
@property (weak, nonatomic) XXBDealsTopMenu *categoryMenu;
/** 区域菜单 */
@property (weak, nonatomic) XXBDealsTopMenu *regionMenu;
/** 排序菜单 */
@property (weak, nonatomic) XXBDealsTopMenu *sortMenu;


/** 点击顶部菜单后弹出的Popover */
/** 分类Popover */
@property (strong, nonatomic) UIPopoverController *categoryPopover;
/** 区域Popover */
@property (strong, nonatomic) UIPopoverController *regionPopover;
/** 排序Popover */
@property (strong, nonatomic) UIPopoverController *sortPopover;

/** 选中的状态 */
@property (nonatomic, strong) XXBCity *selectedCity;
/** 当前选中的区域 */
@property (strong, nonatomic) XXBRegion *selectedRegion;
/** 当前选中的子区域名称 */
@property (copy, nonatomic) NSString *selectedSubRegionName;
/** 当前选中的排序 */
@property (strong, nonatomic) XXBSort *selectedSort;
/** 当前选中的分类 */
@property (strong, nonatomic) XXBCategory *selectedCategory;
/** 当前选中的子分类名称 */
@property (copy, nonatomic) NSString *selectedSubCategoryName;


/** 请求参数 */
@property (nonatomic, strong) XXBFindDealsParam *lastParam;
/**
 *  存储请求结果的总数
 */
@property (nonatomic, assign) int totalNumber;

@end

@implementation XXBDealsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 用户菜单
    [self setupUserMenu];
    
    
    // 设置导航栏右边的内容
    [self setupNavRight];
    
    
    // 设置导航栏左边边的内容
    [self setupNavLeft];
    
    // 集成刷新控件
    [self setupRefresh];
    
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupNotifications];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    XXBRemoveObsver;
}
/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    [self.collectionView addHeaderWithTarget:self action:@selector(loadNewDeals)];
    [self.collectionView headerBeginRefreshing];
    
    [self.collectionView addFooterWithTarget:self action:@selector(loadMoreDeals)];
}

#pragma mark - 通知处理
/** 监听通知 */
- (void)setupNotifications
{
    XXBAddObsver(cityDidSelect:, XXBCityDidSelectNotification);
    XXBAddObsver(sortDidSelect:, XXBSortDidSelectNotification);
    XXBAddObsver(categoryDidSelect:, XXBCategoryDidSelectNotification);
    XXBAddObsver(regionDidSelect:, XXBRegionDidSelectNotification);
}


- (void)regionDidSelect:(NSNotification *)note
{
    // 关闭popover
    [self.regionPopover dismissPopoverAnimated:YES];
    
    // 取出通知中的数据
    self.selectedRegion = note.userInfo[XXBSelectedRegion];
    self.selectedSubRegionName = note.userInfo[XXBSelectedSubRegionName];
    
    // 设置菜单数据
    self.regionMenu.titleLabel.text = [NSString stringWithFormat:@"%@ - %@", self.selectedCity.name, self.selectedRegion.name];
    self.regionMenu.subtitleLabel.text = self.selectedSubRegionName;
    
    
    [self.collectionView headerBeginRefreshing];
    
    
    
    // 存储用户的选择到沙盒
    [[XXBMetaDataTool sharedMetaDataTool] saveSelectedRegion:self.selectedRegion];
    // 存储用户的选择到沙盒
    [[XXBMetaDataTool sharedMetaDataTool] saveSelectedSubRegionName:self.selectedSubRegionName];
}

- (void)categoryDidSelect:(NSNotification *)note
{
    // 关闭popover
    [self.categoryPopover dismissPopoverAnimated:YES];
    
    // 取出通知中的数据
    self.selectedCategory = note.userInfo[XXBSelectedCategory];
    self.selectedSubCategoryName = note.userInfo[XXBSelectedSubCategoryName];
    if(note.userInfo[XXBSelectedSubCategoryName] == nil)
    {
        self.selectedSubCategoryName = self.selectedCategory.name;
    }
    // 设置菜单数据
    self.categoryMenu.imageButton.image = self.selectedCategory.icon;
    self.categoryMenu.imageButton.highlightedImage = self.selectedCategory.highlighted_icon;
    self.categoryMenu.titleLabel.text = self.selectedCategory.name;
    self.categoryMenu.subtitleLabel.text = self.selectedSubCategoryName;
    
    [self.collectionView headerBeginRefreshing];
    
    // 存储用户的选择到沙盒
    [[XXBMetaDataTool sharedMetaDataTool] saveSelectedCategory:self.selectedCategory];
    [[XXBMetaDataTool sharedMetaDataTool] saveSelectedSubCategoryName:self.selectedSubCategoryName];
}

- (void)cityDidSelect:(NSNotification *)note
{
    
    [self.regionPopover dismissPopoverAnimated:YES];
    
    // 取出通知中的数据
    self.selectedCity = note.userInfo[XXBSelectedCity];
    
    self.regionMenu.titleLabel.text = self.selectedCity.name;
    self.regionMenu.subtitleLabel.text = @"全部";
    
    // 更换显示的区域数据
    XXBRegionsViewController *regionsVc = (XXBRegionsViewController *)self.regionPopover.contentViewController;
    regionsVc.regions = self.selectedCity.regions;
    
    [self.collectionView headerBeginRefreshing];
    
    
    // 存储用户的选择到沙盒
    [[XXBMetaDataTool sharedMetaDataTool] saveSelectedCityName:self.selectedCity.name];
}

- (void)sortDidSelect:(NSNotification *)note
{
    // 取出通知中的数据
    self.selectedSort = note.userInfo[XXBSelectedSort];
    
    self.sortMenu.subtitleLabel.text = self.selectedSort.label;
    
    // 销毁popover
    [self.sortPopover dismissPopoverAnimated:YES];
    
    [self.collectionView headerBeginRefreshing];
    
    
    
    // 存储用户的选择到沙盒
    [[XXBMetaDataTool sharedMetaDataTool] saveSelectedSort:self.selectedSort];
}

#pragma mark - 设置导航栏
/**
 *  设置导航栏左边的内容
 */
- (void)setupNavLeft
{
    // 1.LOGO
    UIBarButtonItem *logoItem = [UIBarButtonItem itemWithImageName:@"icon_meituan_logo" highImageName:@"icon_meituan_logo" target:nil action:nil];
    logoItem.customView.userInteractionEnabled = NO;
    
    // 2.分类
    XXBDealsTopMenu *categoryMenu = [XXBDealsTopMenu menu];
    
    categoryMenu.imageButton.image = self.selectedCategory.icon;
    categoryMenu.imageButton.highlightedImage = self.selectedCategory.highlighted_icon;
    categoryMenu.titleLabel.text = self.selectedCategory.name;
    categoryMenu.subtitleLabel.text = self.selectedSubCategoryName;
    
    [categoryMenu addTarget:self action:@selector(categoryMenuClick)];
    UIBarButtonItem *categoryItem = [[UIBarButtonItem alloc] initWithCustomView:categoryMenu];
    self.categoryMenu = categoryMenu;
    
    // 3.区域
    XXBDealsTopMenu *regionMenu = [XXBDealsTopMenu menu];
    regionMenu.imageButton.image = @"icon_district";
    regionMenu.imageButton.highlightedImage = @"icon_district_highlighted";
    
    regionMenu.titleLabel.text = [NSString stringWithFormat:@"%@ - %@", self.selectedCity.name,self.selectedRegion.name];
    regionMenu.subtitleLabel.text = self.selectedSubRegionName;
    [regionMenu addTarget:self action:@selector(regionMenuClick)];
    UIBarButtonItem *regionItem = [[UIBarButtonItem alloc] initWithCustomView:regionMenu];
    self.regionMenu = regionMenu;
    
    // 4.排序
    XXBDealsTopMenu *sortMenu = [XXBDealsTopMenu menu];
    sortMenu.imageButton.image = @"icon_sort";
    sortMenu.imageButton.highlightedImage = @"icon_sort_highlighted";
    sortMenu.titleLabel.text = @"排序";
    
    
    sortMenu.subtitleLabel.text = self.selectedSort.label;
    [sortMenu addTarget:self action:@selector(sortMenuClick)];
    UIBarButtonItem *sortItem = [[UIBarButtonItem alloc] initWithCustomView:sortMenu];
    self.sortMenu = sortMenu;
    
    self.navigationItem.leftBarButtonItems = @[logoItem, categoryItem, regionItem, sortItem];
}

/**
 *  设置导航栏右边的内容
 */
- (void)setupNavRight
{
    // 1.地图
    UIBarButtonItem *mapItem = [UIBarButtonItem itemWithImageName:@"icon_map" highImageName:@"icon_map_highlighted" target:self action:@selector(mapClick)];
    mapItem.customView.width = 50;
    mapItem.customView.height = 27;
    
    // 2.搜索
    UIBarButtonItem *searchItem = [UIBarButtonItem itemWithImageName:@"icon_search" highImageName:@"icon_search_highlighted" target:self action:@selector(searchClick)];
    searchItem.customView.width = mapItem.customView.width;
    searchItem.customView.height = mapItem.customView.height;
    
    self.navigationItem.rightBarButtonItems = @[mapItem, searchItem];
}
#pragma mark - 导航栏左边处理
/** 分类菜单 */
- (void)categoryMenuClick
{
    
    XXBCategoriesViewController *cs = (XXBCategoriesViewController *)self.categoryPopover.contentViewController;
    cs.selectedCategory = self.selectedCategory;
    cs.selectedSubCategoryName = self.selectedSubCategoryName;
    
    [self.categoryPopover presentPopoverFromRect:self.categoryMenu.bounds inView:self.categoryMenu permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

/** 区域菜单 */
- (void)regionMenuClick
{
    
    XXBRegionsViewController *rs = (XXBRegionsViewController *)self.regionPopover.contentViewController;
    rs.selectedRegion = self.selectedRegion;
    rs.selectedSubRegionName = self.selectedSubRegionName;
    [self.regionPopover presentPopoverFromRect:self.regionMenu.bounds inView:self.regionMenu permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

/** 排序菜单 */
- (void)sortMenuClick
{
    XXBSortsViewController *os = (XXBSortsViewController *)self.sortPopover.contentViewController;
    os.selectedSort = self.selectedSort;
    [self.sortPopover presentPopoverFromRect:self.sortMenu.bounds inView:self.sortMenu permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
#pragma mark - 导航栏右边处理
/**
 *  搜索
 */
- (void)searchClick
{
    
    XXBSearchViewController *searchVC = [[XXBSearchViewController alloc] init];
    searchVC.selectedCity = self.selectedCity;
    XXBNavigationController *nav = [[XXBNavigationController alloc] initWithRootViewController:searchVC];
    [self presentViewController:nav animated:YES completion:nil];
}

/**
 *  地图
 */
- (void)mapClick
{
    
    XXBMapViewController *mapVC = [[XXBMapViewController alloc] init];
//    searchVC.selectedCity = self.selectedCity;
    XXBNavigationController *nav = [[XXBNavigationController alloc] initWithRootViewController:mapVC];
    [self presentViewController:nav animated:YES completion:nil];
}
#pragma mark - 懒加载

- (UIPopoverController *)categoryPopover
{
    if (_categoryPopover == nil) {
        XXBCategoriesViewController *cv = [[XXBCategoriesViewController alloc] init];
        self.categoryPopover = [[UIPopoverController alloc] initWithContentViewController:cv];
    }
    return _categoryPopover;
}

- (UIPopoverController *)regionPopover
{
    if (!_regionPopover) {
        XXBRegionsViewController *rv = [[XXBRegionsViewController alloc] init];
        rv.regions = self.selectedCity.regions;
        self.regionPopover = [[UIPopoverController alloc] initWithContentViewController:rv];
    }
    return _regionPopover;
}

- (UIPopoverController *)sortPopover
{
    if (!_sortPopover) {
        XXBSortsViewController *sv = [[XXBSortsViewController alloc] init];
        self.sortPopover = [[UIPopoverController alloc] initWithContentViewController:sv];
    }
    return _sortPopover;
}
/**
 */
- (XXBCity *)selectedCity
{
    if (_selectedCity == nil)
    {
        self.selectedCity = [XXBMetaDataTool sharedMetaDataTool].selectedCity;
    }
    return _selectedCity;
}
- (XXBRegion *)selectedRegion
{
    if (_selectedRegion == nil)
    {
         self.selectedRegion = [XXBMetaDataTool sharedMetaDataTool].selectedRegion;
    }
    return _selectedRegion;

}
- (XXBSort *)selectedSort
{
    if (_selectedSort == nil)
    {
        self.selectedSort = [XXBMetaDataTool sharedMetaDataTool].selectedSort;
    }
    return _selectedSort;
    
}
- (NSString *)selectedSubRegionName
{
    if (_selectedSubRegionName == nil)
    {
         self.selectedSubRegionName = [XXBMetaDataTool sharedMetaDataTool].selectedSubRegionName;
    }
    return _selectedSubRegionName;
    
}
- (XXBCategory *)selectedCategory
{
    if (_selectedCategory == nil)
    {
        self.selectedCategory = [XXBMetaDataTool sharedMetaDataTool].selectedCategory;
    }
    return _selectedCategory;
    
}
- (NSString *)selectedSubCategoryName
{
    if (_selectedSubCategoryName == nil) {
        self.selectedSubCategoryName = [XXBMetaDataTool sharedMetaDataTool].SelectedSubCategoryName;
    }
    return _selectedSubCategoryName;
}
#pragma mark - Path菜单
/**
 *  创建一个Path菜单item
 */
- (AwesomeMenuItem *)itemWithContent:(NSString *)content highlightedContent:(NSString *)highlightedContent
{
    UIImage *itemBg = [UIImage imageNamed:@"bg_pathMenu_black_normal"];
    return [[AwesomeMenuItem alloc] initWithImage:itemBg
                                 highlightedImage:nil
                                     ContentImage:[UIImage imageNamed:content]
                          highlightedContentImage:[UIImage imageNamed:highlightedContent]];
}
/**
 *  用户菜单
 */
- (void)setupUserMenu
{
    // 1.周边的item
    AwesomeMenuItem *mineItem = [self itemWithContent:@"icon_pathMenu_mine_normal" highlightedContent:@"icon_pathMenu_mine_highlighted"];
    AwesomeMenuItem *collectItem = [self itemWithContent:@"icon_pathMenu_collect_normal" highlightedContent:@"icon_pathMenu_collect_highlighted"];
    AwesomeMenuItem *scanItem = [self itemWithContent:@"icon_pathMenu_scan_normal" highlightedContent:@"icon_pathMenu_scan_highlighted"];
    AwesomeMenuItem *moreItem = [self itemWithContent:@"icon_pathMenu_more_normal" highlightedContent:@"icon_pathMenu_more_highlighted"];
    NSArray *items = @[mineItem, collectItem, scanItem, moreItem];
    // 2.中间的开始tiem
    AwesomeMenuItem *startItem = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"icon_pathMenu_background_normal"]
                                                       highlightedImage:[UIImage imageNamed:@"icon_pathMenu_background_highlighted"]
                                                           ContentImage:[UIImage imageNamed:@"icon_pathMenu_mainMine_normal"]
                                                highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_mainMine_highlighted"]];
    
    AwesomeMenu *menu = [[AwesomeMenu alloc] initWithFrame:CGRectZero startItem:startItem optionMenus:items];
    [self.view addSubview:menu];
    // 真个菜单的活动范围
    menu.menuWholeAngle = M_PI_2;
    // 约束
    CGFloat menuH = 200;
    [menu autoSetDimensionsToSize:CGSizeMake(200, menuH)];
    [menu autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [menu autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    
    // 3.添加一个背景
    UIImageView *menuBg = [[UIImageView alloc] init];
    menuBg.image = [UIImage imageNamed:@"icon_pathMenu_background"];
    [menu insertSubview:menuBg atIndex:0];
    // 约束
    [menuBg autoSetDimensionsToSize:menuBg.image.size];
    [menuBg autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [menuBg autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    
    // 起点
    menu.startPoint = CGPointMake(menuBg.image.size.width * 0.5, menuH - menuBg.image.size.height * 0.5);
    // 禁止中间按钮旋转
    menu.rotateAddButton = NO;
    
    // 设置代理
    menu.delegate = self;
}

#pragma mark - 菜单代理
- (void)awesomeMenuWillAnimateClose:(AwesomeMenu *)menu
{
    // 恢复图片
    menu.contentImage = [UIImage imageNamed:@"icon_pathMenu_mainMine_normal"];
    menu.highlightedContentImage = [UIImage imageNamed:@"icon_pathMenu_mainMine_highlighted"];
}

- (void)awesomeMenuWillAnimateOpen:(AwesomeMenu *)menu
{
    // 显示xx图片
    menu.contentImage = [UIImage imageNamed:@"icon_pathMenu_cross_normal"];
    menu.highlightedContentImage = [UIImage imageNamed:@"icon_pathMenu_cross_highlighted"];
}

/**
 *  处理菜单的选中效果
 *
 *  @param menu 菜单
 *  @param idx  选中的按钮
 */
- (void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx
{
    [self awesomeMenuWillAnimateClose:menu];
    switch (idx) {
        case 0:
        { //登录
            XXBLoginViewController *collectVC = [[XXBLoginViewController alloc] init];
            XXBNavigationController *nav = [[XXBNavigationController alloc] initWithRootViewController:collectVC];
            [self presentViewController:nav animated:YES completion:nil];
            break;
        }
        case 1:
        { //收藏
            XXBCollectViewController *collectVC = [[XXBCollectViewController alloc] init];
            XXBNavigationController *nav = [[XXBNavigationController alloc] initWithRootViewController:collectVC];
            [self presentViewController:nav animated:YES completion:nil];
            break;
        }
        case 2:
        {
            // 浏览记录
            XXBHistoryViewController *historyVc = [[XXBHistoryViewController alloc] init];
            XXBNavigationController *nav = [[XXBNavigationController alloc] initWithRootViewController:historyVc];
            [self presentViewController:nav animated:YES completion:nil];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - 刷新数据
/**
 *  封装请求参数
 */
- (XXBFindDealsParam *)buildParam
{
    XXBFindDealsParam *param = [[XXBFindDealsParam alloc] init];
    // 城市名称
    param.city = self.selectedCity.name;
    // 排序
    if (self.selectedSort)
    {
        param.sort = @(self.selectedSort.value);
    }
    // 除开“全部分类”和“全部”以外的所有词语都可以发
    // 分类
    if (self.selectedCategory && ![self.selectedCategory.name isEqualToString:@"全部分类"])
    {
        if (self.selectedSubCategoryName && ![self.selectedSubCategoryName isEqualToString:@"全部"])
        {
            param.category = self.selectedSubCategoryName;
        }
        else
        {
            param.category = self.selectedCategory.name;
        }
    }
    // 区域
    if (self.selectedRegion && ![self.selectedRegion.name isEqualToString:@"全部"])
    {
        if (self.selectedSubRegionName && ![self.selectedSubRegionName isEqualToString:@"全部"])
        {
            param.region = self.selectedSubRegionName;
        }
        else
        {
            param.region = self.selectedRegion.name;
        }
    }
    param.page = @1;
    //    param.limit = @(3);
    return param;
}
- (void)loadNewDeals
{
    // 创建请求参数
    XXBFindDealsParam *param = [self buildParam];
    
    
    [XXBDealTool findDeals:param success:^(XXBFindDealsResult *result) {
        // 结束刷新
        [self.collectionView headerEndRefreshing];
        
        // 如果请求过期了，直接返回
        if (param != self.lastParam)
            return;
        
        // 记录总数
        self.totalNumber = result.total_count;
        
        // 清空之前的所有数据
        [self.deals removeAllObjects];
        // 添加新的数据
        [self.deals addObjectsFromArray:result.deals];
        // 刷新表格
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        // 结束刷新
        [self.collectionView headerEndRefreshing];
        
        // 如果请求过期了，直接返回
        if (param != self.lastParam) return;
        [MBProgressHUD showError:@"加载团购失败，请稍后再试" toView:self.view];
    }];
    // 3.保存请求参数
    self.lastParam = param;
}

- (void)loadMoreDeals
{
    // 1.创建请求参数
    XXBFindDealsParam *param = [self buildParam];
    // 页码
    param.page = @(self.lastParam.page.intValue + 1);
    
    // 2.加载数据
    [XXBDealTool findDeals:param success:^(XXBFindDealsResult *result) {
        // 结束刷新
        [self.collectionView footerEndRefreshing];
        
        // 如果请求过期了，直接返回
        if (param != self.lastParam) return;
        
        // 添加新的数据
        [self.deals addObjectsFromArray:result.deals];
        // 刷新表格
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        // 结束刷新
        [self.collectionView footerEndRefreshing];
        // 回滚页码
        param.page = @(param.page.intValue - 1);
        
        // 如果请求过期了，直接返回
        if (param != self.lastParam) return;
        [MBProgressHUD showError:@"加载团购失败，请稍后再试" toView:self.view];
    }];
    
    // 3.设置请求参数
    self.lastParam = param;
}

#pragma mark - 数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    // 尾部控件的可见性
    self.collectionView.footerHidden = (self.deals.count == self.totalNumber);
    return [super collectionView:collectionView numberOfItemsInSection:section];
}
#pragma mark - 实现父类方法
- (NSString *)emptyIcon
{
    return @"icon_deals_empty";
}
@end
