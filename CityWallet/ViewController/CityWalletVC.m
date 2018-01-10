//
//  CityWalletVC.m
//  CityJinFu
//
//  Created by mic on 2017/6/8.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "CityWalletVC.h"
#import "FatherVC.h"
#import "CarVC.h"
#import "CarTradeVC.h"
#import "CarCreditVC.h"
#import "SelectedVC.h"
#import "UIView+HRExtention.h"
#import "PlanVC.h"

@interface CityWalletVC ()<UIScrollViewDelegate>

@property (nonatomic, strong) UISegmentedControl *segment;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic,strong) FatherVC *fatherVC;
@property (nonatomic,strong) SelectedVC *selected;
@property (nonatomic,strong) CarCreditVC *carCredit;
@property (nonatomic,strong) CarTradeVC *carTrade;
@property (nonatomic,strong) CarVC *car;
@property (nonatomic, strong) PlanVC *planVC;

@end

@implementation CityWalletVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backGroundColor;
    //添加子控制器
    [self addChildVC];
    //导航条上的选择条
    [self settingSegment];
    //用户在绑定银行卡之后，接受预提示用户风险评估的消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alterUserRiskTest) name:@"alterUserRiskTest" object:nil];
    
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToPlan) name:@"goToPlan" object:nil];
}
/**
 *添加子控制器
 */
- (void)addChildVC{
    //默认选择的控制器
    _selected = [SelectedVC new];
    _selected.title = @"默认";
    //车贷宝
    _carCredit = [CarCreditVC new];
    _carCredit.title = @"车贷宝";
    //车商宝
    _carTrade = [CarTradeVC new];
    _carTrade.title = @"车商宝";
    //学车宝
    _car = [CarVC new];
    _car.title = @"学车宝";
    //数组
    NSArray *subViewControllers = @[_selected, _carCredit, _carTrade,_car];
    _fatherVC = [[FatherVC alloc]initWithSubViewControllers:subViewControllers];
    _fatherVC.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
    [self.view addSubview:_fatherVC.view];
    [self addChildViewController:_fatherVC];
    //计划
    _planVC = [PlanVC new];
    [self.view addSubview:_planVC.view];
    [self addChildViewController:_planVC];
    _planVC.view.hidden = YES;
    _planVC.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
}
-(void)goToPlan{
   _segment.selectedSegmentIndex = 2;
}
/**
 *导航条上的选择条
 */
- (void)settingSegment{
    //标题
    _segment = [[UISegmentedControl alloc] initWithItems:@[@"全部", @"预约", @"锁投"]];
    _segment.backgroundColor = navigationYellowColor;
    self.navigationItem.titleView = _segment;
    //宽度设置
    _segment.width = 360*m6Scale;
    //默认选择
    _segment.selectedSegmentIndex = 0;
    //点击事件
    [_segment addTarget:self action:@selector(segmentBtnClick:) forControlEvents:UIControlEventValueChanged];
    _segment.tintColor = UIColorFromRGB(0xffffff);
    //根据点击哪个选择条来确定应该请求的数据（0-全部 1-预约 2-满标）
    [self serviceDataByselectedSegmentIndex];
}
/**
 *选择条的点击事件
 */
- (void)segmentBtnClick:(UISegmentedControl *)sender{
    
    //改变点击模块的颜色
    _segment.tintColor = UIColorFromRGB(0xffffff);
    self.scrollView.contentOffset = CGPointMake(_segment.selectedSegmentIndex * self.view.width, 0);
    if (sender.selectedSegmentIndex == 2) {
        _fatherVC.view.hidden = YES;
        _planVC.view.hidden = NO;
    }else{
        _fatherVC.view.hidden = NO;
        _planVC.view.hidden = YES;
    }
    //根据点击哪个选择条来确定应该请求的数据（0-全部 1-预约 2-满标）
    [self serviceDataByselectedSegmentIndex];
}
/**
 *根据点击哪个选择条来确定应该请求的数据（0-全部 1-预约 2-满标）
 */
- (void)serviceDataByselectedSegmentIndex{
    NSLog(@"%ld", _segment.selectedSegmentIndex);
    if (_segment.selectedSegmentIndex == 0) {
        //全部数据
        [self GetItemStatus:@"-1"];
    }else if (_segment.selectedSegmentIndex == 1){
        //预约数据
        [self GetItemStatus:@"1"];
    }
    //else{
//        //满标数据
//        [self GetItemStatus:@"20"];
//    }
}

- (void)GetItemStatus:(NSString *)status{
    _selected.itemStatus = status;
    _carCredit.itemStatus = status;
    _carTrade.itemStatus = status;
    _car.itemStatus = status;
    [_selected compareSelegentServiceData];
    [_carCredit compareSelegentServiceData];
    [_carTrade compareSelegentServiceData];
    [_car compareSelegentServiceData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [Factory showTabar];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController.navigationBar setBarTintColor:navigationYellowColor];
}

/**
 *  用户在绑定银行卡之后，接受预提示用户风险评估的消息
 */
- (void)alterUserRiskTest{
    NSNotification *notification = [[NSNotification alloc] initWithName:@"sxyRealName" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    self.leveyTabBarController.selectedIndex = 3;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
