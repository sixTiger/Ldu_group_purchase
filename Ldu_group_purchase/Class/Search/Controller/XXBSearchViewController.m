//
//  XXBSearchViewController.m
//  Ldu_group_purchase
//
//  Created by Jinhong on 15/1/15.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import "XXBSearchViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "XXBDealTool.h"
#import "XXBCity.h"
#import "MJRefresh.h"

@interface XXBSearchViewController ()<UISearchBarDelegate>
@property (nonatomic, strong) XXBFindDealsParam *lastParam;
@property (nonatomic, assign) int totalCount;
@property (nonatomic, weak) UISearchBar *searchBar;

@end

@implementation XXBSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置导航栏的内容
    [self setupNav];
    
    // 集成上拉加载更多
    [self setupRefresh];
}

/**
 *  集成上拉加载更多
 */
- (void)setupRefresh
{
    [self.collectionView addFooterWithTarget:self action:@selector(loadMoreDeals)];
}

- (void)loadMoreDeals
{
    self.searchBar.userInteractionEnabled = NO;
    
    // 1.创建请求参数
    XXBFindDealsParam *param = [[XXBFindDealsParam alloc] init];
    // 关键词
    param.keyword = self.searchBar.text;
    // 城市
    param.city = self.selectedCity.name;
    // 页码
    param.page = @(self.lastParam.page.intValue + 1);
    
    // 2.加载数据
    [XXBDealTool findDeals:param success:^(XXBFindDealsResult *result) {
        self.totalCount = result.total_count;
        
        // 添加新的数据
        [self.deals addObjectsFromArray:result.deals];
        // 刷新表格
        [self.collectionView reloadData];
        // 结束刷新
        [self.collectionView footerEndRefreshing];
        
        self.searchBar.userInteractionEnabled = YES;
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"加载团购失败，请稍后再试"];
        // 结束刷新
        [self.collectionView footerEndRefreshing];
        // 回滚页码
        param.page = @(param.page.intValue - 1);
        
        self.searchBar.userInteractionEnabled = YES;
    }];
    
    // 3.设置请求参数
    self.lastParam = param;
}

/**
 *  设置导航栏的内容
 */
- (void)setupNav
{
    // 左边的返回
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"icon_back" highImageName:@"icon_back_highlighted" target:self action:@selector(back)];
    
    // 中间的搜索框
    UIView *titleView = [[UIView alloc] init];
    titleView.height = 30;
    titleView.width = 400;
    self.navigationItem.titleView = titleView;
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield"];
    [titleView addSubview:searchBar];
    searchBar.delegate = self;
    searchBar.placeholder = @"请输入关键词";
    [searchBar autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    self.searchBar = searchBar;
}

/**
 *  返回
 */
- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UISearchBarDelegate
/**
 *  点击了搜索按钮
 */
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar endEditing:YES];
    
    [MBProgressHUD showMessage:@"正在搜索团购" toView:self.navigationController.view];
    
    // 1.请求参数
    XXBFindDealsParam *param = [[XXBFindDealsParam alloc] init];
    // 关键词
    param.keyword = searchBar.text;
    // 城市
    param.city = self.selectedCity.name;
    // 页码
    param.page = @1;
    
    // 2.搜索
    [XXBDealTool findDeals:param success:^(XXBFindDealsResult *result) {
        self.totalCount = result.total_count;
        
        [self.deals removeAllObjects];
        [self.deals addObjectsFromArray:result.deals];
        [self.collectionView reloadData];
        
        [MBProgressHUD hideHUDForView:self.navigationController.view];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.navigationController.view];
        
        [MBProgressHUD showError:@"加载团购失败，请稍后再试"];
    }];
    
    // 3.赋值
    self.lastParam = param;
}

#pragma mark - 数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    self.collectionView.footerHidden = self.deals.count == self.totalCount;
    return [super collectionView:collectionView numberOfItemsInSection:section];
}

#pragma mark - 实现父类方法
- (NSString *)emptyIcon
{
    return @"icon_deals_empty";
}

@end
