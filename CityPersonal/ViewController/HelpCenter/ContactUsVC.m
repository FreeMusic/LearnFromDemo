//
//  ContactUsVC.m
//  CityJinFu
//
//  Created by hanling on 16/9/30.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "ContactUsVC.h"

@implementation ContactUsVC


- (void) viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backGroundColor;
    //标题
    [TitleLabelStyle addtitleViewToVC:self withTitle:@"联系我们"];
    //左边按钮
    UIButton *leftButton = [Factory addLeftbottonToVC:self];
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    //地图
    UIImageView *firstImg = [[UIImageView alloc] initWithFrame:CGRectMake(25 * m6Scale, 18 * m6Scale, 700 * m6Scale, 666 * m6Scale)];
    firstImg.image = [UIImage imageNamed:@"地图"];
    firstImg.clipsToBounds = YES;
    [self.view addSubview:firstImg];
    //信息
    UIImageView *secondImg = [[UIImageView alloc] initWithFrame:CGRectMake(25 * m6Scale, 700 * m6Scale, 700 * m6Scale, 420 * m6Scale)];
    secondImg.image = [UIImage imageNamed:@"信息"];
    secondImg.clipsToBounds = YES;
    [self.view addSubview:secondImg];
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
    [Factory hidentabar];//隐藏tabar
    [Factory navgation:self];
    //取消navigationBar延展性并设置透明
    self.navigationController.navigationBar.translucent = NO;
    
    //隐藏导航栏的分割线
    
}
@end
