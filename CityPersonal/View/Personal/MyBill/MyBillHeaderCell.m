//
//  MyBillHeaderCell.m
//  CityJinFu
//
//  Created by xxlc on 17/5/25.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "MyBillHeaderCell.h"

@implementation MyBillHeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *imageview = [[UIImageView alloc]init];
        imageview.image = [UIImage imageNamed:@"账单头部背景"];
        [self.contentView addSubview:imageview];
        [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        [self creatView];
    }
    return self;
}
/**
 布局
 */
- (void)creatView{
    [self.contentView addSubview:self.timeLab];
    [self.contentView addSubview:self.invistlab];
    [self.contentView addSubview:self.invistMoneyLab];
    [self.contentView addSubview:self.incomLabe];
    [self.contentView addSubview:self.incomMoeyLab];
    [self.contentView addSubview:self.dayLabel];
    //时间
    [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-170*m6Scale);
        make.top.equalTo(self.contentView.mas_top).offset(60*m6Scale);
    }];
    //累计投资
    [_invistlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-60*m6Scale);
        make.width.mas_equalTo(kScreenWidth/2);
    }];
    [_invistMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.top.equalTo(_invistlab.mas_bottom).offset(5*m6Scale);
        make.width.mas_equalTo(kScreenWidth/2);
    }];
    //累计收益
    [_incomLabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-60*m6Scale);
        make.width.mas_equalTo(kScreenWidth/2);
    }];
    [_incomMoeyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(_invistlab.mas_bottom).offset(5*m6Scale);
        make.width.mas_equalTo(kScreenWidth/2);
    }];
    //起止时间标签
    [_dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-170*m6Scale);
        make.top.equalTo(_timeLab.mas_bottom).offset(6*m6Scale);
    }];
}
/**
 时间选择
 */
- (UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [UILabel new];
        _timeLab.text = @"2017年6月";
        _timeLab.textColor = ButtonColor;
        _timeLab.font = [UIFont systemFontOfSize:38*m6Scale];
    }
    return _timeLab;
}
/**
 累计投资
 */
- (UILabel *)invistlab{
    if (!_invistlab) {
        _invistlab = [self commitLab:@"累计投资(元)"];
    }
    return _invistlab;
}
/**
 累计投资(元
 */
- (UILabel *)invistMoneyLab{
    if (!_invistMoneyLab) {
        _invistMoneyLab = [self commitLab:@"1000.00"];
    }
    return _invistMoneyLab;
}
/**
 累计收益
 */
- (UILabel *)incomLabe{
    if (!_incomLabe) {
        _incomLabe = [self commitLab:@"累计收益(元)"];
    }
    return _incomLabe;
}
/**
 累计收益(元)
 */
- (UILabel *)incomMoeyLab{
    if (!_incomMoeyLab) {
        _incomMoeyLab = [self commitLab:@"1000.00"];
    }
    return _incomMoeyLab;
}
/**
 起止时间标签
 */
- (UILabel *)dayLabel{
    if(!_dayLabel){
        _dayLabel = [self commitLab:@"06.01-06.30"];
    }
    return _dayLabel;
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

- (void)cellForModel:(BillAcountModel *)model andDataModel:(BillDataModel *)dataModel Year:(NSString *)year Month:(NSString *)month{
    self.invistMoneyLab.text = [NSString stringWithFormat:@"%.2f", [model.countInvest doubleValue]];//累计投资
    self.incomMoeyLab.text = [NSString stringWithFormat:@"%.2f", [model.countIncome doubleValue]];//累计收益
    _dayLabel.text = [NSString stringWithFormat:@"%@~%@", dataModel.beginDay, dataModel.endDay];
    _timeLab.text = [NSString stringWithFormat:@"%@%@", year,month];//时间标签
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
