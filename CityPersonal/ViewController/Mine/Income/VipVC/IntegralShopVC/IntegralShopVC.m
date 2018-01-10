//
//  IntegralShopVC.m
//  CityJinFu
//
//  Created by mic on 2017/7/26.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "IntegralShopVC.h"

@interface IntegralShopVC ()<UIWebViewDelegate>

//@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic ,strong) MBProgressHUD *hud;
@property (nonatomic, strong) UIView *backgroundImage;
@property (nonatomic, strong) Reachability *conn;

@end

@implementation IntegralShopVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backGroundColor;
    
    
    [TitleLabelStyle addtitleViewToVC:self withTitle:@"积分商城"];
    
    self.webView.delegate = self;
    [self loadHTML:self.strUrl];
    
    NSLog(@"2222++++%@",_strUrl);
    
}
/**
 *  返回
 */
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GoToHome" object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //导航栏设置
    self.navigationController.navigationBar.translucent = NO;
    [Factory hidentabar];//隐藏
    [Factory navgation:self];//导航
}

@end
