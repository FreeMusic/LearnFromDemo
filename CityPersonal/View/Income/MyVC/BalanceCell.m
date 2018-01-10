//
//  BalanceCell.m
//  CityJinFu
//
//  Created by xxlc on 17/5/21.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "BalanceCell.h"

@implementation BalanceCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatView];
    }
    return self;
}
/**
 布局
 */
- (void)creatView{
    [self.contentView addSubview:self.balanceLab];
    [self.contentView addSubview:self.topUpBtn];
    [self.contentView addSubview:self.withdrawalBtn];
    //可用余额
    [_balanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(30*m6Scale);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    //充值
    [_topUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-30*m6Scale);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(120*m6Scale, 60*m6Scale));
    }];
    //提现
    [_withdrawalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_topUpBtn.mas_left).offset(-20*m6Scale);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(120*m6Scale, 60*m6Scale));
    }];
}
/**
 充值
 */
- (UIButton *)topUpBtn{
    if (!_topUpBtn) {
        _topUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_topUpBtn setTitle:@"充值" forState:UIControlStateNormal];
        _topUpBtn.backgroundColor = ButtonColor;
        _topUpBtn.layer.cornerRadius = 5;
        _topUpBtn.titleLabel.font = [UIFont systemFontOfSize:30*m6Scale];
    }
    return _topUpBtn;
}
/**
 提现
 */
- (UIButton *)withdrawalBtn{
    if (!_withdrawalBtn) {
        _withdrawalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _withdrawalBtn.layer.borderWidth = 1;
        _withdrawalBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _withdrawalBtn.titleLabel.font = [UIFont systemFontOfSize:30*m6Scale];
        _withdrawalBtn.layer.cornerRadius = 5;
        [_withdrawalBtn setTitle:@"提现" forState:UIControlStateNormal];
        [_withdrawalBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    return _withdrawalBtn;
}
/**
 可用余额
 */
- (UILabel *)balanceLab{
    if (!_balanceLab) {
        _balanceLab = [UILabel new];
        _balanceLab.font = [UIFont systemFontOfSize:35*m6Scale];
        _balanceLab.text = @"可用余额  12,656.00";
    }
    return _balanceLab;
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
