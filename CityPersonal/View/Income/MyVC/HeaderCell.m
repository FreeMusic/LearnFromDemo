//
//  HeaderCell.m
//  CityJinFu
//
//  Created by xxlc on 17/5/23.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "HeaderCell.h"

@implementation HeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatView];
    }
    return self;
}
/**
 创建布局
 */
- (void)creatView{
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 400*m6Scale)];
    imageview.image = [UIImage imageNamed:@"我的头部背景"];
    [self.contentView addSubview:imageview];
    //总金额
    _sumLabel = [self commontLab:80];
    _sumLabel.text = @"6,000.00";
    [self.contentView addSubview:_sumLabel];
    [_sumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.centerY.mas_equalTo(self.contentView.mas_centerY).offset(-120*m6Scale);
    }];
    //总资产(元)
    _titleClipLabel = [Factory myTypeLab:@"总资产(元)"];
    _titleClipLabel.frame = CGRectMake(0, 120*m6Scale, kScreenWidth, 70*m6Scale);
    [self.contentView addSubview:_titleClipLabel];
    //待收金额
    _collectedLabel = [self commontLab:40];
    _collectedLabel.text = @"12,666.00";
    [self.contentView addSubview:_collectedLabel];
    [_collectedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-80*m6Scale);
        make.width.mas_equalTo(kScreenWidth / 2);
    }];
    _collectedtitle = [Factory myTypeLab:@"待收金额"];
    [self.contentView addSubview:_collectedtitle];
    [_collectedtitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.top.equalTo(_collectedLabel.mas_bottom).offset(10*m6Scale);
        make.width.mas_equalTo(kScreenWidth / 2);
    }];
    //累计收益
    _totalIncomeLabel = [self commontLab:40];
    _totalIncomeLabel.text = @"12,666.00";
    [self.contentView addSubview:_totalIncomeLabel];
    [_totalIncomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-80*m6Scale);
        make.width.mas_equalTo(kScreenWidth / 2);
    }];
    _totaltitlelab = [Factory myTypeLab:@"累计收益"];
    [self.contentView addSubview:_totaltitlelab];
    [_totaltitlelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(_totalIncomeLabel.mas_bottom).offset(10*m6Scale);
        make.width.mas_equalTo(kScreenWidth / 2);
    }];
}
/**
 共有属性label
 */
- (UILabel *)commontLab:(CGFloat)floatlab{
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:floatlab*m6Scale];
    label.textColor = TitleViewBackgroundColor;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
