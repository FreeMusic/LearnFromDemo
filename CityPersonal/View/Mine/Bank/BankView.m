//
//  BankView.m
//  CityJinFu
//
//  Created by xxlc on 16/8/23.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "BankView.h"

@interface BankView ()
@property (nonatomic, strong) UIImageView *hintImage;//提醒图片
@property (nonatomic, strong) UILabel *hintLabel;//提醒文字


@end
@implementation BankView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        
        [self createView];
    }
    return self;
}
/**
 *  布局
 */
- (void)createView {
    [self addSubview:self.backgroundImage];
    [self addSubview:self.bankNum];
   
    [self.backgroundImage mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.mas_left).offset(27 * m6Scale);
        make.top.equalTo(self.mas_top).offset(64 + 25 * m6Scale);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth - 54 * m6Scale, 248 * m6Scale));
    }];
    //卡号
    [self.bankNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_backgroundImage.mas_left).offset(100*m6Scale);
        make.centerY.equalTo(_backgroundImage.mas_centerY);
        make.height.equalTo(@(40*m6Scale));
    }];
    //提示
    _hintImage = [UIImageView new];
    _hintImage.image = [UIImage imageNamed:@"矢量"];
    [self addSubview:self.hintImage];
    [_hintImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_backgroundImage.mas_left).offset(150*m6Scale);
        make.top.equalTo(_backgroundImage.mas_bottom).offset(60*m6Scale);
        make.size.mas_equalTo(CGSizeMake(20*m6Scale, 20*m6Scale));
    }];
    //个人资产保护
    _hintLabel = [UILabel new];
    _hintLabel.text = @"个人资产由银行级别风控体系保护";
    _hintLabel.font = [UIFont systemFontOfSize:22*m6Scale];
    _hintLabel.textColor = [UIColor blackColor];
    [self addSubview:self.hintLabel];
    [_hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_hintImage.mas_right).offset(10*m6Scale);
        make.top.equalTo(_backgroundImage.mas_bottom).offset(60*m6Scale);
        make.height.equalTo(@(20*m6Scale));
    }];
}
/**
 *   背景
 */
- (UIImageView *)backgroundImage{
    if (!_backgroundImage) {
        _backgroundImage = [[UIImageView alloc] init];
    }
    return _backgroundImage;
}

/**
 *  银行卡号
 */
- (UILabel *)bankNum{
    if (!_bankNum) {
        _bankNum = [UILabel new];
        _bankNum.textColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
        _bankNum.font = [UIFont systemFontOfSize:50*m6Scale];
    }
    return _bankNum;
}

@end
