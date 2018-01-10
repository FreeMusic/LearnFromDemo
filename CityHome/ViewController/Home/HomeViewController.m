//
//  HomeViewController.m
//  CityJinFu
//
//  Created by 姜姜敏 on 16/9/11.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "HomeViewController.h"
#import "ItemView.h"
#import "HomeCell.h"
#import "ItemTypeVC.h"
#import "HomeTopView.h"
#import "UINavigationBar+Other.h"
#import <LocalAuthentication/LocalAuthentication.h>//指纹
#import "InviteFriendVC.h"
#import "NewSignVC.h"
#import "TopScrollPicture.h"
#import "ActivityCenterVC.h"
#import "GuideVC.h"
#import "InstantInvestViewController.h"
#import "InsuranceVC.h"
#import "RecommendedCell.h"
#import "FooterViewCell.h"
#import "NewItemModel.h"
#import "IphoneVC.h"
#import "ItemTypeVC.h"
#import "HotActivityVC.h"
#import "SDCycleScrollView.h"
#import "MJExtension.h"
#import "IphoneVC.h"
#import "IntegralShopVC.h"
#import "VipVC.h"
#import "InviteFriedsDetailsVC.h"
#import "NewInviteFriendVC.h"

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate,FactoryDelegate,SDCycleScrollViewDelegate>
@property (nonatomic, strong) NSMutableArray *pictureArr; //banner数据
@property (nonatomic ,strong) MBProgressHUD *hud;
@property (nonatomic, strong) HomeTopView *topView;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *footer;//刷新
@property (nonatomic, strong) Reachability *conn;
@property (nonatomic, assign) CGFloat offset; //滑动偏移量
@property (nonatomic, strong) NewItemModel *itemModel;//新手标数据
@property (nonatomic,strong) NSMutableArray *dataArr;//list数组
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;//轮播图
@property (nonatomic,strong) NSMutableArray *imageModelArray;//图片信息model
@property (nonatomic, weak) UIView *navLine;
@property (nonatomic, strong) UIButton *touchBtn;
@property (nonatomic, strong) NSString *touchURL;//  点击touchButton的时候  跳转的URL地址
@property (nonatomic, strong) NSString *touchName;// 点击touchButton的时候  跳转页面的头部标题
@property (nonatomic, strong) NSString *isNeedLogin;//点击touchButton的时候  判断是否需要登录

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backGroundColor;
    
    //导航栏设置
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    //隐藏导航栏的分割线
    
    [self createView];
    
    //网络请求实时改变
    Factory *factory = [[Factory alloc]init];
    factory.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkStateChanged) name:kReachabilityChangedNotification object:nil];
    self.conn = [Reachability reachabilityForInternetConnection];
    [self.conn startNotifier];
    //启动页点击事件通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToAd) name:@"pushtoad" object:nil];
    //用户在点击banner详情页的相关按钮后  做投资操作
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UserGoToInvest) name:@"UserGoToInvest" object:nil];
    
    [[UIApplication sharedApplication].delegate.window addSubview:self.touchBtn];
    [self.touchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(120*m6Scale, 120*m6Scale));
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(kScreenHeight/2);
    }];
    
    //获取touchButton的背景图  以及点击链接
    [self getButtonIcon];
}
/**
 *  touchButton
 */
- (UIButton *)touchBtn{
    if(!_touchBtn){
        _touchBtn = [[UIButton alloc]init];
        //_touchBtn.backgroundColor=[UIColor orangeColor];
        
        _touchBtn.layer.cornerRadius = 50*m6Scale;
        
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]
                                                        
                                                        initWithTarget:self
                                                        
                                                        action:@selector(handlePan:)];
        
        [_touchBtn addGestureRecognizer:panGestureRecognizer];
        
        [_touchBtn addTarget:self action:@selector(touchButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _touchBtn;
}
/**
 网络状态监听
 */
- (void)netWorkStateChanged{
    NSInteger state = [Factory checkNetwork];
    //当有网状态下请求数据
    if (state == 1 || state == 2) {
        [self createView];
    }
}
/**
 滚动图片数字
 */
- (NSMutableArray *)pictureArr {
    if (_pictureArr == nil) {
        _pictureArr = [NSMutableArray array];
    }
    return _pictureArr;
}
/**
 广告滚动页
 */
- (SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 500 * m6Scale) delegate:self placeholderImage:[UIImage imageNamed:@"750x500"]];
        _cycleScrollView.pageControlBottomOffset = 100 * m6Scale;
    }
    
    return _cycleScrollView;
}
/**
 *list数组
 */
- (NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

/**
 轮播图的model数组
 */
- (NSMutableArray *)imageModelArray{
    if(!_imageModelArray){
        _imageModelArray = [NSMutableArray array];
    }
    return _imageModelArray;
}
- (void)createView {
    self.tableView.tableHeaderView = self.cycleScrollView;
    _topView = [[HomeTopView alloc] initWithFrame:CGRectMake(0, 400 * m6Scale, kScreenWidth, 100 * m6Scale)];
    [self refreshData];
    [self.view addSubview:self.tableView];
    
}
/**
 *  获取touchButton的背景图  以及点击链接
 */
- (void)getButtonIcon{
    
    [DownLoadData postGetFloatingPicture:^(id obj, NSError *error) {
        
        [self.touchBtn setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:obj[@"ret"][@"picturePath"]]]] forState:0];
        
        self.touchURL = [NSString stringWithFormat:@"%@", obj[@"ret"][@"pictureUrl"]];
        self.touchName = [NSString stringWithFormat:@"%@", obj[@"ret"][@"pictureName"]];
        self.isNeedLogin = [NSString stringWithFormat:@"%@", obj[@"ret"][@"isNeedLogin"]];
        
    }];
    
}
//获取数据
- (void)refreshData{
    //请求首页数据
    [DownLoadData postIndex:^(id obj, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        
        [self.imageModelArray removeAllObjects];
        //首页banner数据
        NSLog(@"%@",obj);
        self.imageModelArray = obj[@"banner"];
        if (self.imageModelArray.count) {
            //注册资金以及注册人数的赋值
            NSString *invest = [NSString stringWithFormat:@"%1.f",[obj[@"account"] doubleValue]];
            [_topView viewForTotalInvestStr:[Factory countNumAndChange :invest] TotalRegisterUserStr:obj[@"userNum"]];
            [self getImageData:self.imageModelArray];
            [self.cycleScrollView addSubview:_topView];
        }
        //新手标数据
        _itemModel = obj[@"model"];
        //首页数据列表
        self.dataArr = obj[@"list"];
        NSLog(@"%@", self.dataArr);
        
        [self.tableView reloadData];
    }];
    
    
}

/**
 根据返回的model获取到对应的图片路径以及点击事件
 
 @param modelArray model数组
 */
- (void)getImageData:(NSArray *)modelArray{
    NSMutableArray *imageArray = [[NSMutableArray alloc]init];
    for (TopScrollPicture *model in modelArray) {
        [imageArray addObject:model.picturePath];
    }
    self.cycleScrollView.imageURLStringsGroup = imageArray;
}

/**
 广告栏的点击事件
 
 @param cycleScrollView 轮播图
 @param index 索引
 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    ActivityCenterVC *activity = [ActivityCenterVC new];
    activity.tag = 2;
    TopScrollPicture *dataModel = self.imageModelArray[index];
    if (![dataModel isKindOfClass:[NSString class]]) {
        activity.strUrl = dataModel.pictureUrl;//链接路径
        activity.urlName = dataModel.pictureName;//广告业名称
        if ([dataModel.isNeedLogin intValue] == 1) {
            activity.isNeedLogin = YES;
            if ([HCJFNSUser objectForKey:@"userId"]) {
                if ([dataModel.pictureName containsString:@"锁投有礼"]) {
                    //锁投有礼
                    IphoneVC *tempVC = [IphoneVC new];
                    [self.navigationController pushViewController:tempVC animated:YES];
                }else if([dataModel.pictureName containsString:@"积分商城"]){
                    //兑吧免登陆接口
                    [DownLoadData postLogFreeUrl:^(id obj, NSError *error) {
                        IntegralShopVC *tempVC = [IntegralShopVC new];
                        tempVC.strUrl = obj[@"ret"];
                        [self.navigationController pushViewController:tempVC animated:YES];
                    } userId:[HCJFNSUser stringForKey:@"userId"] redicrect:@""];
                }else if ([dataModel.pictureName containsString:@"会员中心"]){
                    VipVC *tempVC = [VipVC new];
                    [self.navigationController pushViewController:tempVC animated:YES];
                }else if ([dataModel.pictureName containsString:@"邀请好友"]){
                    if (dataModel.pictureUrl == nil || [dataModel.pictureUrl isEqualToString:@"(null)"] || [dataModel.pictureUrl isEqual:[NSNull null]] || [dataModel.pictureUrl isEqualToString:@""]){
                        
                    }else{
                        InviteFriedsDetailsVC *tempVC = [InviteFriedsDetailsVC new];
                        tempVC.url = [NSString stringWithFormat:@"%@?userToken=%@&token=%@", dataModel.pictureUrl, [HCJFNSUser stringForKey:@"userToken"], [HCJFNSUser stringForKey:@"token"]];
                        [self.navigationController pushViewController:tempVC animated:YES];
                    }
                }
                else if (dataModel.pictureUrl == nil || [dataModel.pictureUrl isEqualToString:@"(null)"] || [dataModel.pictureUrl isEqual:[NSNull null]] || [dataModel.pictureUrl isEqualToString:@""]){
                    
                }else{
                    activity.tag = 2;
                    [self.navigationController pushViewController:activity animated:YES];
                }
            }else{
                [Factory alertMes:@"请您先登录"];
                [[UIApplication sharedApplication].delegate.window bringSubviewToFront:self.touchBtn];
            }
        }else{
            activity.isNeedLogin = NO;
            if ([dataModel.pictureName containsString:@"锁投有礼"]) {
                //锁投有礼
                IphoneVC *tempVC = [IphoneVC new];
                [self.navigationController pushViewController:tempVC animated:YES];
            }else if (dataModel.pictureUrl == nil || [dataModel.pictureUrl isEqualToString:@"(null)"] || [dataModel.pictureUrl isEqual:[NSNull null]] || [dataModel.pictureUrl isEqualToString:@""]){
                
            }else{
                [self.navigationController pushViewController:activity animated:YES];
            }
        }
    }else{
        NSLog(@"12341234");
    }
    
    [self.view addSubview:self.tableView];
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, - NavigationBarHeight, kScreenWidth, kScreenHeight - kTabBarHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
        
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 15*m6Scale;
    }
    
    return _tableView;
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
#pragma mark -numberOfSectionsInTableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}
#pragma mark -cellForRowAtIndexPath
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"itemCell"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"itemCell"];
            
            UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 143 * m6Scale)];
            NSArray *titleArr = @[@"新手福利",@"安全保护",@"信息披露",@"邀请好友"];
            NSArray *imageArr = @[@"Home_新手福利@2x (2)",@"安全保护",@"Home_信息披露",@"ItemType_邀请好友"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            for (NSInteger i = 0; i < 4; i ++) {
                
                ItemView *itemView = [[ItemView alloc] initWithFrame:CGRectMake(i * kScreenWidth / 4, 3, kScreenWidth / 4, 143 * m6Scale) normalImage:imageArr[i] selectImage:imageArr[i] title:titleArr[i]];
                itemView.button.tag = 119 + i;
                [itemView.button addTarget:self action:@selector(goDetailButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                
                [footView addSubview:itemView];
            }
            
            [cell.contentView addSubview:footView];
        }
        return cell;
    }else if(indexPath.section == 1){
        
        HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"homeCell"];
        if (!cell) {
            cell = [[HomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"homeCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell cellForModel:_itemModel];
        [cell.invistBtn addTarget:self action:@selector(invistBtn) forControlEvents:UIControlEventTouchUpInside];//新手推荐立即投资
        return cell;
    }else if(indexPath.section == 2){
        RecommendedCell *cell = [tableView dequeueReusableCellWithIdentifier:HCJF];
        if (!cell) {
            cell = [[RecommendedCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HCJF];
        }
        [cell cellForModelArray:self.dataArr];
        
        return cell;
        
    }else{
        FooterViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"zyy"];
        if (!cell) {
            cell = [[FooterViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"zyy"];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 60 * m6Scale;
    }else{
        return 23 * m6Scale;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 170 * m6Scale;
    }else if(indexPath.section == 1){
        return 540 * m6Scale;
    }else if(indexPath.section == 2){
        return 360*m6Scale;
    }else{
        return 260*m6Scale;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        ItemTypeVC *itemVC = [ItemTypeVC new];
        itemVC.itemId = [NSString stringWithFormat:@"%@",_itemModel.ID];//标ID
        itemVC.itemNameText = [NSString stringWithFormat:@"%@", _itemModel.itemName];//标名
        itemVC.itemStatus = _itemModel.itemStatus;//标的状tai
        [self.navigationController pushViewController:itemVC animated:YES];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        UIView *footerView = [UIView new];
        //竖线
        CALayer *percent = [[CALayer alloc] init];
        percent.frame = CGRectMake(30*m6Scale, 10*m6Scale, 2, 40*m6Scale);
        percent.backgroundColor = ButtonColor.CGColor;
        [footerView.layer addSublayer:percent];
        //热门推荐
        UILabel *label = [UILabel new];
        label.text = @"热门推荐";
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:26*m6Scale];
        [footerView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(footerView.mas_left).offset(50*m6Scale);
            make.centerY.equalTo(footerView.mas_centerY);
        }];
        return footerView;
    }else{
        return nil;
    }
}
/**
 新手指引、安全保护、信息披露、锁投有礼的点击事件
 */
- (void)goDetailButtonAction:(UIButton *)button {
    switch (button.tag) {
        case 119:
            [self newUser];
            
            break;
        case 120:
            [self safeActive];
            break;
        case 121:
            [self messageDisclosure];
            break;
        case 122:
            [self haveGift];
            break;
            
        default:
            break;
    }
}
/**
 新手指引
 */
- (void)newUser{
    ActivityCenterVC *activity = [ActivityCenterVC new];
    activity.tag = 7;
    activity.urlName = @"新手福利";//名称
    activity.strUrl = [NSString stringWithFormat:@"%@/html/newsWelfare.html",Localhost];//路径
    [self.navigationController pushViewController:activity animated:YES];
}
/**
 邀请好友
 */
- (void)invitFriend{
    if ([defaults objectForKey:@"userId"]) {
        InviteFriendVC *inviteVC = [[InviteFriendVC alloc] init];
        [self.navigationController pushViewController:inviteVC animated:YES];
    }else {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您尚未登录，是否立刻登录？" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NewSignVC *signVC = [[NewSignVC alloc] init];
            signVC.presentTag = @"2";
            [self presentViewController:signVC animated:YES completion:nil];
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}
/**
 安全保护
 */
- (void)safeActive{
    InsuranceVC *insuranceVC = [[InsuranceVC alloc] init];
    [self.navigationController pushViewController:insuranceVC animated:YES];
}

/**
 信息披露
 */
- (void)messageDisclosure{
    ActivityCenterVC *activity = [ActivityCenterVC new];
    activity.tag = 7;
    activity.urlName = @"信息披露";//名称
    activity.strUrl = [NSString stringWithFormat:@"%@/html/yunyin.html",Localhost];//路径
    [self.navigationController pushViewController:activity animated:YES];
}
/**
 热门活动
 */
- (void)hotActivity{
    HotActivityVC *guideVC = [[HotActivityVC alloc] init];
    [self.navigationController pushViewController:guideVC animated:YES];
}
/**
 邀请好友
 */
- (void)haveGift{
    if ([defaults objectForKey:@"userId"]) {
        NewInviteFriendVC *iphone = [NewInviteFriendVC new];
        [self.navigationController pushViewController:iphone animated:YES];
    }else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您尚未登录，是否立刻登录？" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NewSignVC *signVC = [[NewSignVC alloc] init];
            signVC.presentTag = @"2";
            [self presentViewController:signVC animated:YES completion:nil];
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}
/**
 新手标立即投资
 */
- (void)invistBtn{
    if ([defaults objectForKey:@"userId"]) {
        ItemTypeVC *itemVC = [ItemTypeVC new];
        itemVC.itemStatus = _itemModel.itemStatus;//标的状态
        itemVC.itemId = [NSString stringWithFormat:@"%@",_itemModel.ID];//ID
        itemVC.itemNameText = _itemModel.itemName;//标标题
        [self.navigationController pushViewController:itemVC animated:YES];
    }else {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您尚未登录，是否立刻登录？" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NewSignVC *signVC = [[NewSignVC alloc] init];
            signVC.presentTag = @"2";
            [self presentViewController:signVC animated:YES completion:nil];
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //    [self.navigationController.navigationBar setColor:[UIColor colorWithRed:253.0 / 255.0 green:182.0 / 255.0 blue:21.0/255.0 alpha:scrollView.contentOffset.y / NavgationBarHeight]];
    
    //    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 95 * m6Scale, 44)];
    //    titleLabel.textColor = [UIColor colorWithWhite:1.0 alpha:scrollView.contentOffset.y / NavgationBarHeight];
    //    titleLabel.text = @"汇诚金服";
    //    self.navigationItem.titleView = titleLabel;
    //
    //    self.offset = scrollView.contentOffset.y;
    
}
/**
 * 调往投资页面
 */
- (void)UserGoToInvest{
    self.leveyTabBarController.selectedIndex = 1;
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    //隐藏导航栏的分割线
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    //状态栏的样式
    [[UIApplication sharedApplication].keyWindow.rootViewController setNeedsStatusBarAppearanceUpdate];
    
    NSArray *arr = self.navigationController.navigationBar.subviews;
    
    NSInteger i = 0;
    
    for (UIView *view in arr) {
        
        NSString *class = NSStringFromClass([view class]);
        
        if ([class isEqualToString:@"UIView"]) {
            
            i ++;
        }
    }
    if (i == 0) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            self.navigationController.navigationBar.alphaView = [[UIView alloc ]initWithFrame:CGRectMake(0, -NavigationBarHeight, [UIScreen mainScreen].bounds.size.width, NavigationBarHeight)];
            [self.view addSubview:self.navigationController.navigationBar.alphaView];
        });
    }
    self.navigationController.navigationBar.hidden = NO;
    [Factory showTabar];//显示
    //    [self.navigationController.navigationBar setColor:[UIColor colorWithRed:253.0 / 255.0 green:182.0 / 255.0 blue:21.0/255.0 alpha:self.offset / NavgationBarHeight]];
    
    self.navigationController.navigationBar.translucent = YES;
    UIImage *colorImage = [Factory imageWithColor:[UIColor clearColor] size:CGSizeMake(self.view.frame.size.width, 0.001)];
    [self.navigationController.navigationBar setBackgroundImage:colorImage forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setShadowImage:[Factory imageWithColor:[UIColor clearColor] size:CGSizeMake(self.view.frame.size.width, 0.001)]];
    
    [[UIApplication sharedApplication].delegate.window bringSubviewToFront:self.touchBtn];
}
/**
 广告页点击跳转
 */
- (void)pushToAd {
    ActivityCenterVC *activity = [ActivityCenterVC new];
    activity.tag = 5;
    activity.urlName = [defaults objectForKey:@"pictureName"];//名称
    activity.strUrl = [defaults objectForKey:@"pictureUrl"];//路径
    if ([HCJFNSUser objectForKey:@"userId"]) {
        if ([activity.urlName containsString:@"锁投有礼"]) {
            //锁投有礼
            IphoneVC *tempVC = [IphoneVC new];
            [self.navigationController pushViewController:tempVC animated:YES];
        }else if([activity.urlName containsString:@"积分商城"]){
            //兑吧免登陆接口
            [DownLoadData postLogFreeUrl:^(id obj, NSError *error) {
                IntegralShopVC *tempVC = [IntegralShopVC new];
                tempVC.strUrl = obj[@"ret"];
                [self.navigationController pushViewController:tempVC animated:YES];
            } userId:[HCJFNSUser stringForKey:@"userId"] redicrect:@""];
        }else if ([activity.urlName containsString:@"会员中心"]){
            VipVC *tempVC = [VipVC new];
            [self.navigationController pushViewController:tempVC animated:YES];
        }
        else if (activity.strUrl == nil || [activity.strUrl isEqualToString:@"(null)"] || [activity.strUrl isEqual:[NSNull null]] || [activity.strUrl isEqualToString:@""]){
            
        }else{
            [self.navigationController pushViewController:activity animated:YES];
        }
    }else{
        if ([activity.urlName containsString:@"锁投有礼"]) {
            //锁投有礼
            IphoneVC *tempVC = [IphoneVC new];
            [self.navigationController pushViewController:tempVC animated:YES];
        }else if (activity.strUrl == nil || [activity.strUrl isEqualToString:@"(null)"] || [activity.strUrl isEqual:[NSNull null]] || [activity.strUrl isEqualToString:@""]){
            
        }else{
            [self.navigationController pushViewController:activity animated:YES];
        }
    }
}
/**
 *  拖动TouCh事件
 */
- (void) handlePan:(UIPanGestureRecognizer*) recognizer

{
    
    CGPoint translation = [recognizer translationInView:self.view];
    
    CGFloat centerX=recognizer.view.center.x+ translation.x;
    
    CGFloat thecenter = 0;
    
    CGFloat yPoint = 0.0;
    
    recognizer.view.center=CGPointMake(centerX,
                                       
                                       recognizer.view.center.y+ translation.y);
    
    [recognizer setTranslation:CGPointZero inView:self.view];
    
    if(recognizer.state==UIGestureRecognizerStateEnded|| recognizer.state==UIGestureRecognizerStateCancelled) {
        
        if(centerX>kScreenWidth/2) {
            
            thecenter=kScreenWidth-120*m6Scale/2;
            
        }
        else{
            
            thecenter=120*m6Scale/2;
            
        }
        
        if (self.touchBtn.frame.origin.y>kScreenHeight-(48+25)) {
            yPoint = kScreenHeight-(48+25);
        }else{
            yPoint = self.touchBtn.frame.origin.y;
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            
            recognizer.view.center=CGPointMake(thecenter,
                                               
                                               yPoint);
            
        }];
        
    }
}
/**
 *  悬浮窗的点击事件
 */
- (void)touchButtonClick{
    //    if ([HCJFNSUser stringForKey:@"userId"]) {
    //        InviteFriedsDetailsVC *tempVC = [InviteFriedsDetailsVC new];
    //
    //        [self.navigationController pushViewController:tempVC animated:YES];
    //    }
    if (self.isNeedLogin.integerValue) {
        
        if ([HCJFNSUser stringForKey:@"userId"]) {
            if ([self.touchName containsString:@"锁投有礼"]) {
                //锁投有礼
                IphoneVC *tempVC = [IphoneVC new];
                [self.navigationController pushViewController:tempVC animated:YES];
            }else if([self.touchName containsString:@"积分商城"]){
                //兑吧免登陆接口
                [DownLoadData postLogFreeUrl:^(id obj, NSError *error) {
                    IntegralShopVC *tempVC = [IntegralShopVC new];
                    tempVC.strUrl = obj[@"ret"];
                    [self.navigationController pushViewController:tempVC animated:YES];
                } userId:[HCJFNSUser stringForKey:@"userId"] redicrect:@""];
            }else if ([self.touchName containsString:@"会员中心"]){
                VipVC *tempVC = [VipVC new];
                [self.navigationController pushViewController:tempVC animated:YES];
            }else if ([self.touchName containsString:@"邀请好友"]){
                if (self.touchURL == nil || [self.touchURL isEqualToString:@"(null)"] || [self.touchURL isEqual:[NSNull null]] || [self.touchURL isEqualToString:@""]){
                    
                }else{
                    InviteFriedsDetailsVC *tempVC = [InviteFriedsDetailsVC new];
                    tempVC.url = [NSString stringWithFormat:@"%@?userToken=%@&token=%@", self.touchURL, [HCJFNSUser stringForKey:@"userToken"], [HCJFNSUser stringForKey:@"token"]];
                    [self.navigationController pushViewController:tempVC animated:YES];
                }
            }
            else if (self.touchURL == nil || [self.touchURL isEqualToString:@"(null)"] || [self.touchURL isEqual:[NSNull null]] || [self.touchURL isEqualToString:@""]){
                
            }else{
                ActivityCenterVC *tempVC = [[ActivityCenterVC alloc] init];
                
                [self.navigationController pushViewController:tempVC animated:YES];
                
                tempVC.tag = 1001;
                tempVC.strUrl = self.touchURL;
                tempVC.urlName = self.touchName;
            }
            
        }else{
            
            [Factory alertMes:@"请您先登录"];
            
        }
        
    }else{
        if ([self.touchName containsString:@"锁投有礼"]) {
            //锁投有礼
            IphoneVC *tempVC = [IphoneVC new];
            [self.navigationController pushViewController:tempVC animated:YES];
        }else{
            if (self.touchURL == nil || [self.touchURL isEqualToString:@"(null)"] || [self.touchURL isEqual:[NSNull null]] || [self.touchURL isEqualToString:@""]){
                
            }else {
                ActivityCenterVC *tempVC = [[ActivityCenterVC alloc] init];
                
                [self.navigationController pushViewController:tempVC animated:YES];
                
                tempVC.tag = 1000;
                
                tempVC.strUrl = self.touchURL;
                tempVC.urlName = self.touchName;
            }
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated ];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    UIImage *colorImage = [Factory imageWithColor:[UIColor clearColor] size:CGSizeMake(self.view.frame.size.width, 0.5)];
    [self.navigationController.navigationBar setBackgroundImage:colorImage forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setShadowImage:[Factory imageWithColor:[UIColor colorWithWhite:0.5 alpha:1] size:CGSizeMake(self.view.frame.size.width, 0.5)]];
    
    [[UIApplication sharedApplication].delegate.window sendSubviewToBack:self.touchBtn];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

