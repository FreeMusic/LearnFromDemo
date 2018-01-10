//
//  AutoHeaderCell.m
//  CityJinFu
//
//  Created by xxlc on 17/5/24.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "AutoHeaderCell.h"

@implementation AutoHeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"自动投标头部背景"]];
        [self creatView];
    }
    return self;
}
/**
 布局
 */
- (void)creatView{
    [self.contentView addSubview:self.firstImage];
    [self.contentView addSubview:self.secondImage];
    [_firstImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(100*m6Scale);
        make.top.equalTo(self.contentView.mas_top).offset(42*m6Scale);
        make.right.equalTo(self.contentView.mas_right).offset(-(kScreenWidth - 136*m6Scale));
        make.size.mas_equalTo(CGSizeMake(36*m6Scale, 36*m6Scale));
    }];
    _titileFirLab = [self commitLab:@"当前排名"];
    [self.contentView addSubview:_titileFirLab];
    [_titileFirLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(150*m6Scale);
        make.top.equalTo(self.contentView.mas_top).offset(40*m6Scale);
    }];
    //第二个
    _titileSecLab = [self commitLab:@"累计投资"];
    [self.contentView addSubview:_titileSecLab];
    [_titileSecLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-100*m6Scale);
        make.top.equalTo(self.contentView.mas_top).offset(40*m6Scale);
    }];
    [_secondImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(42*m6Scale);
        make.left.equalTo(self.contentView.mas_left).offset(460*m6Scale);
        make.size.mas_equalTo(CGSizeMake(36*m6Scale, 36*m6Scale));
    }];
    [self.contentView addSubview:self.rankingLab];
    //计数中
    [_rankingLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.top.equalTo(_titileFirLab.mas_bottom).offset(30*m6Scale);
        make.width.mas_equalTo(kScreenWidth/2);
    }];
    [self.contentView addSubview:self.moneyLab];
    //数钱中
    [_moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(_titileSecLab.mas_bottom).offset(30*m6Scale);
        make.width.mas_equalTo(kScreenWidth/2);
    }];
}
/**
 第一个图标
 */
- (UIImageView *)firstImage{
    if (!_firstImage) {
        _firstImage = [[UIImageView alloc]init];
        _firstImage.image = [UIImage imageNamed:@"当前排名"];
    }
    return _firstImage;
}
/**
 第二图标
 */
- (UIImageView *)secondImage{
    if (!_secondImage) {
        _secondImage = [[UIImageView alloc]init];
        _secondImage.image = [UIImage imageNamed:@"累计投资"];
    }
    return _secondImage;
}
/**
 排名
 */
- (UILabel *)rankingLab{
    if (!_rankingLab) {
        _rankingLab = [self commitLab:@"计数中"];
    }
    return _rankingLab;
}
/**
 金额
 */
- (UILabel *)moneyLab{
    if (!_moneyLab) {
        _moneyLab = [self commitLab:@"数钱中"];
    }
    return _moneyLab;
}
/**
 公共label
 */
- (UILabel *)commitLab:(NSString *)text{
    UILabel *titleLab = [UILabel new];
    titleLab.text = text;
    titleLab.font = [UIFont systemFontOfSize:35*m6Scale];
    titleLab.textColor = [UIColor lightGrayColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    return titleLab;
}
- (void)cellForRank:(NSString *)rank Account:(NSString *)account{
    if (rank != nil) {
        if ([rank isEqualToString:@"未开启"]) {
            
        }else{
            _rankingLab.text = rank;
            _rankingLab.textColor = buttonColor;
        }
    }
    if (account != nil) {
        if ([account isEqualToString:@"未开启"]) {
            
        }else{
            _moneyLab.text = account;
            _moneyLab.textColor = buttonColor;
        }
    }
    
}
@end
