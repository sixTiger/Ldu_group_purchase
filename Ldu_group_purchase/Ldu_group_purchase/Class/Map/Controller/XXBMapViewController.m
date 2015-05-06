//
//  XXBMapViewController.m
//  Ldu_group_purchase
//
//  Created by Jinhong on 15/1/17.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import "XXBMapViewController.h"
#import "UIBarButtonItem+Extension.h"
#import <MapKit/MapKit.h>
#import "XXBFindDealsParam.h"
#import "XXBDealTool.h"
#import "XXBFindDealsResult.h"
#import "XXBDeal.h"
#import "XXBBusiness.h"
#import "XXBDealAnnotation.h"
#import "XXBDealAnnoRightButton.h"
#import "XXBDealDetailViewController.h"
#import "XXBDealsTopMenu.h"
#import "XXBCategory.h"
#import "XXBCategoriesViewController.h"
#import "XXBCity.h"


@interface XXBMapViewController ()<MKMapViewDelegate , CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView 	*mapView;
@property(nonatomic , strong)CLGeocoder  		*geocoder;
@property(nonatomic , copy)NSString 			*cityName;
/**
 *  是否正在处理请求
 */
@property(nonatomic , assign ,getter= isDealingDeals)BOOL 	dealingDeals;


/** 分类菜单 */
@property (weak, nonatomic) XXBDealsTopMenu *categoryMenu;
/** 分类Popover */
@property (strong, nonatomic) UIPopoverController *categoryPopover;

/** 当前选中的分类 */
@property (strong, nonatomic) XXBCategory *selectedCategory;
/** 当前选中的子分类名称 */
@property (copy, nonatomic) NSString *selectedSubCategoryName;


@property (nonatomic, strong) CLLocationManager *locMgr;
/**
 *  是否是第一次打开控制器
 */
@property(nonatomic , assign)BOOL firstOpen;
- (IBAction)backToUserLocation;
@end

@implementation XXBMapViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.firstOpen = YES;
    
    // 设置导航栏的内容
    [self setupNav];
    
    // 设置地图
    [self setupMap];
    
    // 请求定位
    [self setupCLLocationManager];
}


- (void)setupCLLocationManager
{
    // 开始定位用户的位置
    [self.locMgr startUpdatingLocation];
    [self.locMgr requestAlwaysAuthorization];
}

/**
 *  设置导航栏的内容
 */
- (void)setupNav
{
    self.title = @"地图";
    // 左边的返回
    UIBarButtonItem *backItem = [UIBarButtonItem itemWithImageName:@"icon_back" highImageName:@"icon_back_highlighted" target:self action:@selector(back)];
    
    // 分类菜单
    self.selectedCategory = [[XXBMetaDataTool sharedMetaDataTool].categories firstObject];
    XXBDealsTopMenu *categoryMenu = [XXBDealsTopMenu menu];
    categoryMenu.titleLabel.text = self.selectedCategory.name;
    categoryMenu.imageButton.image = self.selectedCategory.icon;
    categoryMenu.imageButton.highlightedImage = self.selectedCategory.highlighted_icon;
    [categoryMenu addTarget:self action:@selector(categoryMenuClick)];
    UIBarButtonItem *categoryItem = [[UIBarButtonItem alloc] initWithCustomView:categoryMenu];
    
    self.categoryMenu = categoryMenu;
    self.navigationItem.leftBarButtonItems = @[backItem, categoryItem];
    
    // 监听通知
    XXBAddObsver(categoryDidSelect:, XXBCategoryDidSelectNotification);

}
- (void)dealloc
{
    XXBRemoveObsver;
}
/**
 *  设置地图的代理
 */
- (void)setupMap
{
    self.mapView.delegate = self;
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
}
#pragma mark - 地图的代理的处理
/**
 *  用户的位置获得更新的时候
 *
 *  @param mapView      mapView
 *  @param userLocation 用户的位置的相关信息
 */
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (self.firstOpen)
    {
        self.firstOpen = NO;
        /**
         *  设置地图的现实区域
         */
        CLLocationCoordinate2D center = userLocation.location.coordinate;
        MKCoordinateSpan span = MKCoordinateSpanMake(0.1,0.1);
        MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
        [mapView setRegion:region animated:YES];
        /**
         *  设置中心点
         */
        //    [mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    }
    /**
     *  获取城市名称
     */
    [self.geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count == 0)
            return;
        CLPlacemark *placemark = [placemarks firstObject];
        NSString *city = placemark.addressDictionary[@"City"];
        self.cityName = [city substringToIndex:city.length - 1];
        
        self.cityName = [self nameOfChinese:self.cityName];
        // 定位到城市，就发送请求
        [self mapView:self.mapView regionDidChangeAnimated:YES];
    }];
}
/**
 *  mapView的位置变化的时候(mapView滚动的时候)
 *
 *  @param mapView  mapView
 *  @param animated 是否需要动画
 */
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    // 城市为空的话不进行任何操作
    if (self.cityName == nil || self.isDealingDeals)
        return;
    self.dealingDeals = YES;
    XXBFindDealsParam *params = [[XXBFindDealsParam alloc] init];
    CLLocationCoordinate2D center = mapView.region.center;
    params.latitude = @(center.latitude);
    params.longitude = @(center.longitude);
    params.city = self.cityName;
    params.radius = @(5000);
    params.category = self.selectedSubCategoryName;
    // 2.发送请求给服务器
    [XXBDealTool findDeals:params success:^(XXBFindDealsResult *result) {
        [self setupDeals:result.deals];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"加载团购失败，请稍后再试" toView:self.mapView];
        self.dealingDeals = NO;
    }];
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(XXBDealAnnotation *)annotation
{
    if (![annotation isKindOfClass:[XXBDealAnnotation class]]) return nil;
    
    static NSString *ID = @"deal";
    XXBDealAnnoRightButton *rightBtn = nil;
    MKAnnotationView *annoView = [mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (annoView == nil)
    {
        annoView = [[MKPinAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:ID];
        // 显示标题和标题
        annoView.canShowCallout = YES;
        rightBtn = [XXBDealAnnoRightButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightBtn addTarget:self action:@selector(dealClick:)];
        annoView.rightCalloutAccessoryView = rightBtn;
    }
    else
    { // annoView是从缓存池取出来
        rightBtn = (XXBDealAnnoRightButton *)annoView.rightCalloutAccessoryView;
    }
    
    // 覆盖模型数据
    annoView.annotation = annotation;
    // 设置图标
    if ([self.selectedCategory.name isEqualToString:@"全部分类"]) {
        NSString *category = [annotation.deal.categories firstObject];
        NSString *mapIcon = [[XXBMetaDataTool sharedMetaDataTool] categoryWithName:category].map_icon;
        annoView.image = [UIImage imageNamed:mapIcon];
    } else { // 特定的类别¸
        annoView.image = [UIImage imageNamed:self.selectedCategory.map_icon];
    }
    rightBtn.deal = annotation.deal;
    
    return annoView;
}
/**
 *  处理团购数据
 */
- (void)setupDeals:(NSArray *)deals
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (XXBDeal *deal in deals) {
            for (XXBBusiness *business in deal.businesses) {
                XXBDealAnnotation *anno = [[XXBDealAnnotation alloc] init];
                anno.coordinate = CLLocationCoordinate2DMake(business.latitude, business.longitude);
                anno.title = deal.title;
                anno.subtitle = business.name;
                // 设置大头针对应的团购模型
                anno.deal = deal;
                
                // 说明这个大头针已经存在这个数组中（已经显示过了）
                if ([self.mapView.annotations containsObject:anno]) continue;
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self.mapView addAnnotation:anno];
                });
            }
        }
        
        self.dealingDeals = NO;
    });
}
/**
 *  处理详情的点击事件
 *
 *  @param clickedButton 点击的详情的按钮
 */
- (void)dealClick:(XXBDealAnnoRightButton *)clickedButton
{
    // 弹出详情控制器
    XXBDealDetailViewController *detailVc = [[XXBDealDetailViewController alloc] init];
    detailVc.deal = clickedButton.deal;
    [self presentViewController:detailVc animated:YES completion:nil];
}
/**
 *  返回按钮
 */
- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
/**
 *  分类菜单的点击事件
 */
- (void)categoryMenuClick
{
    XXBCategoriesViewController *cs = (XXBCategoriesViewController *)self.categoryPopover.contentViewController;
    cs.selectedCategory = self.selectedCategory;
    cs.selectedSubCategoryName = self.selectedSubCategoryName;
    
    [self.categoryPopover presentPopoverFromRect:self.categoryMenu.bounds inView:self.categoryMenu permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
/**
 *  返回用户的位置
 */
- (IBAction)backToUserLocation {
    [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
}
/**
 *  处理菜单选中事件
 */
- (void)categoryDidSelect:(NSNotification *)note
{
    // 取出通知中的数据
    self.selectedCategory = note.userInfo[XXBSelectedCategory];
    self.selectedSubCategoryName = note.userInfo[XXBSelectedSubCategoryName];
    if (self.selectedSubCategoryName == nil)
    {
        self.selectedSubCategoryName = self.selectedCategory.name;
    }
    // 设置菜单数据
    self.categoryMenu.imageButton.image = self.selectedCategory.icon;
    self.categoryMenu.imageButton.highlightedImage = self.selectedCategory.highlighted_icon;
    self.categoryMenu.titleLabel.text = self.selectedCategory.name;
    self.categoryMenu.subtitleLabel.text = self.selectedSubCategoryName;
    
    // 关闭popover
    [self.categoryPopover dismissPopoverAnimated:YES];
    
    // 清空所有的大头针
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    // 加载最新的数据
    [self mapView:self.mapView regionDidChangeAnimated:YES];
}

#pragma mark - 懒加载
- (CLGeocoder *)geocoder
{
    if (_geocoder == nil) {
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        _geocoder = geocoder;
    }
    return _geocoder;
}
- (UIPopoverController *)categoryPopover
{
    if (_categoryPopover == nil) {
        XXBCategoriesViewController *cv = [[XXBCategoriesViewController alloc] init];
        self.categoryPopover = [[UIPopoverController alloc] initWithContentViewController:cv];
    }
    return _categoryPopover;
}
/**
 *  懒加载
 */
- (CLLocationManager *)locMgr
{
#warning 定位服务不可用
    if(![CLLocationManager locationServicesEnabled])
    {
        /**
         只有系统的定位功能是关闭的时候才会调用这个方法
         */
        return nil;
    }
    
    if (!_locMgr)
    {
        // 创建定位管理者
        self.locMgr = [[CLLocationManager alloc] init];
        // 设置代理
        self.locMgr.delegate = self;
    }
    return _locMgr;
}
- (NSString *)nameOfChinese:(NSString *)name
{
    // 根据搜索条件进行过滤
    NSArray *allCities = [XXBMetaDataTool sharedMetaDataTool].cities;
    
    // 将搜索条件转为小写
    NSString *lowerSearchText = name.lowercaseString;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name.lowercaseString contains %@ or pinYin.lowercaseString contains %@ or pinYinHead.lowercaseString contains %@", lowerSearchText, lowerSearchText, lowerSearchText];
    NSArray *resultCities = [allCities filteredArrayUsingPredicate:predicate];
    if (resultCities.count > 0) {
        return [resultCities[0] name];
    }
    return  name;
}
@end
