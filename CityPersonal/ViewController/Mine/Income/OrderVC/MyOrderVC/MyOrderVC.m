//
//  MyOrderVC.m
//  CityJinFu
//
//  Created by mic on 2017/6/5.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "MyOrderVC.h"

@interface MyOrderVC ()

@property (nonatomic, strong) NSString *count;//统计未完成订单的数量

@end

@implementation MyOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Colorful(235, 234, 241);
    [TitleLabelStyle addtitleViewToVC:self withTitle:@"我的订单"];
    //左边按钮
    UIButton *leftButton = [Factory addLeftbottonToVC:self];//左边的按钮
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];

    //添加子控制器
    [self addChildVC];
}

/**
 *添加子控制器
 */
- (void)addChildVC{
    //未完成
    _unFinishedVC = [UnFinishOrderVC new];
    _unFinishedVC.title = @"未完成";
    //已完成
    _finishedVC = [FinishOrderVC new];
    _finishedVC.title = @"已完成";
    
    _fatherVC = [FatherVC new];
    //数组
    NSArray *subViewControllers = @[_unFinishedVC, _finishedVC];
    _fatherVC = [[FatherVC alloc]initWithSubViewControllers:subViewControllers];
    _fatherVC.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
    [self.view addSubview:_fatherVC.view];
    [self addChildViewController:_fatherVC];
}
/**
 *  返回
 */
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    //隐藏tabBar
    [Factory hidentabar];
}
@end
