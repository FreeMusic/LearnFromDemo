//
//  IphoneVC.m
//  CityJinFu
//
//  Created by xxlc on 17/1/19.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "IphoneVC.h"
#import "IphoneCell.h"
#import "MyActivityViewController.h"
#import "MyiPhoneCell.h"
#import "SXYFlowlayout.h"
#import "MenuView.h"
#import "IphoneDetailsVC.h"
#import "MyOrderVC.h"
#import "MyAddressVC.h"
#import "GoodsTypeVC.h"
#import "ZJScrollPageView.h"
#import "GoodsListVC.h"

@interface IphoneVC ()<ZJScrollPageViewDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic, strong) UIView *topView;//顶部View
@property (nonatomic,strong) UILabel *headerLabel;//头部label
@property (nonatomic,strong) UIImageView *headerImgView;//头部imgView
@property (nonatomic,assign) BOOL flag;
@property (nonatomic,strong) MenuView * menuView;//筛选菜单
@property (nonatomic,strong) NSArray *titleArr;//标题数组
@property (nonatomic,strong) UIScrollView *titleScrollView;//标题滑动视图
@property (nonatomic,strong) NSMutableArray *contentArr;//商品数组
@property (nonatomic,strong) NSMutableDictionary *contentDic;//数据字典
@property (nonatomic,assign) NSInteger index;//
@property (nonatomic,strong) UIImageView *backImgView;//暂无数据背景图
@property (nonatomic,strong) NSString *typeID;//类型ID
@property (nonatomic,assign) NSInteger page;//计算刷新的页数
@property (nonatomic,strong) NSMutableArray *muArray;//上拉加载的数组
@property (nonatomic, strong) Reachability *conn;

@property(strong, nonatomic)NSArray<NSString *> *titles;
@property(strong, nonatomic)NSArray<UIViewController *> *childVcs;
@property (nonatomic, strong) ZJScrollPageView *scrollPageView;
@property (nonatomic, strong) NSMutableArray *idArray;//商品ID数组
@property (nonatomic, strong) UIViewController<ZJScrollPageViewChildVcDelegate> *childVc;

@end

@implementation IphoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Colorful(220, 220, 219);
    //左边按钮
    UIButton *leftButton = [Factory addLeftbottonToVC:self];//左边的按钮
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    
    [self serviceData];
    //接受通知  用户在商城首页点击某个类目的时候 跳转至相应的页面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sxyMoveToPage:) name:@"sxyMoveToPage" object:nil];
}
/**
 *创建标题滑动视图
 */
- (void)createTitleScrollView{
    //必要的设置, 如果没有设置可能导致内容显示不正常
    self.automaticallyAdjustsScrollViewInsets = NO;
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    //显示滚动条
    style.showLine = YES;
    // 颜色渐变
    style.gradualChangeTitleColor = YES;
    //均分
    style.autoAdjustTitlesWidth = YES;
    //滚动条的颜色
    style.scrollLineColor = UIColorFromRGB(0xff5933);
    //选中字体的颜色
    style.selectedTitleColor = UIColorFromRGB(0xff5933);
    // 初始化
    _scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, -1, kScreenWidth, kScreenHeight - NavigationBarHeight) segmentStyle:style titles:self.titles parentViewController:self delegate:self];
    
    [self.view addSubview:_scrollPageView];
}
- (void)onClickLeftItem{
    
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *商品ID数组
 */
- (NSMutableArray *)idArray{
    if(!_idArray){
        _idArray = [NSMutableArray array];
    }
    return _idArray;
}
/**
 *请求数据
 */
- (void)serviceData{
    //请求数据(锁投有礼首页商品类型)
    [DownLoadData postGetGoodsTypeList:^(id obj, NSError *error) {
        _titleArr = obj[@"lists"];
        NSMutableArray *dataSource = [NSMutableArray array];
        [dataSource addObject:@"全部产品"];
        for (int i = 0; i < _titleArr.count; i++) {
            [dataSource addObject:[NSString stringWithFormat:@"%@", _titleArr[i][@"typeName"]]];
            [self.idArray addObject:[NSString stringWithFormat:@"%@", _titleArr[i][@"id"]]];
        }
        self.titles = dataSource;
        //创建标题滑动视图
        [self createTitleScrollView];
    }];
}
- (NSInteger)numberOfChildViewControllers {
    return self.titles.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    UIViewController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    if (index) {
        if (!childVc) {
            childVc = [[GoodsTypeVC alloc] init];
        }
        NSString *tag = self.idArray[index-1];
        //根据每个产品类型的ID不同 给view赋予不同的值
        childVc.view.tag = tag.integerValue+1000;
        
        return childVc;
    }else{
        childVc = [[GoodsListVC alloc] init];
        
        return childVc;
    }
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}
/**
 *移动到相应的页面
 */
- (void)sxyMoveToPage:(NSNotification *)noti{
    NSString *index = noti.userInfo[@"index"];
    
    [_scrollPageView setSelectedIndex:index.integerValue animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [Factory hidentabar];//隐藏tabar
    [Factory navgation:self];
    //取消navigationBar延展性并设置透明
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBarTintColor:navigationColor];
    UIImage *colorImage = [Factory imageWithColor:[UIColor clearColor] size:CGSizeMake(self.view.frame.size.width, 0.5)];
    [self.navigationController.navigationBar setBackgroundImage:colorImage forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setShadowImage:[Factory imageWithColor:[UIColor colorWithWhite:0.5 alpha:1] size:CGSizeMake(self.view.frame.size.width, 0.5)]];
    
    [TitleLabelStyle addtitleViewToVC:self withTitle:@"锁投有礼"];
    
    [self.navigationController.navigationBar setBackgroundImage:[Factory navgationImage] forBarMetrics:UIBarMetricsDefault];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

@end
