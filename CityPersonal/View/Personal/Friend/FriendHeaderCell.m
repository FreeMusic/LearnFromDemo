//
//  HeaderCell.m
//  CityJinFu
//
//  Created by xxlc on 17/5/23.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "FriendHeaderCell.h"

@implementation FriendHeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = ButtonColor;
        [self creatView];
    }
    return self;
}
/**
 布局
 */
- (void)creatView{
    [self.contentView addSubview:self.titlelab];
    [self.contentView addSubview:self.moneylab];
    [self.contentView addSubview:self.detailsBtn];
    //奖励标题
    [_titlelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(30*m6Scale);
        make.top.equalTo(self.contentView.mas_top).offset(40*m6Scale);
    }];
    //金额
    [_moneylab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(30*m6Scale);
        make.top.equalTo(self.titlelab.mas_bottom).offset(30*m6Scale);
    }];
    //明细
    [_detailsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-30*m6Scale);
        make.top.equalTo(self.contentView.mas_top).offset(40*m6Scale);
    }];
}
/**
 获得奖励(元)
 */
- (UILabel *)titlelab{
    if (!_titlelab) {
        _titlelab = [UILabel new];
        _titlelab.text = @"获得奖励(元)";
        _titlelab.textColor = TitleViewBackgroundColor;
        _titlelab.font = [UIFont systemFontOfSize:36*m6Scale];
    }
    return _titlelab;
}
/**
 金额
 */
- (UILabel *)moneylab{
    if (!_moneylab) {
        _moneylab = [UILabel new];
        _moneylab.textColor = TitleViewBackgroundColor;
        _moneylab.text = @"0";
        _moneylab.font = [UIFont systemFontOfSize:70*m6Scale];
    }
    return _moneylab;
}
/**
 明细
 */
- (UIButton *)detailsBtn{
    if (!_detailsBtn) {
        _detailsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_detailsBtn setTitle:@"奖励明细 ＞" forState:UIControlStateNormal];
        _detailsBtn.titleLabel.font = [UIFont systemFontOfSize:36*m6Scale];
    }
    return _detailsBtn;
}
- (void)cellForModel:(InviteFriendModel *)model{
    _moneylab.text = [NSString stringWithFormat:@"%ld", model.inviteRewards.integerValue];//获得奖励金额
}

@end
