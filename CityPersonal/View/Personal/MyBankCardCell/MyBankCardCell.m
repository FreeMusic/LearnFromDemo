//
//  MyBankCardCell.m
//  CityJinFu
//
//  Created by mic on 2017/7/25.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "MyBankCardCell.h"

@implementation MyBankCardCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = NO;
        self.contentView.backgroundColor = backGroundColor;
        //银行卡大背景图
        _imgView = [[UIImageView alloc] init];
        [self.contentView addSubview:_imgView];
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(690*m6Scale, 215*m6Scale));
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.top.mas_equalTo(22*m6Scale);
        }];
        //解绑按钮
        _unBindBtn = [UIButton buttonWithType:0];
        [_unBindBtn setTitle:@"解绑" forState:0];
        [_unBindBtn setTitleColor:[UIColor whiteColor] forState:0];
        _unBindBtn.layer.borderWidth = 1;
        _unBindBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _unBindBtn.layer.cornerRadius = 5*m6Scale;
        [self.contentView addSubview:_unBindBtn];
        [_unBindBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(50*m6Scale);
            make.right.mas_equalTo(-52*m6Scale);
            make.size.mas_equalTo(CGSizeMake(100*m6Scale, 50*m6Scale));
        }];
        //银行卡号标签
        _cardNumLabel = [Factory CreateLabelWithTextColor:1 andTextFont:30 andText:@"" addSubView:_imgView];
        [_cardNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-40*m6Scale);
            make.bottom.mas_equalTo(-40*m6Scale);
        }];
    }
    return self;
}

- (void)cellForModel:(BankListModel *)model{
    //银行卡背景图
    NSString *bankName = [NSString stringWithFormat:@"%@", model.bankBackgroud];
    [_imgView sd_setImageWithURL:[NSURL URLWithString:bankName] placeholderImage:[UIImage imageNamed:@"750x240"]];
    //银行卡号
    _cardNumLabel.text = [NSString stringWithFormat:@"%@", model.cardNo];
}

@end
