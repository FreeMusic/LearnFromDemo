//
//  PlanCenterCell.m
//  CityJinFu
//
//  Created by mic on 2017/7/13.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "PlanCenterCell.h"

@implementation PlanCenterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = NO;
        //投资金额标签
        UILabel *investLabel = [Factory CreateLabelWithTextColor:1 andTextFont:28 andText:@"投资金额" addSubView:self.contentView];
        investLabel.textColor = UIColorFromRGB(0x9c9b9b);
        [investLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20*m6Scale);
            make.top.mas_equalTo(30*m6Scale);
        }];
        //单线
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.2];
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20*m6Scale);
            make.right.mas_equalTo(-20*m6Scale);
            make.height.mas_equalTo(1);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-36*m6Scale);
        }];
        //金额图标
        UILabel *amountLabel = [Factory CreateLabelWithTextColor:1 andTextFont:40 andText:@"￥" addSubView:self.contentView];
        amountLabel.textColor = UIColorFromRGB(0x525252);
        [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20*m6Scale);
            make.bottom.mas_equalTo(line.mas_top).offset(-10*m6Scale);
        }];
        //输入框
        _textFiled = [[UITextField alloc] init];
        _textFiled.font = [UIFont systemFontOfSize:40*m6Scale];
        _textFiled.placeholder = @"1000元起投";
        _textFiled.keyboardType = UIKeyboardTypeNumberPad;
        _textFiled.textColor = UIColorFromRGB(0x363636);
        [_textFiled setValue:UIColorFromRGB(0xB1B0B0) forKeyPath:@"_placeholderLabel.textColor"];
        _textFiled.delegate = self;
        //定制的键盘
        KeyBoard *key = [[KeyBoard alloc]init];
        UIView *clip = [key keyBoardview];
        
        _textFiled.inputAccessoryView = clip;
        [key.doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_textFiled];
        [_textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(amountLabel.mas_right).offset(10*m6Scale);
            make.centerY.mas_equalTo(amountLabel.mas_centerY);
            make.right.mas_equalTo(0);
        }];
    }
    
    return self;
}
/**
 *  键盘消失的点击时间
 */
- (void)doneButton:(UIButton *)button {
    
    [self endEditing:YES];
}
/**
 *监听输入金额的变化事件
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.location > 7) {
        return NO;
    }else{
        return YES;
    }
}

@end
