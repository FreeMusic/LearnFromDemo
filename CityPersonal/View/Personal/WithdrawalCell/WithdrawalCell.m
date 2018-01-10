//
//  WithdrawalCell.m
//  CityJinFu
//
//  Created by mic on 2017/7/20.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "WithdrawalCell.h"

@implementation WithdrawalCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = NO;
        self.contentView.backgroundColor = [UIColor whiteColor];
        UIView *topView = [[UIView alloc] init];
        topView.backgroundColor = backGroundColor;
        [self.contentView addSubview:topView];
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(20*m6Scale);
        }];
        //提现金额
        _amountLabel = [Factory CreateLabelWithTextColor:1 andTextFont:28 andText:@"提现金额（单笔限额5万元）" addSubView:self.contentView];
        _amountLabel.textColor = UIColorFromRGB(0x393939);
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:@"提现金额（单笔限额5万元）" attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x393939)}];
        [att addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:[_amountLabel.text rangeOfString:@"（单笔限额5万元）"]];
        _amountLabel.attributedText = att;
        [_amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20*m6Scale);
            make.top.mas_equalTo(56*m6Scale);
        }];
        //金钱图标
        UILabel *moneyLabel = [Factory CreateLabelWithTextColor:0 andTextFont:50 andText:@"￥" addSubView:self.contentView];
        [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20*m6Scale);
            make.top.mas_equalTo(_amountLabel.mas_bottom).offset(50*m6Scale);
        }];
        //单线
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.4];
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20*m6Scale);
            make.right.mas_equalTo(-20*m6Scale);
            make.height.mas_equalTo(1);
            make.top.mas_equalTo(218*m6Scale);
        }];
        //提现金额输入框
        _textFiled = [[UITextField alloc] init];
        _textFiled.textColor = [UIColor colorWithWhite:0 alpha:1];
        _textFiled.font = [UIFont systemFontOfSize:44*m6Scale];
        _textFiled.keyboardType = UIKeyboardTypeNumberPad;
        _textFiled.keyboardType = UIKeyboardTypeDecimalPad;
        //定制的键盘
        KeyBoard *key = [[KeyBoard alloc]init];
        UIView *clip = [key keyBoardview];
        
        _textFiled.inputAccessoryView = clip;
        [key.doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_textFiled];
        [_textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(moneyLabel.mas_right).offset(15*m6Scale);
            make.right.mas_equalTo(0);
            make.centerY.mas_equalTo(moneyLabel.mas_centerY);
        }];
        //可用余额
        _restLabel = [Factory CreateLabelWithTextColor:1 andTextFont:26 andText:@"可用余额0.00元" addSubView:self.contentView];
        _restLabel.textColor = UIColorFromRGB(0xa6a6a6);
        [_restLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-10*m6Scale);
            make.left.mas_equalTo(20*m6Scale);
        }];
        //全部提现
        self.drawAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.drawAllBtn setTitle:@"全部提现" forState:0];
        [self.drawAllBtn setTitleColor:UIColorFromRGB(0xff5933) forState:UIControlStateNormal];
        self.drawAllBtn.titleLabel.font = [UIFont fontWithName:@"Arial" size:28*m6Scale];
        [self.contentView addSubview:self.drawAllBtn];
        [self.drawAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-20*m6Scale);
            make.centerY.mas_equalTo(_restLabel.mas_centerY);
            make.height.mas_offset(50*m6Scale);
        }];
    }
    return self;
}

/**
 *  键盘消失
 */
- (void)doneButton:(UIButton *)button {
    
    [self endEditing:YES];
    
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
