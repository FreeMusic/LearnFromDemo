//
//  MessageSignView.m
//  CityJinFu
//
//  Created by mic on 2017/10/11.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "MessageSignView.h"

@interface MessageSignView ()

@end

@implementation MessageSignView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        //密码登录按钮
        [self addSubview:self.pswButton];
        [self.pswButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-60*m6Scale);
            make.size.mas_equalTo(CGSizeMake(170*m6Scale, 40*m6Scale));
            make.bottom.mas_equalTo(-20*m6Scale);
        }];
        
        //单线
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.3];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(60*m6Scale);
            make.right.mas_equalTo(-60*m6Scale);
            make.height.mas_equalTo(1);
            make.bottom.mas_equalTo(self.pswButton.mas_top).offset(-40*m6Scale);
        }];
        
        //
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NewSign_验证码"]];
        [self addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(line.mas_left);
            make.size.mas_equalTo(CGSizeMake(40*m6Scale, 40*m6Scale));
            make.bottom.mas_equalTo(line.mas_top).offset(-20*m6Scale);
        }];
        
        //登录密码输入框
        [self addSubview:self.messageField];
        [self.messageField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(line.mas_left).offset(60*m6Scale);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(imgView.mas_bottom);
            make.height.mas_equalTo(40*m6Scale);
        }];
        
        //发送验证码按钮
        [self addSubview:self.verificationCodeButton];
        [self.verificationCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(line.mas_right);
            make.bottom.mas_equalTo(line.mas_top).offset(-20*m6Scale);
            make.size.mas_equalTo(CGSizeMake(150*m6Scale, 50*m6Scale));
        }];
    }
    
    return self;
}
/**
 *   登录密码输入框
 */
- (UITextField *)messageField{
    if(!_messageField){
        _messageField = [[UITextField alloc] init];
        _messageField.placeholder = @"请输入短信验证码";
        
        _messageField.font = [UIFont systemFontOfSize:34*m6Scale];
        _messageField.textColor = UIColorFromRGB(0x2a2a2a);
        
        [_messageField setValue:UIColorFromRGB(0xa0a0a0) forKeyPath:@"_placeholderLabel.textColor"];
        
    }
    return _messageField;
}

/**
 *  密码登录按钮
 */
- (UIButton *)pswButton{
    if(!_pswButton){
        _pswButton = [UIButton buttonWithType:0];
        
        [_pswButton setTitle:@"密码登录" forState:0];
        [_pswButton setTitleColor:UIColorFromRGB(0xa0a0a0) forState:0];
        _pswButton.titleLabel.font = [UIFont systemFontOfSize:30*m6Scale];
    }
    return _pswButton;
}
/**
 *  验证码按钮
 */
- (UIButton *)verificationCodeButton
{
    if (!_verificationCodeButton) {
        _verificationCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _verificationCodeButton.layer.masksToBounds = YES;
        [_verificationCodeButton setTitle:@"发送验证码" forState:0];
        [_verificationCodeButton setTitleColor:[UIColor colorWithWhite:0.2 alpha:0.3] forState:0];
        _verificationCodeButton.layer.cornerRadius = 5*m6Scale;
        _verificationCodeButton.layer.borderColor = [UIColor colorWithWhite:0.2 alpha:0.3].CGColor;
        _verificationCodeButton.titleLabel.font = [UIFont systemFontOfSize:30*m6Scale];
        _verificationCodeButton.layer.borderWidth = 1;
        
        _verificationCodeButton.clipsToBounds = YES;
    }
    return _verificationCodeButton;
}

@end
