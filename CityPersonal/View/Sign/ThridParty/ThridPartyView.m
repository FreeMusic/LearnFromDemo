//
//  ThridPartyView.m
//  CityJinFu
//
//  Created by xxlc on 16/8/25.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "ThridPartyView.h"

@implementation ThridPartyView

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
    [self addSubview:self.cubeImageView];
    [self addSubview:self.passWordImageView];
    [self addSubview:self.phoneImageView];
    [self addSubview:self.userTextFiled];
    [self addSubview:self.verificationCodeTextFiled];
    [self addSubview:self.verificationCodeButton];
    [self addSubview:self.nextButton];
    
//    //立方体
//    _cubeImageView.frame = CGRectMake(0, 0, 142 * m6Scale, 152 * m6Scale);
//    _cubeImageView.center = CGPointMake(kScreenWidth / 2, 261 * m6Scale);
    // 用户名
    [_phoneImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(85*m6Scale);
        make.size.mas_equalTo(CGSizeMake(40*m6Scale, 40*m6Scale));
        make.top.equalTo(self.mas_top).offset(437*m6Scale-100);
    }];
    [self.userTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneImageView.mas_right).offset(20*m6Scale);
        make.top.mas_equalTo(self.phoneImageView.mas_top).offset(-8*m6Scale);
        make.right.equalTo(-50*m6Scale);
        make.height.mas_equalTo(@(60*m6Scale));
    }];
    
    UIView *lineTop = [[UIView alloc] init];
    lineTop.backgroundColor = UIColorFromRGB(0xe7e7e7);
    [self addSubview:lineTop];
    [lineTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.phoneImageView.mas_left);
        make.right.mas_equalTo(self.userTextFiled.mas_right);
        make.top.mas_equalTo(self.phoneImageView.mas_bottom).offset(20*m6Scale);
        make.height.mas_equalTo(1);
    }];
    
    //密码
    [self.passWordImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(85*m6Scale);
        make.size.mas_equalTo(CGSizeMake(40*m6Scale, 40*m6Scale));
        make.top.equalTo(_phoneImageView.mas_bottom).offset(60*m6Scale);
    }];
    //验证码/
    [_verificationCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-50*m6Scale);
        make.top.equalTo(_phoneImageView.mas_bottom).offset(40*m6Scale);
        make.height.mas_equalTo(@(63 * m6Scale));
        make.width.mas_equalTo(@(206 * m6Scale));
    }];
    [self.verificationCodeTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.passWordImageView.mas_right).offset(20*m6Scale);
        make.top.mas_equalTo(self.passWordImageView.mas_top).offset(-8*m6Scale);
        make.right.equalTo(-50*m6Scale);
        make.height.mas_equalTo(@(60*m6Scale));
    }];
    UIView *lineBottom = [[UIView alloc] init];
    lineBottom.backgroundColor = UIColorFromRGB(0xe7e7e7);
    [self addSubview:lineBottom];
    [lineBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.passWordImageView.mas_left);
        make.right.mas_equalTo(self.verificationCodeButton.mas_right);
        make.top.mas_equalTo(self.passWordImageView.mas_bottom).offset(20*m6Scale);
        make.height.mas_equalTo(1);
    }];
    //登录
    [_nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset((kScreenWidth - 600*m6Scale) / 2);
        make.right.equalTo(self.mas_right).offset(-(kScreenWidth - 600*m6Scale) / 2);
        make.top.equalTo(_passWordImageView.mas_bottom).offset(80*m6Scale);
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
        _cubeImageView = [UIImageView new];
        _cubeImageView.image = [UIImage imageNamed:@"thumb"];
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
        _userTextFiled = [[UITextField alloc]init];
        _userTextFiled.font = [UIFont systemFontOfSize:32*m6Scale];
        _userTextFiled.placeholder = @"请输入手机号";
        //_userTextFiled = [HCJFTextField textStr:@"请输入手机号" andTag:10 andFont:30*m6Scale];
        _userTextFiled.keyboardType = UIKeyboardTypeNumberPad;
        _userTextFiled.delegate = self;
        _userTextFiled.textColor = UIColorFromRGB(0x2a2a2a);
    }
    return _userTextFiled;
}
- (UIImageView *)phoneImageView
{
    if (!_phoneImageView) {
        _phoneImageView = [UIImageView new];
        _phoneImageView.image = [UIImage imageNamed:@"NewSign_Phone"];
        _phoneImageView.userInteractionEnabled = YES;
    }
    return _phoneImageView;
}
/**
 *  密码
 */
- (UITextField *)verificationCodeTextFiled
{
    if (!_verificationCodeTextFiled) {
        _verificationCodeTextFiled = [UITextField new];
        _verificationCodeTextFiled.font = [UIFont systemFontOfSize:32*m6Scale];
        _verificationCodeTextFiled.placeholder = @"请输入验证码";
        //_verificationCodeTextFiled = [HCJFTextField textStr:@"请输入验证码" andTag:10 andFont:30*m6Scale];
        _verificationCodeTextFiled.returnKeyType = UIReturnKeyDone;
        _verificationCodeTextFiled.keyboardType = UIKeyboardTypeNumberPad;
        _verificationCodeTextFiled.delegate = self;
        _verificationCodeTextFiled.textColor = UIColorFromRGB(0x2a2a2a);
    }
    return _verificationCodeTextFiled;
}
- (UIImageView *)passWordImageView
{
    if (!_passWordImageView) {
        _passWordImageView = [UIImageView new];
        _passWordImageView.image = [UIImage imageNamed:@"NewSign_验证码"];
        _passWordImageView.userInteractionEnabled = YES;
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
 *  下一步
 */
- (UIButton *)nextButton
{
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextButton setTitle:@"绑定" forState:UIControlStateNormal];
        _nextButton.titleLabel.font = [UIFont systemFontOfSize:44*m6Scale];
        _nextButton.backgroundColor = ButtonColor;
        _nextButton.layer.cornerRadius = 5;
    }
    return _nextButton;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *text;
    
    if ([string isEqualToString:@""] || [string integerValue] || [string isEqualToString:@"0"]) {
        
        if ([string isEqualToString:@""]) {
            //获取到上一次操作的字符串长度
            NSInteger clip = textField.text.length;
            //截取字符串 将最后一个字符删除
            text = [textField.text substringToIndex:clip - 1];
            
        }else {
            
            text = [textField.text stringByAppendingString:string];
        }
    }
    
    if (text.length > 11) {
        
        return NO;
    
    }else {
        
        
        return YES;
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    NSLog(@"%@",textField);
    
    if (textField == self.userTextFiled) {
        
        
        return [self.userTextFiled resignFirstResponder];
    }else {
        
        
        return [self.verificationCodeTextFiled resignFirstResponder];
    }
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.userTextFiled resignFirstResponder];
    
    [self.verificationCodeTextFiled resignFirstResponder];
}

@end
