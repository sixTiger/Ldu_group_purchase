//
//  XXBDealListViewController.m
//  Ldu_group_purchase
//
//  Created by Jinhong on 15/1/15.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import "XXBDealListViewController.h"
#import "XXBDealCell.h"
#import "XXBDealDetailViewController.h"
#import "XXBEmptyView.h"

@interface XXBDealListViewController ()<XXBDealCellDelegate>
/** 没有数据时显示的view */
@property (nonatomic, weak) XXBEmptyView *emptyView;

@end

@implementation XXBDealListViewController

#pragma mark - 懒加载
- (NSMutableArray *)deals
{
    if (_deals == nil) {
        self.deals = [NSMutableArray array];
    }
    return _deals;
}

- (XXBEmptyView *)emptyView
{
    if (_emptyView == nil) {
        XXBEmptyView *emptyView = [XXBEmptyView emptyView];
        emptyView.image = [UIImage imageNamed:self.emptyIcon];
        [self.view insertSubview:emptyView belowSubview:self.collectionView];
        self.emptyView = emptyView;
    }
    return _emptyView;
}

#pragma mark - 初始化
- (id)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // cell的尺寸
    layout.itemSize = CGSizeMake(305, 305);
    return [super initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupBaseView];
}
/**
 *  设置控制器view属性
 */
- (void)setupBaseView
{
    // 设置颜色
    self.collectionView.backgroundColor = [UIColor clearColor];
    // 垂直方向上永远有弹簧效果
    self.collectionView.alwaysBounceVertical = YES;
    self.view.backgroundColor = XXBGlobalBg;
    /**
     *  注册cell 因为所有的cell长得都一样，所以才在父类中注册
     */
    [self.collectionView registerNib:[UINib nibWithNibName:@"XXBDealCell" bundle:nil] forCellWithReuseIdentifier:@"deal"];
}

#pragma mark - 应该要在：即将显示view的时候，根据屏幕方向调整cell的间距
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupLayout:self.view.width orientation:self.interfaceOrientation];
    
    
}
#pragma mark - 处理屏幕的旋转
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
#warning 这里要注意：由于是即将旋转，最后的宽度就是现在的高度
    // 总宽度 根据屏幕算的话会有64 的误差   CGFloat totalWidth = self.view.height
    CGFloat totalWidth = self.view.height > 800?1024:768 ;
    [self setupLayout:totalWidth orientation:toInterfaceOrientation];
}

/**
 *  调整布局
 *
 *  @param totalWidth 总宽度
 *  @param orientation 显示的方向
 */
- (void)setupLayout:(CGFloat)totalWidth orientation:(UIInterfaceOrientation)orientation
{
    // 总列数
    int columns = UIInterfaceOrientationIsPortrait(orientation) ? 2 : 3;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    // 每一行的最小间距
    CGFloat lineSpacing = 25;
    // 每一列的最小间距 为了适配 iPadAir 减 1
    CGFloat interitemSpacing = (totalWidth - columns * layout.itemSize.width) / (columns + 1) ;
    //NSLog(@"%lf  %d  %lf",interitemSpacing ,columns ,totalWidth);
    layout.minimumInteritemSpacing = interitemSpacing;
    layout.minimumLineSpacing = lineSpacing;
    // 设置cell与CollectionView边缘的间距
    layout.sectionInset = UIEdgeInsetsMake(lineSpacing, interitemSpacing, lineSpacing, interitemSpacing);
}

#pragma mark - 数据源方法
#warning 如果要在数据个数发生的改变时做出响应，那么响应操作可以考虑在数据源方法中实现
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
#warning 控制emptyView的可见性
    self.emptyView.hidden = (self.deals.count > 0);
    return self.deals.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XXBDealCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"deal" forIndexPath:indexPath];
    cell.delegate = self;
    cell.deal = self.deals[indexPath.item];
    return cell;
}

#pragma mark - 代理方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 弹出详情控制器
    XXBDealDetailViewController *detailVc = [[XXBDealDetailViewController alloc] init];
    detailVc.deal = self.deals[indexPath.item];
    [self presentViewController:detailVc animated:YES completion:nil];
}

@end
