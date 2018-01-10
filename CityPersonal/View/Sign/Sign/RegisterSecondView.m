//
//  RegisterSecondView.m
//  CityJinFu
//
//  Created by 姜姜敏 on 16/10/10.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "RegisterSecondView.h"



@implementation RegisterSecondView

- (instancetype)initWithFrame:(CGRect)frame {
    
    
    if (self = [super initWithFrame:frame]) {
        
        [self creatView];
    }
    
    return self;
}

/**
 *  创建布局
 */
- (void)creatView{
    
    [self addSubview:self.cubeImageView];
    [self addSubview:self.passWordImageView];
    [self addSubview:self.passwordTextFiled];
    [self addSubview:self.sureButton];
    [self.passWordImageView addSubview:self.passwordbutton];
    //立方体
    [_cubeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(185*m6Scale);
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(142*m6Scale, 152*m6Scale));
    }];
    //密码
    [self.passWordImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(85*m6Scale);
        make.right.equalTo(self.mas_right).offset(-85*m6Scale);
        make.height.mas_equalTo(@(117*m6Scale));
        make.top.equalTo(_cubeImageView.mas_bottom).offset(80*m6Scale);
    }];
    
    //密码的显示和隐藏
    [_passwordbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_passWordImageView.mas_right).offset(10*m6Scale);
        make.centerY.equalTo(_passWordImageView.mas_centerY).offset(10 * m6Scale);
        make.size.mas_equalTo(CGSizeMake(120*m6Scale, 120*m6Scale));
    }];
    
    [self.passwordTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_passWordImageView.mas_left).offset(100*m6Scale);
        if (iPhone5) {
            make.centerY.equalTo(self.passWordImageView.mas_centerY).offset(18.5 * m6Scale);
        } else {
            make.centerY.equalTo(self.passWordImageView.mas_centerY).offset(13.5 * m6Scale);
        }
        make.right.equalTo(_passwordbutton.mas_left).offset(-10 * m6Scale);
        make.height.mas_equalTo(@(60*m6Scale));
    }];
    //确定
    [_sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset((kScreenWidth - 600*m6Scale) / 2);
        make.right.equalTo(self.mas_right).offset(-(kScreenWidth - 600*m6Scale) / 2);
        make.top.equalTo(_passWordImageView.mas_bottom).offset(100 * m6Scale);
        make.height.mas_equalTo(@(90*m6Scale));
    }];
}
/**
 *  立方体
 *
 *  @return cubeImageView
 */
- (UIImageView *)cubeImageView
{
    if (!_cubeImageView) {
        _cubeImageView = [Factory imageView:@"thumb"];
    }
    return _cubeImageView;
}
/**
 *  密码
 */
- (UITextField *)passwordTextFiled
{
    if (!_passwordTextFiled) {
        _passwordTextFiled = [HCJFTextField textStr:@"请输入密码(6位~16位)" andTag:10 andFont:30*m6Scale];
        _passwordTextFiled.delegate = self;
        _passwordTextFiled.adjustsFontSizeToFitWidth = YES;
        _passwordTextFiled.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
    return _passwordTextFiled;
}
- (UIImageView *)passWordImageView
{
    if (!_passWordImageView) {
        _passWordImageView = [Factory imageView:@"lock-"];
    }
    return _passWordImageView;
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
        self.passwordTextFiled.secureTextEntry = NO;
    }else{
        self.passwordTextFiled.secureTextEntry = YES;
    }
}
/**
 *  文本框的内容是否符合要求
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *resultStr;
    if ([string isEqualToString:@""]) {
        //获取到上一次操作的字符串长度
        NSInteger clip = textField.text.length;
        //截取字符串 将最后一个字符删除
        resultStr = [textField.text substringToIndex:clip - 1];
        
    } else {
        resultStr = [textField.text stringByAppendingString:string];
    }

    if (range.location == -1 || resultStr.length == 0 ) {
        self.clearPwdTF.hidden = YES;
    } else {
        self.clearPwdTF.hidden = NO;
    }
        if (range.location >= 16) {
            return NO;
        }
        return YES;
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    self.clearPwdTF.hidden = YES;
    return YES;
}

/**
 *  清楚输入框中的内容
 */
- (void)clearPText {
    
    self.clearPwdTF.hidden = YES;
    self.passwordTextFiled.text = nil;
}

@end
