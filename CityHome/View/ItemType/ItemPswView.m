//
//  ItemPswView.m
//  CityJinFu
//
//  Created by mic on 2017/7/30.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "ItemPswView.h"

@implementation ItemPswView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.7];
        //背景View
        UIButton *backBtn = [UIButton buttonWithType:0];
        backBtn.backgroundColor = [UIColor whiteColor];
        backBtn.layer.cornerRadius = 6*m6Scale;
        backBtn.layer.masksToBounds = YES;
        [self addSubview:backBtn];
        [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kScreenWidth-160, 300*m6Scale));
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(kScreenHeight*0.3);
        }];
        //定向标标题
        _titleLabel = [Factory CreateLabelWithTextColor:0 andTextFont:28 andText:@"请输入定向标密码" addSubView:backBtn];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(30*m6Scale);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
        //定向标密码输入框
        _textFiled = [[UITextField alloc] init];
        _textFiled.placeholder = @"请输入定向标密码";
        _textFiled.keyboardType =  UIKeyboardTypeNumbersAndPunctuation;
        _textFiled.secureTextEntry = YES;
//        //定制的键盘
//        KeyBoard *key = [[KeyBoard alloc]init];
//        UIView *clip = [key keyBoardview];
//        [key.doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
//        
//        _textFiled.inputAccessoryView = clip;
        [backBtn addSubview:_textFiled];
        [_textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(backBtn.mas_centerX);
            make.centerY.mas_equalTo(backBtn.mas_centerY);
        }];
        //密码输入框确认按钮
        _pswBtn = [UIButton buttonWithType:0];
        _pswBtn.layer.cornerRadius = 6*m6Scale;
        [_pswBtn setTitle:@"确认" forState:0];
        [_pswBtn setTitleColor:[UIColor whiteColor] forState:0];
        _pswBtn.backgroundColor = ButtonColor;
        [backBtn addSubview:_pswBtn];
        [_pswBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kScreenWidth-220, 60*m6Scale));
            make.centerX.mas_equalTo(self.mas_centerX);
            make.bottom.mas_equalTo(-20*m6Scale);
        }];
    }
    
    return self;
}
/**
 *点击屏幕  让输入框消失
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.hidden = YES;
    self.textFiled.text = @"";
    [self.textFiled resignFirstResponder];
}

@end
