
//
//  LockTestViewController.m
//  CityJinFu
//
//  Created by 姜姜敏 on 16/9/27.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "LockTestViewController.h"
#import "LockTestView.h"

@interface LockTestViewController ()

@property (nonatomic, strong) LockTestView *lockTestView;

@property (nonatomic, assign) NSInteger click;

@end

@implementation LockTestViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //背景图片
    UIImageView *backgroundImageView = [[UIImageView alloc] init];
    backgroundImageView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    backgroundImageView.userInteractionEnabled = YES;
    backgroundImageView.image = [UIImage imageNamed:@"gestureLock"];
    backgroundImageView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:backgroundImageView];
    
    _lockTestView = [[LockTestView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _lockTestView.backgroundColor = [UIColor clearColor];
    _lockTestView.clipTag = @"1";
    _lockTestView.clipTag = @"1";
    if (self.tag != 0) {
        _lockTestView.clipTag = @"5";
    }
    _lockTestView.isCloseProtect = self.isCloseProtect;
    [backgroundImageView addSubview:_lockTestView];
    
    self.click = 0;
    
}

- (void)leftButtonAction {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    //隐藏导航栏的分割线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    self.navigationController.navigationBar.hidden = YES;
    
    self.titleLabel.text = @"手势密码验证";
    
    [self.view bringSubviewToFront:self.backButton];
    [self.view bringSubviewToFront:self.titleLabel];

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

@end
