//
//  ThirdPartLoginView.m
//  CityJinFu
//
//  Created by 姜姜敏 on 16/11/4.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "ThirdPartLoginView.h"

@implementation ThirdPartLoginView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self createView];
        
    }
    
    return self;
    
}


- (void)createView {
    
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor whiteColor];
    [self addSubview:topView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 98 * m6Scale));
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"thirdPartLogin"];
    [topView addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.size.mas_equalTo(CGSizeMake(34 * m6Scale, 34 * m6Scale));
        make.centerY.equalTo(topView.mas_centerY);
        make.left.equalTo(topView.mas_left).offset(142 * m6Scale);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"为了顺利投资，请关联汇诚账号";
    titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:30 * m6Scale];
    [topView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(imageView.mas_right).offset(21 * m6Scale);
        
        make.centerY.equalTo(topView.mas_centerY);
    }];
    
    UILabel *notHaveLabel = [[UILabel alloc] init];
    notHaveLabel.text = @"还没有汇诚账号?";
    notHaveLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:30 * m6Scale];
    [self addSubview:notHaveLabel];
    
    [notHaveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(topView.mas_bottom).offset(85 * m6Scale);
    }];
    
    self.quickRegisterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.quickRegisterButton.backgroundColor = ButtonColor;
    self.quickRegisterButton.layer.cornerRadius = 10 * m6Scale;
    [self.quickRegisterButton setTitle:@"快速注册" forState:UIControlStateNormal];
    [self.quickRegisterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:self.quickRegisterButton];
    
    [self.quickRegisterButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(notHaveLabel.mas_bottom).offset(38 * m6Scale);
        make.size.mas_equalTo(CGSizeMake(666 * m6Scale, 90 * m6Scale));
        
    }];
    
    UIImageView *lineImageView = [[UIImageView alloc] init];
    lineImageView.image = [UIImage imageNamed:@"thirdPartLine"];
    [self addSubview:lineImageView];
    
    [lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.size.mas_equalTo(CGSizeMake(670 * m6Scale, 1 * m6Scale));
        make.top.equalTo(self.quickRegisterButton.mas_bottom).offset(54 * m6Scale);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    UILabel *didHaveLabel = [[UILabel alloc] init];
    didHaveLabel.text = @"已有汇诚账号?";
    didHaveLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:30 * m6Scale];
    [self addSubview:didHaveLabel];
    
    [didHaveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(lineImageView.mas_bottom).offset(71 * m6Scale);
        make.centerX.equalTo(self.mas_centerX);
        
    }];
    
    self.relevanceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.relevanceButton.layer.borderColor = [UIColor colorWithRed:254.0 / 255.0 green:162.0 / 255.0 blue:39.0/255.0 alpha:1.0].CGColor;
    self.relevanceButton.layer.borderWidth = 1 * m6Scale;
    self.relevanceButton.layer.cornerRadius = 10 * m6Scale;
    [self.relevanceButton setTitle:@"关联汇诚账号" forState:UIControlStateNormal];
    [self.relevanceButton setTitleColor:ButtonColor forState:UIControlStateNormal];
    [self addSubview:self.relevanceButton];
    
    [self.relevanceButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(666 * m6Scale, 90 * m6Scale));
        make.top.equalTo(didHaveLabel.mas_bottom).offset(36 * m6Scale);
    }];
    
}

@end
