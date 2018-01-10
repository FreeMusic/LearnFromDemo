//
//  AutoOpenViewVC.m
//  CityJinFu
//
//  Created by hanling on 16/10/10.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "AutoOpenViewVC.h"
#import "AutoBidSettingViewController.h"
#import "CreatView.h"


@interface AutoOpenViewVC ()

@end
@implementation AutoOpenViewVC



- (void) viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    //导航设置
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = navigationColor;
    //标题
    [TitleLabelStyle addtitleViewToVC:self withTitle:@"自动投标"];
    //左边按钮
    UIButton *leftButton = [Factory addLeftbottonToVC:self];//左边的按钮
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    //背景图片
    UIImageView * myImg = [[UIImageView alloc] init];
    myImg.image = [UIImage imageNamed:@"自动投标背景"];
    [self.view addSubview:myImg];
    [myImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(120 * m6Scale);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth * 0.7, kScreenWidth * 0.62));
    }];
    //label
    UILabel *autolabel = [UILabel new];
    autolabel.text = @"开启自动投标，帮你顺利抢标";
    autolabel.textColor = textFieldColor;
    autolabel.font = [UIFont systemFontOfSize:36*m6Scale];
    [self.view addSubview:autolabel];
    [autolabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.equalTo(myImg.mas_bottom).offset(-20*m6Scale);
        make.height.mas_equalTo(@(30*m6Scale));
    }];
    //自动投标按钮
    UIButton * sureBtn = [[UIButton alloc] init];
    sureBtn.layer.cornerRadius = 4.0;
    sureBtn.backgroundColor = [UIColor colorWithRed:253/255.0 green:180/255.0 blue:49/255.0 alpha:1.0];
    [sureBtn setTitle:@"开启自动投标" forState:0];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:0];
    [sureBtn addTarget:self action:@selector(changeView) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:42 * m6Scale];
    [self.view addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(myImg.mas_bottom).offset(80 * m6Scale);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(650 * m6Scale, 90 * m6Scale));
    }];
}
/**
 *  返回
 */
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}
 //蒙版的出现
- (void)changeView {
    AutoBidSettingViewController *autoBid = [AutoBidSettingViewController new];
    autoBid.isOpen = @"2";
    autoBid.itemStatus = @"1";
    NSUserDefaults *user = HCJFNSUser;//控制开关的不锁定
    [user setValue:@"0" forKey:@"autoZyy"];
    [user synchronize];
    [self.navigationController pushViewController:autoBid animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [Factory navgation:self];
    
    [Factory hidentabar];
}
@end
