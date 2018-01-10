//
//  GuideVC.m
//  CityJinFu
//
//  Created by hanling on 16/10/11.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "GuideVC.h"
#import "RegisterViewController.h"

@interface GuideVC ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *bottomImg;
@property (nonatomic, strong) UIImageView *bottomImgRegister;
@property (nonatomic, strong) UIScrollView *myScroll;


@end
@implementation GuideVC

- (void) viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    //导航设置
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = navigationColor;
    //标题
    [TitleLabelStyle addtitleViewToVC:self withTitle:@"新手指引"];
    //左边按钮
    UIButton *leftButton = [Factory addLeftbottonToVC:self];//左边的按钮
    [leftButton addTarget:self action:@selector(clickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    
    //myScroll
    self.myScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - NavigationBarHeight)];
    self.myScroll.delegate = self;
    self.myScroll.contentSize = CGSizeMake(kScreenWidth, 3992 * m6Scale);
    self.myScroll.showsVerticalScrollIndicator = NO;
    self.myScroll.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.myScroll];
    //长背景
    self.bottomImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 3992 * m6Scale)];
    self.bottomImg.image = [UIImage imageNamed:@"长背景"];
    [self.myScroll addSubview:self.bottomImg];
    self.bottomImg.userInteractionEnabled = YES;
    //立即注册
    self.bottomImgRegister = [[UIImageView alloc] init];
    self.bottomImgRegister.image = [UIImage imageNamed:@"立即注册"];
    [self.bottomImg addSubview:self.bottomImgRegister];
    [self.bottomImgRegister mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bottomImg.mas_centerX);
        make.bottom.mas_equalTo(self.bottomImg.mas_bottom).mas_equalTo(-40*m6Scale);
    }];
    //添加手势
    self.bottomImgRegister.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(registerRightNow:)];
    [self.bottomImgRegister addGestureRecognizer:tap];
    //右边按钮
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 48, 40)];
    [button setImage:[UIImage imageNamed:@"分享"] forState:UIControlStateNormal];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    [button addTarget:self action:@selector(rightBtn) forControlEvents:UIControlEventTouchUpInside];
}
/**
 *  返回
 */
- (void)clickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  分享
 */
- (void)rightBtn{
    
    openShareView *openShare = [[openShareView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    openShare.strUrl =  [NSString stringWithFormat:@"http://www.hcjinfu.com/html/registerH5.html?invite=%@",self.inviteCode];
    openShare.strUrl =  @"http://mp.weixin.qq.com/s?__biz=MzAwNTY5ODA3OA==&mid=503068252&idx=1&sn=32942e2cae603be8faeb820c06e9e5c5&chksm=0310312d3467b83b923f998daa2b396a352a1a2d349df06e3e77a09d44399e0c00fada8bf62f%23rd";
    openShare.urlName = @"汇诚金服新手指引";
    openShare.bodyMessage = @"http://www.hcjinfu.com";
    [delegate.window addSubview:openShare];
    [delegate.window bringSubviewToFront:openShare];
}

//立即注册按钮点击事件
- (void)registerRightNow:(UITapGestureRecognizer *)sender
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]) {
        UIView *view;
        if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.contentColor = [UIColor grayColor];
        hud.label.text = @"您已登录，无须注册";
        hud.mode = MBProgressHUDModeText;
        hud.removeFromSuperViewOnHide = YES;
        [hud hideAnimated:YES afterDelay:1.5];
    } else {
        RegisterViewController *registerView = [[RegisterViewController alloc]init];
        
        [self presentViewController:registerView animated:YES completion:nil];
    }    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [Factory hidentabar];
    [Factory navgation:self];
}

@end
