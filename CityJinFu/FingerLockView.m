//
//  FingerLockView.m
//  CityJinFu
//
//  Created by 姜姜敏 on 16/9/27.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "FingerLockView.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "AppDelegate.h"

@implementation FingerLockView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        
        [self createView];
        
    }
    
    return self;
    
}

- (void)createView {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(restartFingerAction:)];
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.image = [UIImage imageNamed:@"fingerIcon"];
    [self addSubview:iconImageView];
    
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(320 * m6Scale);
        make.size.mas_equalTo(CGSizeMake(150 * m6Scale, 150 * m6Scale));
    }];
    
    _fingerImageView = [[UIImageView alloc] init];
    _fingerImageView.image = [UIImage imageNamed:@"fingerLock"];
    _fingerImageView.userInteractionEnabled = YES;
    [_fingerImageView addGestureRecognizer:tap];
    [self addSubview:_fingerImageView];
    
    [_fingerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(130 * m6Scale, 130 * m6Scale));
    }];
    
    _textLabel = [[UILabel alloc] init];
    _textLabel.text = @"点击进行指纹解锁";
    _textLabel.font = [UIFont systemFontOfSize:14];
    _textLabel.textColor = [UIColor colorWithRed:32 / 255.0 green:153 / 255.0 blue:234 / 255.0 alpha:1];
    [self addSubview:_textLabel];
    
    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.equalTo(_fingerImageView.mas_bottom).offset(40 * m6Scale);
        
    }];
    UITapGestureRecognizer *clip = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideButtonAction:)];
    
    UILabel *loginOtherLabel = [[UILabel alloc] init];
    loginOtherLabel.textColor = [UIColor colorWithRed:32 / 255.0 green:153 / 255.0 blue:234 / 255.0 alpha:1];
    loginOtherLabel.userInteractionEnabled = YES;
    loginOtherLabel.font = [UIFont systemFontOfSize:16];
    loginOtherLabel.text = @"登录其他账户";
    [loginOtherLabel addGestureRecognizer:clip];
    [self addSubview:loginOtherLabel];
    
    [loginOtherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom).offset(- 80 * m6Scale);
        
    }];
}

- (void)restartFingerAction:(UIGestureRecognizer *)tap {
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [delegate judgeProtectSafe];
}

- (void)hideButtonAction:(UIGestureRecognizer *)tap {
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [delegate hideFinerViewAction];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user removeObjectForKey:@"result"];
    [user synchronize];
    [user removeObjectForKey:@"userId"];
    [user synchronize];
    [user removeObjectForKey:@"switchGesture"];
    [user removeObjectForKey:@"userIcon"];
    [user synchronize];
    [user removeObjectForKey:@"gesturePassword"];
    [user synchronize];
    [user removeObjectForKey:@"fingerSwitch"];
    [user synchronize];
    [user removeObjectForKey:@"gestureLock"];
    [user synchronize];
    
    [delegate.leveyTabBarController.tabBar tabBarButtonClickedWithTag:3];
}

@end
