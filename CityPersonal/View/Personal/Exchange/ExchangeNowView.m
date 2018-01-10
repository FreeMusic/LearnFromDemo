//
//  ExchangeNowView.m
//  CityJinFu
//
//  Created by hanling on 16/10/8.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "ExchangeNowView.h"

@implementation ExchangeNowView

- (instancetype) initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        self.redImg = [[UIImageView alloc] initWithFrame:CGRectMake(30 * m6Scale, 30 * m6Scale, kScreenWidth - 60 * m6Scale, 330 * m6Scale)];
        self.redImg.clipsToBounds = YES;
        self.redImg.image = [UIImage imageNamed:@"10红包"];
        [self addSubview:self.redImg];
        
        self.ruleImg = [[UIImageView alloc] initWithFrame:CGRectMake(30 * m6Scale, 380 * m6Scale, 150 * m6Scale, 40 * m6Scale)];
        self.ruleImg.clipsToBounds = YES;
        self.ruleImg.image = [UIImage imageNamed:@"兑换规则"];
        [self addSubview:self.ruleImg];
        
        
        NSArray *myArr = @[@"满1000抵10元", @"30天内可用", @"可用于车贷宝"];
        for (int i = 0; i < 3; i ++) {
            self.seriesBtn = [[UIButton alloc] init];
            self.seriesBtn.layer.cornerRadius = 25 * m6Scale;
            [self.seriesBtn setTitle:[NSString stringWithFormat:@"%d",i + 1] forState:0];
            [self.seriesBtn setTitleColor:[UIColor whiteColor] forState:0];
            self.seriesBtn.titleLabel.font = [UIFont systemFontOfSize:34 * m6Scale];
            self.seriesBtn.backgroundColor = [UIColor colorWithRed:237/255.0 green:93/255.0 blue:62/255.0 alpha:1.0];
            self.seriesBtn.tag = 50 + i;
            self.seriesBtn.enabled = NO;
            [self addSubview:self.seriesBtn];
            
            [self.seriesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(150 * m6Scale);
                make.top.equalTo(self.ruleImg.mas_bottom).offset(20 * m6Scale + 70 * m6Scale * i);
                make.size.mas_equalTo(CGSizeMake(50 * m6Scale, 50 * m6Scale));
            }];

            
            self.contentLab = [[UILabel alloc] init];
            self.contentLab.font = [UIFont systemFontOfSize:33 * m6Scale];
            self.contentLab.backgroundColor = [UIColor clearColor];
            self.contentLab.text = myArr[i];
            self.contentLab.textColor = [UIColor colorWithRed:45/255.0 green:45/255.0 blue:45/255.0 alpha:1.0];
            [self addSubview:self.contentLab];
            
            [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.seriesBtn.mas_right).offset(20 * m6Scale);
                make.top.equalTo(self.ruleImg.mas_bottom).offset(20 * m6Scale + 70 * m6Scale * i);
                make.size.mas_equalTo(CGSizeMake(kScreenWidth * 0.6, 60 * m6Scale));
            }];
        }
        
        UIImageView * line1 = [[UIImageView alloc] init];
        line1.image = [UIImage imageNamed:@"line-"];
        [self addSubview:line1];
        
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.equalTo(self.seriesBtn.mas_bottom).offset(50 * m6Scale);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth, 10 * m6Scale));
        }];
        
        self.integralImg = [[UIImageView alloc] init];
        self.integralImg.clipsToBounds = YES;
        self.integralImg.image = [UIImage imageNamed:@"积分"];
        [self addSubview:self.integralImg];
        
        [self.integralImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30 * m6Scale);
            make.top.equalTo(line1.mas_bottom).offset(30 * m6Scale);
            make.size.mas_equalTo(CGSizeMake(200 * m6Scale, 50 * m6Scale));
        }];
        
        self.numLab = [[UILabel alloc] init];
        self.numLab.textColor = [UIColor redColor];
        self.numLab.font = [UIFont systemFontOfSize:34 * m6Scale];
        self.numLab.text = @"1000分";
        [self addSubview:self.numLab];
        
        [self.numLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(220 * m6Scale);
            make.top.equalTo(self.integralImg.mas_bottom).offset(20 * m6Scale);
            make.size.mas_equalTo(CGSizeMake(150 * m6Scale, 50 * m6Scale));
        }];
        
        UIImageView * line2 = [[UIImageView alloc] init];
        line2.image = [UIImage imageNamed:@"line-"];
        [self addSubview:line2];
        
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.equalTo(self.numLab.mas_bottom).offset(50 * m6Scale);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth, 10 * m6Scale));
        }];

        self.leftBtn = [[UIButton alloc] init];
        [self.leftBtn setTitle:@"取消" forState:0];
        [self.leftBtn setTitleColor:[UIColor whiteColor] forState:0];
        self.leftBtn.backgroundColor = [UIColor colorWithRed:245/255.0 green:114/255.0 blue:59/255.0 alpha:1.0];
        self.leftBtn.layer.cornerRadius = 5.0;
        [self addSubview:self.leftBtn];
        [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(50 * m6Scale);
            make.top.equalTo(line2.mas_bottom).offset(50 * m6Scale);
            make.size.mas_equalTo(CGSizeMake((kScreenWidth - 160 * m6Scale)/2, 90 * m6Scale));
        }];
        
        self.rightBtn = [[UIButton alloc] init];
        [self.rightBtn setTitle:@"兑换" forState:0];
        [self.rightBtn setTitleColor:[UIColor colorWithRed:101/255.0 green:101/255.0 blue:101/255.0 alpha:1.0] forState:0];
        self.rightBtn.backgroundColor = [UIColor colorWithRed:201/255.0 green:201/255.0 blue:201/255.0 alpha:1.0];
        self.rightBtn.layer.cornerRadius = 5.0;
        [self addSubview:self.rightBtn];
        [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-50 * m6Scale);
            make.top.equalTo(line2.mas_bottom).offset(50 * m6Scale);
            make.size.mas_equalTo(CGSizeMake((kScreenWidth - 160 * m6Scale)/2, 90 * m6Scale));
        }];
        
     }
    return self;
}

@end
