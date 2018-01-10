//
//  BackPasswordView.m
//  CityJinFu
//
//  Created by xxlc on 16/8/17.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "BackPasswordView.h"


@implementation BackPasswordView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self createView];//创建布局
    }
    return self;
}
/**
 *  创建界面布局
 */
- (void)createView
{
    [self addSubview:self.passWordImageView];
    [self addSubview:self.phoneImageView];
    [self addSubview:self.userTextFiled];
    [self addSubview:self.verificationCodeTextFiled];
    [self addSubview:self.verificationCodeButton];
    [self addSubview:self.surePasswordImage];
    [self addSubview:self.sureTextField];
    [self addSubview:self.passwordbutton];
    [self addSubview:self.sureButton];
    // 用户名
    [_phoneImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(85*m6Scale);
        make.size.mas_equalTo(CGSizeMake(40*m6Scale, 40*m6Scale));
        make.top.equalTo(self.mas_top).offset(437*m6Scale-150);
    }];
    [self.userTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneImageView.mas_right).offset(15*m6Scale);
        make.top.mas_equalTo(_phoneImageView.mas_top).offset(-10*m6Scale);
        make.right.equalTo(-80*m6Scale);
        make.height.mas_equalTo(@(60*m6Scale));
    }];
    //密码
    [self.passWordImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(85*m6Scale);
        make.size.mas_equalTo(CGSizeMake(40*m6Scale, 40*m6Scale));
        make.top.equalTo(_phoneImageView.mas_bottom).offset(60*m6Scale);
    }];
    [self.verificationCodeTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_passWordImageView.mas_right).offset(15*m6Scale);
        make.top.mas_equalTo(self.passWordImageView.mas_top).offset(-10*m6Scale);
        make.right.equalTo(-80*m6Scale);
        make.height.mas_equalTo(@(60*m6Scale));
    }];
    //验证码
    [_verificationCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-80*m6Scale);
        make.height.mas_equalTo(@(68 * m6Scale));
        make.bottom.equalTo(_passWordImageView.mas_bottom).offset(4*m6Scale);
        make.width.mas_equalTo(@(206 * m6Scale));
    }];
    //确认密码
    [_surePasswordImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(85*m6Scale);
        make.size.mas_equalTo(CGSizeMake(40*m6Scale, 40*m6Scale));
        make.top.equalTo(_passWordImageView.mas_bottom).offset(60*m6Scale);
    }];
    [_sureTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_surePasswordImage.mas_right).offset(15*m6Scale);
        make.top.mas_equalTo(_surePasswordImage.mas_top).offset(-10*m6Scale);
        make.width.mas_equalTo(@(400 * m6Scale));
        make.height.mas_equalTo(@(60*m6Scale));
    }];
    //确定
    [_sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset((kScreenWidth - 600*m6Scale) / 2);
        make.right.equalTo(self.mas_right).offset(-(kScreenWidth - 600*m6Scale) / 2);
        make.top.equalTo(_surePasswordImage.mas_bottom).offset(60*m6Scale);
        make.height.mas_equalTo(@(90*m6Scale));
    }];

    for (int i = 0; i < 3; i++) {
        UIView *lineTop = [[UIView alloc] init];
        lineTop.backgroundColor = UIColorFromRGB(0xe7e7e7);
        [self addSubview:lineTop];
        [lineTop mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.phoneImageView.mas_left);
            make.right.mas_equalTo(self.userTextFiled.mas_right);
            make.top.mas_equalTo(self.phoneImageView.mas_bottom).offset(20*m6Scale+i*100*m6Scale);
            make.height.mas_equalTo(1);
        }];
    }
}
/**
 *  立方体
 */
- (UIImageView *)cubeImageView
{
    if (!_cubeImageView) {
        _cubeImageView = [Factory imageView:@"thumb@2x"];
    }
    return _cubeImageView;
}
/**
 *   用户名
 *
 *  @return userTextFiled
 */
- (UITextField *)userTextFiled
{
    if (!_userTextFiled) {
        _userTextFiled = [[UITextField alloc] init];
        _userTextFiled.placeholder = @"请输入手机号";
        _userTextFiled.font = [UIFont systemFontOfSize:32*m6Scale];
        _userTextFiled.delegate = self;
        _userTextFiled.keyboardType = UIKeyboardTypeNumberPad;
        //定制的键盘
        KeyBoard *key = [[KeyBoard alloc]init];
        UIView *clip = [key keyBoardview];
        [key.doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
        
        _userTextFiled.inputAccessoryView = clip;
    }
    return _userTextFiled;
}
- (UIImageView *)phoneImageView
{
    if (!_phoneImageView) {
        _phoneImageView = [Factory imageView:@"NewSign_Phone"];
    }
    return _phoneImageView;
}
/**
 *  密码
 */
- (UITextField *)verificationCodeTextFiled
{
    if (!_verificationCodeTextFiled) {
        _verificationCodeTextFiled = [[UITextField alloc] init];
        _verificationCodeTextFiled.placeholder = @"请输入验证码";
        _verificationCodeTextFiled.font = [UIFont systemFontOfSize:32*m6Scale];
        _verificationCodeTextFiled.delegate = self;
        _verificationCodeTextFiled.keyboardType = UIKeyboardTypeNumberPad;
        //定制的键盘
        KeyBoard *key = [[KeyBoard alloc]init];
        UIView *clip = [key keyBoardview];
        [key.doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
        
        _verificationCodeTextFiled.inputAccessoryView = clip;
    }
    return _verificationCodeTextFiled;
}
/**
 *  验证码图标
 */
- (UIImageView *)passWordImageView
{
    if (!_passWordImageView) {
        _passWordImageView = [Factory imageView:@"NewSign_验证码"];
    }
    return _passWordImageView;
}
/**
 *  验证码按钮
 */
- (UIButton *)verificationCodeButton
{
    if (!_verificationCodeButton) {
        _verificationCodeButton = [GXJButton buttonWithType:UIButtonTypeCustom];
        _verificationCodeButton.layer.cornerRadius = 5*m6Scale;
        _verificationCodeButton.backgroundColor = [UIColor whiteColor];
        _verificationCodeButton.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:0.2].CGColor;
        _verificationCodeButton.layer.borderWidth = 1;
        [_verificationCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        _verificationCodeButton.titleLabel.font = [UIFont systemFontOfSize:33*m6Scale];
        _verificationCodeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_verificationCodeButton setTitleColor:UIColorFromRGB(0x949494) forState:UIControlStateNormal];
        _verificationCodeButton.time = 2.0;
    }
    return _verificationCodeButton;
}
/**
 *  新的密码
 */
- (UIImageView *)surePasswordImage
{
    if (!_surePasswordImage) {
        _surePasswordImage = [Factory imageView:@"NewSign_密码"];
    }
    return _surePasswordImage;
}
/**
 *  密码的隐藏和显示
 */
- (UIButton *)passwordbutton
{
    if (!_passwordbutton) {
        _passwordbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_passwordbutton setImage:[UIImage imageNamed:@"隐藏密码"] forState:UIControlStateNormal];
        [_passwordbutton setImage:[UIImage imageNamed:@"显示密码"] forState:UIControlStateSelected];
        [_passwordbutton addTarget:self action:@selector(passwordbutton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _passwordbutton;
}

- (UITextField *)sureTextField
{
    if (!_sureTextField) {
        _sureTextField = [[UITextField alloc] init];
        _sureTextField.placeholder = @"请输入新的密码(6位~16位)";
        _sureTextField.font = [UIFont systemFontOfSize:32*m6Scale];
        _sureTextField.secureTextEntry = YES;
        _sureTextField.delegate = self;
        _sureTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        //定制的键盘
        KeyBoard *key = [[KeyBoard alloc]init];
        UIView *clip = [key keyBoardview];
        [key.doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
        
        _sureTextField.inputAccessoryView = clip;
    }
    return _sureTextField;
}
/**
 *  登录按钮
 */
- (UIButton *)sureButton
{
    if (!_sureButton) {
        _sureButton = [SubmitBtn buttonWithType:UIButtonTypeCustom];
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
    }
    return _sureButton;
}
/**
 *  密码显示的切换
 */
- (void)passwordbutton:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.sureTextField.secureTextEntry = NO;
    }else{
        self.sureTextField.secureTextEntry = YES;
    }
}
/**
 *  第一响应者
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _userTextFiled) {
        return [self.userTextFiled resignFirstResponder];
    }
    else if (textField == _verificationCodeTextFiled)
    {
        return [self.verificationCodeTextFiled resignFirstResponder];
    }else{
        return [self.sureTextField resignFirstResponder];
    }
}
/**
 *  文本框的内容是否符合要求
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    UITextField *text = (UITextField *)[self viewWithTag:10];
    UITextField *text1 = (UITextField *)[self viewWithTag:20];

//    NSString *resultStr;
//    if ([string isEqualToString:@""]) {
//        //获取到上一次操作的字符串长度
//        NSInteger clip = textField.text.length;
//        //截取字符串 将最后一个字符删除
//        resultStr = [textField.text substringToIndex:clip - 1];
//        
//    } else {
//        resultStr = [textField.text stringByAppendingString:string];
//    }

    if (text == textField) {
//        self.clearPwdTF.hidden = YES;
//        self.clearVerTF.hidden = YES;
//        
//        if (range.location == -1 || resultStr.length == 0) {
//            self.clearUserTF.hidden = YES;
//        } else {
//            self.clearUserTF.hidden = NO;
//        }
        if (range.location >= 11) {
            return NO;
        }
        return YES;
    }
    else if(text1 == textField){
//        self.clearUserTF.hidden = YES;
//        self.clearVerTF.hidden = YES;
//        
//        if (range.location == -1 || resultStr.length == 0) {
//            self.clearPwdTF.hidden = YES;
//        } else {
//            self.clearPwdTF.hidden = NO;
//
//        }
        if (range.location >= 6) {
            return NO;
        }
        return YES;
    }
    else{
//        self.clearUserTF.hidden = YES;
//        self.clearPwdTF.hidden = YES;
//        if (range.location == -1 || resultStr.length == 0) {
//            self.clearVerTF.hidden = YES;
//        } else {
//            self.clearVerTF.hidden = NO;
//        }
        if (range.location >=16) {
            return NO;
        }
        return YES;
    }
}

//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
//    UITextField *text = (UITextField *)[self viewWithTag:10];
//    UITextField *text1 = (UITextField *)[self viewWithTag:20];
//
//    if (text == textField) {
//        self.clearUserTF.hidden = YES;
//    } else if (text1 == textField) {
//        self.clearPwdTF.hidden = YES;
//    }
//    else {
//        self.clearVerTF.hidden = YES;
//    }
//    return YES;
//}

/**
 *  清楚输入框中的内容
 */
//- (void) cleUserText {
//    
//    self.userTextFiled.text = nil;
//    self.clearUserTF.hidden = YES;
//}
//
//- (void)clearPwdText {
//    self.clearPwdTF.hidden = YES;
//    self.verificationCodeTextFiled.text = nil;
//}
//
//- (void)clearVerText {
//    self.clearVerTF.hidden = YES;
//    self.sureTextField.text = nil;
//
//}
/**
 *  用户点击空白区域键盘的隐藏
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.userTextFiled resignFirstResponder];
    [self.verificationCodeTextFiled resignFirstResponder];
    [self.sureTextField resignFirstResponder];
}
/**
 *  键盘消失
 */
- (void)doneButton:(UIButton *)button {
    
    [self endEditing:YES];
    
}


@end
