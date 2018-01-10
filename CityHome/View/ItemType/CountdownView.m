//
//  CountdownView.m
//  CityJinFu
//
//  Created by 姜姜敏 on 16/10/26.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "CountdownView.h"

@implementation CountdownView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        
        [self createView];
        
    }
    
    return self;
}

- (void)createView {
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"itemCountdown"];
    [self addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_right);
    }];
    
    self.hourLabel = [[UILabel alloc] init];
    self.hourLabel.textColor = [UIColor colorWithRed:155 / 255.0 green:15 / 255.0 blue:26 / 255.0 alpha:1];
    self.hourLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:40 * m6Scale];
    self.hourLabel.text = @"00";
    [imageView addSubview:self.hourLabel];
    
    [self.hourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(imageView.mas_left).offset(203 * m6Scale);
        
        make.centerY.equalTo(imageView.mas_centerY);
    }];
    
    self.minLabel = [[UILabel alloc] init];
    self.minLabel.textColor = [UIColor colorWithRed:155 / 255.0 green:15 / 255.0 blue:26 / 255.0 alpha:1];
    self.minLabel.text = @"00";
    self.minLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:40 * m6Scale];
    [imageView addSubview:self.minLabel];
    
    [self.minLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(imageView.mas_left).offset(263 * m6Scale);
        
        make.centerY.equalTo(imageView.mas_centerY);
    }];
    
    self.secLabel = [[UILabel alloc] init];
    self.secLabel.textColor = [UIColor colorWithRed:155 / 255.0 green:15 / 255.0 blue:26 / 255.0 alpha:1];
    self.secLabel.text = @"01";
    self.secLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:40 * m6Scale];
    [imageView addSubview:self.secLabel];
    
    [self.secLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(imageView.mas_left).offset(324 * m6Scale);
        
        make.centerY.equalTo(imageView.mas_centerY);
    }];
    
    
}

@end
