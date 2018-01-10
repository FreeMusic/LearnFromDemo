//
//  NewPhoneView.m
//  CityJinFu
//
//  Created by xxlc on 16/8/19.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "NewPhoneView.h"

@implementation NewPhoneView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self creatView];//创建布局
    }
    return self;
}
/**
 *  创建布局
 */
- (void)creatView{
    
    [self addSubview:self.PhoneText];
    [self addSubview:self.verificationCodeText];
    [self.verificationCodeText addSubview:self.verificationCodeBtn];
    [self addSubview:self.sureButton];
    //获取验证码
    [_verificationCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_verificationCodeText.mas_right).offset(-20*m6Scale);
        make.centerY.equalTo(_verificationCodeText.mas_centerY);
        make.height.mas_equalTo(@(57*m6Scale));
    }];
    //分割线
    _dividerView = [UIView new];
    _dividerView.backgroundColor = titleColor;
    [self.verificationCodeText addSubview:self.dividerView];
    [_dividerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_verificationCodeBtn.mas_left).offset(-10*m6Scale);
        make.centerY.equalTo(_verificationCodeText.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(1, 57*m6Scale));
    }];
}
/**
 *  新的手机号
 */
- (UITextField *)PhoneText
{
    if (!_PhoneText) {
        _PhoneText = [CustomTextField new];
        _PhoneText.frame = CGRectMake(0, 155*m6Scale, kScreenWidth, 106*m6Scale);
        _PhoneText.backgroundColor = [UIColor whiteColor];
        _PhoneText.tag = 10;
        _PhoneText.delegate = self;
        _PhoneText.textAlignment = NSTextAlignmentLeft;
        _PhoneText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入新的手机号码" attributes:@{NSForegroundColorAttributeName: titleColor}];
        [_PhoneText setValue:[UIFont boldSystemFontOfSize:33*m6Scale] forKeyPath:@"_placeholderLabel.font"];
    }
    return _PhoneText;
}
/**
 *  验证码
 */
- (UITextField *)verificationCodeText
{
    if (!_verificationCodeText) {
        _verificationCodeText = [CustomTextField new];
        _verificationCodeText.frame = CGRectMake(0, 265*m6Scale, kScreenWidth, 106*m6Scale);
        _verificationCodeText.backgroundColor = [UIColor whiteColor];
        _verificationCodeText.tag = 20;
        _verificationCodeText.delegate = self;
        _verificationCodeText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:@{NSForegroundColorAttributeName: titleColor}];
        [_verificationCodeText setValue:[UIFont boldSystemFontOfSize:33*m6Scale] forKeyPath:@"_placeholderLabel.font"];
    }
    return _verificationCodeText;
}
/**
 *  验证码按钮
 */
- (UIButton *)verificationCodeBtn{
    
    if (!_verificationCodeBtn) {
        //验证码按钮
        _verificationCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_verificationCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_verificationCodeBtn setTitleColor:[UIColor colorWithRed:12/255.0 green:153/255.0 blue:241/255.0 alpha:1.0] forState:UIControlStateNormal];
        _verificationCodeBtn.titleLabel.font = [UIFont systemFontOfSize:39*m6Scale];
    }
    return _verificationCodeBtn;
}
/**
 *  确定按钮
 */
- (UIButton *)sureButton
{
    if (!_sureButton) {
        _sureButton = [SubmitBtn buttonWithType:UIButtonTypeCustom];
        _sureButton.frame = CGRectMake(42*m6Scale, 430*m6Scale, 666*m6Scale, 90*m6Scale);
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
    }
    return _sureButton;
}
/**
 *  第一响应者
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _PhoneText) {
        return [self.PhoneText resignFirstResponder];
    }
    else{
        return [self.verificationCodeText resignFirstResponder];
    }
}
/**
 *  文本框的内容是否符合要求
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    UITextField *text = (UITextField *)[self viewWithTag:10];
    if (text == textField) {
        if (range.location >= 11) {
            return NO;
        }
        return YES;
    }
    else{
        if (range.location >= 6) {
            return NO;
        }
        return YES;
    }
}
/**
 *  用户点击空白区域键盘的隐藏
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.PhoneText resignFirstResponder];
    [self.verificationCodeText resignFirstResponder];
}


@end
