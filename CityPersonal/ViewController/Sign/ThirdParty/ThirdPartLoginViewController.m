
//
//  ThirdPartLoginViewController.m
//  CityJinFu
//
//  Created by 姜姜敏 on 16/11/4.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "ThirdPartLoginViewController.h"
#import "ThirdPartLoginView.h"
#import "ThirdPartyVC.h"
#import "RegisterViewController.h"
#import "UserRegisterVC.h"
#import "UserSignVC.h"
#import "NewSignVC.h"

@interface ThirdPartLoginViewController ()

@property (nonatomic, assign) NSInteger click;

@end

@implementation ThirdPartLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    ThirdPartLoginView *thirdView = [[ThirdPartLoginView alloc] initWithFrame:CGRectMake(0, NavigationBarHeight, kScreenWidth, kScreenHeight - NavigationBarHeight)];
    
    thirdView.backgroundColor = [UIColor colorWithRed:247 / 255.0 green:247 / 255.0 blue:247 / 255.0 alpha:1];
    
    [thirdView.quickRegisterButton addTarget:self action:@selector(quickRegisteAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [thirdView.relevanceButton addTarget:self action:@selector(relevanceAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:thirdView];
}

- (void)relevanceAction:(UIButton *)button {
    
    ThirdPartyVC *thirdVC = [[ThirdPartyVC alloc] init];
    
    thirdVC.openId = self.openId;
    
    thirdVC.loginType = self.loginType;
    
    thirdVC.presentTag = self.presentTag;
    
    [self presentViewController:thirdVC animated:YES completion:nil];
}

- (void)quickRegisteAction:(UIButton *)button {
    
    NewSignVC *tempVC = [[NewSignVC alloc] init];
    [self presentViewController:tempVC animated:YES completion:nil];
//    UserRegisterVC *registerVC = [[UserRegisterVC alloc] init];
//    //registerVC.presentTag = @"3";
//    registerVC.openId = self.openId;
//    registerVC.type = self.loginType;
//    [self presentViewController:registerVC animated:YES completion:nil];
    
}

- (void)onClickLeftItem {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.titleLabel.text = @"第三方账号登录";
//    //隐藏导航栏的分割线
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
//    
//    self.navigationController.navigationBar.hidden = YES;
//    
//    if (_click == 0) {
//        
//        //创建一个导航栏
//        UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, NavigationBarHeight)];
//        
//        //隐藏导航栏的分割线
//        [navBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//        navBar.shadowImage = [[UIImage alloc] init];
//        //创建一个导航栏集合
//        UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"第三方账号登录"];
//        TitleLabelStyle *titleLabel = [[TitleLabelStyle alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
//        [titleLabel titleLabel:@"第三方账号登录" color:[UIColor whiteColor]];
//        navItem.titleView = titleLabel;
//        //在这个集合Item中添加标题，按钮
//        //style:设置按钮的风格，一共有三种选择
//        //action：@selector:设置按钮的点击事件
//        
//        //创建一个左边按钮
//        UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Back-Arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickLeftItem)];
//        left.tintColor = [UIColor whiteColor];//改变返回按钮的颜色
//        
//        //设置状态栏颜色
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
//        //设置导航栏的内容
//        //    [navItem setTitle:@"车贷宝"];
//        
//        //把导航栏集合添加到导航栏中，设置动画关闭
//        [navBar pushNavigationItem:navItem animated:NO];
//        
//        //把左右两个按钮添加到导航栏集合中去
//        [navItem setLeftBarButtonItem:left];
//        
//        
//        //将标题栏中的内容全部添加到主视图当中
//        [self.view addSubview:navBar];
//        
//        [navBar setColor:ButtonColor];
//        navBar.alphaView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, NavigationBarHeight);
//    }
//    _click ++;

    //设置状态栏颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
