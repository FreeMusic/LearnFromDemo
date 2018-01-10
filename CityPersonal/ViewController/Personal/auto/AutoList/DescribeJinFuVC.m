//
//  DescribeJinFuVC.m
//  CityJinFu
//
//  Created by hanling on 16/9/27.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "DescribeJinFuVC.h"
#import <JavaScriptCore/JavaScriptCore.h>


@interface DescribeJinFuVC ()
@property (nonatomic, strong) UIWebView *webView;//web

@property (nonatomic, strong) UIImageView *bottomImg;

@end

@implementation DescribeJinFuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //标题
    [TitleLabelStyle addtitleViewToVC:self withTitle:@"公司介绍"];
    //左边按钮
    UIButton *leftButton = [Factory addLeftbottonToVC:self];//左边的按钮
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.bottomImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 40*m6Scale, 1000*m6Scale)];
    self.bottomImg.image = [UIImage imageNamed:@"关于汇诚-背景"];
    self.bottomImg.clipsToBounds = YES;
    [self.view addSubview:self.bottomImg];
    
//    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 65 )];
//    self.webView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:self.webView];
//    [self addWeb];

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
    [Factory hidentabar];
    [Factory navgation:self];
    self.navigationController.navigationBar.barTintColor = navigationColor;
    //navigationBar延展性并设置透明
    self.navigationController.navigationBar.translucent = NO;
    //隐藏导航栏的分割线
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
