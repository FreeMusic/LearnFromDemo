//
//  ExchangeNowVC.m
//  CityJinFu
//
//  Created by hanling on 16/10/8.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "ExchangeNowVC.h"
#import "ExchangeNowView.h"
#import "AppDelegate.h"

@interface ExchangeNowVC ()

@end
@implementation ExchangeNowVC
- (void) viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //导航设置
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = navigationColor;
    //标题
    [TitleLabelStyle addtitleViewToVC:self withTitle:@"立即兑换"];
    //左边按钮
    UIButton *leftButton = [Factory addLeftbottonToVC:self];//左边的按钮
    [leftButton addTarget:self action:@selector(clickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    
    ExchangeNowView *exchangeNowView = [[ExchangeNowView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - NavigationBarHeight)];
    [exchangeNowView.leftBtn addTarget:self action:@selector(exchangeSuccessAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exchangeNowView];
}

/**
 *  返回
 */
- (void)clickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  兑换成功
 */
- (void)exchangeSuccessAction:(UIButton *)button {
    
    //背景阴影视图
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    backView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.window addSubview:backView];
    
    UIView *successView = [[UIView alloc] init];
    successView.backgroundColor = [UIColor whiteColor];
    successView.layer.cornerRadius = 10 * m6Scale;
    [backView addSubview:successView];
    
    [successView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(backView.mas_centerX);
        make.centerY.equalTo(backView.mas_centerY).offset(- 50 * m6Scale);
        make.size.mas_equalTo(CGSizeMake(560 * m6Scale, 310 * m6Scale));
    }];
    
    UIImageView *successImageView = [[UIImageView alloc] init];
    successImageView.image = [UIImage imageNamed:@"exchangeSuccess"];
    [successView addSubview:successImageView];
    
    [successImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(successView.mas_centerX);
        make.top.equalTo(successView.mas_top);
        make.size.mas_equalTo(CGSizeMake(440 * m6Scale, 230 * m6Scale));
    }];
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.font = [UIFont systemFontOfSize:27 * m6Scale];
    textLabel.text = @"(3秒后跳到红包页面)";
    [successView addSubview:textLabel];
    
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(successView.mas_centerX);
        make.top.equalTo(successImageView.mas_bottom).offset(8 * m6Scale);
    }];
    
   __block NSInteger i = 4;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    
    dispatch_source_set_event_handler(timer, ^{
       
        i --;
        
        if (i <= 0) {
            
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                backView.frame = CGRectMake(kScreenHeight, 0, kScreenWidth, kScreenHeight );
                
                [self.navigationController popViewControllerAnimated:YES];
                
            });
        }
        
       dispatch_async(dispatch_get_main_queue(), ^{
          
            textLabel.text = [NSString stringWithFormat:@"(%li秒后跳到红包页面)",(long)i];
       });
    });
    
    dispatch_resume(timer);
}

@end
