//
//  MywelfareVC.m
//  CityJinFu
//
//  Created by xxlc on 16/8/22.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "MywelfareVC.h"
#import "RedVC.h"
#import "CardVolumeVC.h"
#import "FinancialGoldVC.h"
#import "MySXTitleLable.h"
#import "ActivityVC.h"
#import "WelfareFatherVC.h"

@interface MywelfareVC ()<UIScrollViewDelegate>

@end

@implementation MywelfareVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backGroundColor;
    //标题
    [TitleLabelStyle addtitleViewToVC:self withTitle:@"我的福利"];
    //导航设置
    self.navigationController.navigationBar.translucent = NO;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.navigationController.navigationBar.barTintColor = navigationColor;
    //左边按钮
    UIButton *leftButton = [Factory addLeftbottonToVC:self];//左边的按钮
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    //添加子控制器
    [self addController];
    
    //进入我的福利页面  首先默认选择的是红包
    if (self.coupon) {
        [self couponSelected];
    }
}

/**
 *  进入我的福利页面  首先默认选择的是红包
 */
- (void)couponSelected{
    
    [DownLoadData postReadReward:^(id obj, NSError *error) {
        
    } userId:[HCJFNSUser stringForKey:@"userId"] key:@"coupon"];
    
}

/**
 *  返回
 */
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}
/** 添加子控制器 */
- (void)addController
{
    //红包
    RedVC *redVC = [RedVC new];
    redVC.title = @"红包";
    //卡券
    CardVolumeVC *cardVolumeVC = [CardVolumeVC new];
    cardVolumeVC.title = @"卡券";
    //体验金
    FinancialGoldVC *financialGoldVC = [FinancialGoldVC new];
    financialGoldVC.title = @"体验金";
    //数组
    NSArray *subViewControllers = @[redVC, cardVolumeVC, financialGoldVC];
    WelfareFatherVC *fatherVC = [[WelfareFatherVC alloc]initWithSubViewControllers:subViewControllers];
    fatherVC.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
    [fatherVC setButtonPoint:_coupon ticket:_ticket experienceGold:_experienceGold];
    
    [self.view addSubview:fatherVC.view];
    [self addChildViewController:fatherVC];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    //导航设置
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = navigationColor;
    [Factory hidentabar];//隐藏tabar
    [Factory navgation:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
