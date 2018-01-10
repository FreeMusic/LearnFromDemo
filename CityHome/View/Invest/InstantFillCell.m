//
//  InstantFillCell.m
//  CityJinFu
//
//  Created by 姜姜敏 on 16/8/25.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "InstantFillCell.h"

@interface InstantFillCell ()<UITextFieldDelegate>
@property (nonatomic, copy) NSString * itemAccount;//项目金额
@property (nonatomic, copy) NSString * itemId;//项目ID
@property (nonatomic, copy) NSString * ticketId;//加息劵id
@property (nonatomic, copy) NSString * remainingMoney;//可用余额
@property (nonatomic, copy) NSString *moneyStr;//投资金额

@end

@implementation InstantFillCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //投资金额
        _accountLabel = [Factory CreateLabelWithTextColor:0.3 andTextFont:26 andText:@"投资金额" addSubView:self.contentView];
        [_accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20*m6Scale);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        NSArray *arr = @[@"-", @"+"];
        //加减号按钮
        for (int i = 0; i < arr.count; i++) {
            _btn = [UIButton buttonWithType:0];
            [_btn setTitle:arr[i] forState:0];
            _btn.layer.cornerRadius = 3*m6Scale;
            _btn.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
            _btn.layer.borderWidth = 1;
            _btn.tag = 10 + i;
            [_btn addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:_btn];
            [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_accountLabel.mas_right).offset(15*m6Scale+280*i*m6Scale);
                make.centerY.mas_equalTo(self.contentView.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(44*m6Scale, 44*m6Scale));
            }];
            if (i == 0) {
                [_btn setTitleColor:[UIColor colorWithWhite:0.8 alpha:1] forState:0];
                //单线
                UIView *line = [[UIView alloc] init];
                line.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
                [self.contentView addSubview:line];
                [line mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(_btn.mas_right).offset(1*m6Scale);
                    make.width.mas_equalTo(278*m6Scale-44*m6Scale);
                    make.height.mas_equalTo(1);
                    make.bottom.mas_equalTo(_btn.mas_bottom).offset(8*m6Scale);
                }];
                //输入框
                _textFiled = [[UITextField alloc] init];
                _textFiled.text = @"100";
                _textFiled.delegate = self;
                _textFiled.textColor = UIColorFromRGB(0xff5933);
                _textFiled.font = [UIFont systemFontOfSize:40*m6Scale];
                _textFiled.textAlignment = NSTextAlignmentCenter;
                _textFiled.keyboardType = UIKeyboardTypeNumberPad;
                //定制的键盘
                KeyBoard *key = [[KeyBoard alloc]init];
                UIView *clip = [key keyBoardview];
                
                _textFiled.inputAccessoryView = clip;
                [key.doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
                [self.contentView addSubview:_textFiled];
                [_textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(_btn.mas_right);
                    make.bottom.mas_equalTo(line.mas_top).offset(-10*m6Scale);
                    make.width.mas_equalTo(280*m6Scale-44*m6Scale);
                }];
            }else{
                [_btn setTitleColor:UIColorFromRGB(0xffb514) forState:0];
            }
        }
        //自动填按钮
        _autoBtn = [UIButton buttonWithType:0];
        [_autoBtn setTitle:@"自动填入" forState:0];
        _autoBtn.layer.cornerRadius = 3*m6Scale;
        [_autoBtn setTitleColor:[UIColor colorWithWhite:0.6 alpha:1] forState:0];
        _autoBtn.titleLabel.font = [UIFont systemFontOfSize:26*m6Scale];
        _autoBtn.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
        _autoBtn.layer.borderWidth = 1;
        [self.contentView addSubview:_autoBtn];
        [_autoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20*m6Scale);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(164*m6Scale, 70*m6Scale));
        }];
    }
    return self;
}

//根据输入值实时改变label的值
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    NSString *text;

    if ([string isEqualToString:@""] || [string integerValue] || [string isEqualToString:@"."] || [string isEqualToString:@"0"]) {

        if ([string isEqualToString:@""]) {
            //获取到上一次操作的字符串长度
            NSInteger clip = textField.text.length;
            //截取字符串 将最后一个字符删除
            text = [textField.text substringToIndex:clip - 1];

        }else {

            text = [textField.text stringByAppendingString:string];
        }

        if (text.length <= 0 && text == nil) {

//            self.hopeIncomeLabel.text = [NSString stringWithFormat:@"预计收益:0元"];
            return NO;
        }
        if (text.length == 2 && text.floatValue == 0) {

            return NO;

        }else {
            if (text.length <= 7) {
                _moneyStr = text;
                NSDictionary *info = @{
                                       @"moneyText" : text
                                       };
                [[NSNotificationCenter defaultCenter] postNotificationName:@"clip" object:self userInfo:info];
                //提高tabView的高度
                [[NSNotificationCenter defaultCenter] postNotificationName:@"tabviewH" object:@"0"];
                NSLog(@"%@",text);
                return YES;
            }else {

                return NO;
            }
        }
    }else {

        return NO;
    }
}
/**
 加减按钮
 */
- (void)btn:(UIButton *)sender{
    NSLog(@"++++%@",_moneyStr);
    
    if (sender.tag == 10) {//减
        NSDictionary *info = @{
                               @"moneyText" : @"0"
                               };
        [[NSNotificationCenter defaultCenter] postNotificationName:@"zyyAdd" object:self userInfo:info];
    }else{//加
        NSDictionary *info = @{
                               @"moneyText" : @"1"
                               };
        [[NSNotificationCenter defaultCenter] postNotificationName:@"zyyAdd" object:self userInfo:info];
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [textField resignFirstResponder];

    return YES;
}
/**
 *  键盘消失
 */
- (void)doneButton:(UIButton *)button {
    
    //提高tabView的高度
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabviewH" object:@"1"];
    [self endEditing:YES];

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


@end
