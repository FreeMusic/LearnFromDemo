//
//  InvestPayView.m
//  CityJinFu
//
//  Created by 姜姜敏 on 16/10/13.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "InvestPayView.h"

@implementation InvestPayView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self createView];
        
    }
    
    return self;
    
}

- (void)createView {
    
    UILabel *modelRMBLabel = [[UILabel alloc] init];
    modelRMBLabel.font = [UIFont systemFontOfSize:40 * m6Scale];
    modelRMBLabel.text = @"¥";
    [self addSubview:modelRMBLabel];
    
    [modelRMBLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.mas_left).offset(25 * m6Scale);
        make.centerY.equalTo(self.mas_centerY);
    }];
    //金额显示
    self.payLabel = [[UILabel alloc] init];
    self.payLabel.textColor = [UIColor colorWithRed:246 / 255.0 green:68 / 255.0 blue:68 / 255.0 alpha:1];
    self.payLabel.font = [UIFont systemFontOfSize:40 * m6Scale];
    [self addSubview:self.payLabel];
    
    [self.payLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(modelRMBLabel.mas_right).offset(10 * m6Scale);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    //充值金额
    UILabel *modelPayLabel = [[UILabel alloc] init];
    modelPayLabel.text = @"充值金额";
    modelPayLabel.textColor = [UIColor colorWithRed:167 / 255.0 green:164 / 255.0 blue:164 / 255.0 alpha:1];
    modelPayLabel.font = [UIFont systemFontOfSize:31 * m6Scale];
    [self addSubview:modelPayLabel];
    
    [modelPayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.payLabel.mas_right).offset(20 * m6Scale);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    //确认投资
    self.makeSureButton = [GXJButton buttonWithType:UIButtonTypeCustom];
    [self.makeSureButton setTitle:@"确认投资" forState:UIControlStateNormal];
    [self.makeSureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.makeSureButton.titleLabel.font = [UIFont systemFontOfSize:31 * m6Scale];
    self.makeSureButton.backgroundColor = ButtonColor;
    [self addSubview:self.makeSureButton];
    
     [self.makeSureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
         make.width.mas_equalTo(254 * m6Scale);
         make.top.equalTo(self.mas_top);
         make.right.equalTo(self.mas_right);
         make.bottom.equalTo(self.mas_bottom);
     }];
}

@end
