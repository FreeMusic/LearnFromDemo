//
//  ClipActivityController.m
//  CityJinFu
//
//  Created by 姜姜敏 on 16/10/20.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "ClipActivityController.h"
#import "ClipActivityCell.h"
#import "SGAdvertScrollView.h"
#import "SGHelperTool.h"
#import "TopScrollPicture.h"
#import "MessageVC.h"
#import "DescribeJinFuVC.h"
#import "NoticeLIstModel.h"
#import "NoticeListsVC.h"
#import "SDCycleScrollView.h"
#import "ActivityCenterVC.h"
#import "MJExtension.h"
#import "IphoneVC.h"
#import "IntegralShopVC.h"
#import "VipVC.h"
#import "NoticeListsVC.h"

@interface ClipActivityController ()<UITableViewDelegate, UITableViewDataSource, SGAdvertScrollViewDelegate,SDCycleScrollViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) NSArray *imageDataArray;
@property (nonatomic, weak) UIView *navLine;
@property (nonatomic, assign) CGFloat bannerHeight;
@end

@implementation ClipActivityController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backGroundColor;
    [self.view addSubview:self.tableView];
    _bannerHeight = 510*m6Scale;
    //用户在绑定银行卡之后，接受预提示用户风险评估的消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alterUserRiskTest) name:@"alterUserRiskTest" object:nil];
}
- (NSArray *)imageDataArray{
    if (!_imageDataArray) {
        _imageDataArray = [[NSArray alloc]init];
    }
    return _imageDataArray;
}
#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = SeparatorColor;
        _tableView.bounces = NO;
        
        _tableView.sectionFooterHeight = 0;
        _tableView.sectionHeaderHeight = 20*m6Scale;
        _tableView.contentInset = UIEdgeInsetsMake(-NavigationBarHeight+19, 0, 0, 0);
    }
    return _tableView;
}

/**
 广告滚动页
 */
- (SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, _bannerHeight) delegate:self placeholderImage:[UIImage imageNamed:@"750x350"]];
    }
    return _cycleScrollView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
#pragma mark - tableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 1;
    }else if (section == 2){
        return 2;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section){
        static NSString *str = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1];
        cell.textLabel.font = [UIFont systemFontOfSize:30*m6Scale];
        NSArray *textArr  = @[@"公司介绍",@"项目信息", @"运营数据"];
        NSArray *picArr = @[@"jieshao",@"xiangmu",@"yunying"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.section == 1) {
            cell.textLabel.text = textArr[indexPath.row];
            cell.imageView.image = [UIImage imageNamed:picArr[indexPath.row]];
        }else{
            cell.textLabel.text = textArr[indexPath.row+1];
            cell.imageView.image = [UIImage imageNamed:picArr[indexPath.row+1]];
        }
        return cell;
    }else{
        ClipActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"clipActivity"];
        if (!cell) {
            
            cell = [[ClipActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"clipActivity"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
}
#pragma mark -didSelectRowAtIndexPath
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        //公司介绍
//        DescribeJinFuVC *descri = [DescribeJinFuVC new];
//        [self.navigationController pushViewController:descri animated:YES];
        [self messageDisclosure:@"公司介绍"];
    }else if (indexPath.section == 2){
        if (indexPath.row) {
            //运营信息
            [self messageDisclosure:@"运营数据"];
        }else{
            //项目信息
           [self messageDisclosure:@"项目信息"];
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section) {
        return 102*m6Scale;
    }else{
        return 336*m6Scale;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section) {
        return 20*m6Scale;
    }else{
        return 72*m6Scale+_bannerHeight;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section) {
        return nil;
    }else{
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 72*m6Scale+_bannerHeight)];
        [self.view addSubview:view];
        [view addSubview:self.cycleScrollView];
        [DownLoadData postActivityList:^(id obj, NSError *error) {
            
            self.imageDataArray = obj[@"pictureList"];
            
            NSMutableArray *mutableArray = [NSMutableArray array];
            if (self.imageDataArray.count) {
                [self.imageDataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString *imageUrl = obj[@"picturePath"];
                    [mutableArray addObject:imageUrl];
                }];
                self.cycleScrollView.imageURLStringsGroup = mutableArray;
            }
        }];
        //公告
        SGAdvertScrollView *advertScrollView = [[SGAdvertScrollView alloc] init];
        advertScrollView.advertScrollViewDelegate = self;
        advertScrollView.backgroundColor = backGroundColor;
        advertScrollView.frame = CGRectMake(0, 750*m6Scale/kScreenWidth*_bannerHeight, kScreenWidth, 72*m6Scale+_bannerHeight-750*m6Scale/kScreenWidth*_bannerHeight);
        advertScrollView.image = [UIImage imageNamed:@"horn_icon"];
        [DownLoadData postGetNoticeList:^(id obj, NSError *error) {
            NSArray *arr = obj[@"SUCCESS"];
            NSMutableArray *mutaArr = [NSMutableArray array];
            for (int i = 0; i < arr.count; i++) {
                NoticeLIstModel *model = arr[i];
                [mutaArr addObject:model.name];
            }
            advertScrollView.titleArray = mutaArr;
            advertScrollView.titleFont = [UIFont systemFontOfSize:28*m6Scale];
            advertScrollView.advertScrollViewDelegate = self;
            [view addSubview:advertScrollView];
        }];
        
        return view;
    }
}

/**
 项目信息  运营信息
 */
- (void)messageDisclosure:(NSString *)title{
    ActivityCenterVC *activity = [ActivityCenterVC new];
    activity.tag = 7;
    activity.urlName = title;//名称
    if ([title isEqualToString:@"运营数据"]) {
        activity.strUrl = [NSString stringWithFormat:@"%@/html/operationData.html",Localhost];//路径
    }else if([title isEqualToString:@"项目信息"]){
        activity.strUrl = [NSString stringWithFormat:@"%@/html/itemInformation.html",Localhost];//路径
    }else{
        activity.strUrl = [NSString stringWithFormat:@"%@/html/companyIntroduction.html",Localhost];//路径
    }
    [self.navigationController pushViewController:activity animated:YES];
}

/**
 轮播图点击事件
 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    ActivityCenterVC *activity = [ActivityCenterVC new];
    activity.tag = 2;
    TopScrollPicture *dataModel = [TopScrollPicture mj_objectWithKeyValues:self.imageDataArray[index]];
    if (![dataModel isKindOfClass:[NSString class]]) {
        activity.strUrl = dataModel.pictureUrl;//链接路径
        activity.urlName = dataModel.pictureName;//广告业名称
        if (dataModel.isNeedLogin.integerValue) {
            //需要登录
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
                }else if (dataModel.pictureUrl == nil || [dataModel.pictureUrl isEqualToString:@"(null)"] || [dataModel.pictureUrl isEqual:[NSNull null]] || [dataModel.pictureUrl isEqualToString:@""]){
                    
                }else{
                    [self.navigationController pushViewController:activity animated:YES];
                }
            }else{
                [Factory alertMes:@"请您先登录"];
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
    
}

/**
 *<SGAdvertScrollViewDelegate>(公告列表的点击事件)
 */
- (void)advertScrollView:(SGAdvertScrollView *)advertScrollView didSelectedItemAtIndex:(NSInteger)index{
    //公告列表
    NoticeListsVC *tempVC = [[NoticeListsVC alloc] init];
    
    [self.navigationController pushViewController:tempVC animated:YES];
}
/**
 *用户在绑定银行卡之后，接受预提示用户风险评估的消息
 */
- (void)alterUserRiskTest{
    NSNotification *notification = [[NSNotification alloc] initWithName:@"sxyRealName" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    self.leveyTabBarController.selectedIndex = 3;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    //navigationBar延展性并设置透明
    //隐藏导航栏的分割线
    self.navigationController.navigationBar.translucent = YES;
    UIImage *colorImage = [Factory imageWithColor:[UIColor clearColor] size:CGSizeMake(self.view.frame.size.width, 0.001)];
    [self.navigationController.navigationBar setBackgroundImage:colorImage forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setShadowImage:[Factory imageWithColor:[UIColor clearColor] size:CGSizeMake(self.view.frame.size.width, 0.001)]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [Factory showTabar];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     self.navigationController.navigationBar.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    UIImage *colorImage = [Factory imageWithColor:[UIColor clearColor] size:CGSizeMake(self.view.frame.size.width, 0.5)];
    [self.navigationController.navigationBar setBackgroundImage:colorImage forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setShadowImage:[Factory imageWithColor:[UIColor colorWithWhite:0.5 alpha:1] size:CGSizeMake(self.view.frame.size.width, 0.5)]];
}
@end
