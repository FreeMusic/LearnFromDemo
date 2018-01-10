//
//  SignPasswordView.m
//  CityJinFu
//
//  Created by mic on 2017/10/11.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "SignPasswordView.h"
#import "BackPasswordViewController.h"

@implementation SignPasswordView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        //忘记密码按钮
        [self addSubview:self.forgetButton];
        [self.forgetButton addTarget:self action:@selector(backPassword) forControlEvents:UIControlEventTouchUpInside];
        [self.forgetButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(60*m6Scale);
            make.size.mas_equalTo(CGSizeMake(170*m6Scale, 40*m6Scale));
            make.bottom.mas_equalTo(-20*m6Scale);
        }];
        
        //短信登录按钮
        [self addSubview:self.messageButton];
        [self.messageButton mas_makeConstraints:^(MASConstraintMaker *make) {
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
            make.bottom.mas_equalTo(self.messageButton.mas_top).offset(-40*m6Scale);
        }];
        
        //金锁按钮
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NewSign_密码"]];
        [self addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(line.mas_left);
            make.size.mas_equalTo(CGSizeMake(40*m6Scale, 40*m6Scale));
            make.bottom.mas_equalTo(line.mas_top).offset(-20*m6Scale);
        }];
        
        //登录密码输入框
        [self addSubview:self.pswField];
        [self.pswField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(line.mas_left).offset(60*m6Scale);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(imgView.mas_bottom);
            make.height.mas_equalTo(40*m6Scale);
        }];
        
        //密码明密文开关按钮
        UIButton *button = [UIButton buttonWithType:0];
        
        [button setImage:[UIImage imageNamed:@"NewSign_可见"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"NewSign_不可见"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(line.mas_right);
            make.size.mas_equalTo(CGSizeMake(40*m6Scale, 40*m6Scale));
            make.bottom.mas_equalTo(line.mas_top).offset(-20*m6Scale);
        }];
    }
    
    return self;
}
/**
 *  backPassword  找回密码
 */
- (void)backPassword{
    
    UIViewController *VC = (UIViewController *)[self ViewController];
    BackPasswordViewController *tempVC = [[BackPasswordViewController alloc] init];
    
    [VC presentViewController:tempVC animated:YES completion:nil];
    
}
/**
 *   登录密码输入框
 */
- (UITextField *)pswField{
    if(!_pswField){
        _pswField = [[UITextField alloc] init];
        _pswField.placeholder = @"请输入登录密码";
        
        _pswField.font = [UIFont systemFontOfSize:34*m6Scale];
        _pswField.textColor = UIColorFromRGB(0x2a2a2a);
        
        [_pswField setValue:UIColorFromRGB(0xa0a0a0) forKeyPath:@"_placeholderLabel.textColor"];
        
    }
    return _pswField;
}
/**
 *  忘记密码按钮
 */
- (UIButton *)forgetButton{
    if(!_forgetButton){
        _forgetButton = [UIButton buttonWithType:0];
        
        [_forgetButton setTitle:@"忘记密码" forState:0];
        [_forgetButton setTitleColor:UIColorFromRGB(0xa0a0a0) forState:0];
        _forgetButton.titleLabel.font = [UIFont systemFontOfSize:30*m6Scale];
    }
    return _forgetButton;
}
/**
 *  短信登录按钮
 */
- (UIButton *)messageButton{
    if(!_messageButton){
        _messageButton = [UIButton buttonWithType:0];
        
        [_messageButton setTitle:@"短信登录" forState:0];
        [_messageButton setTitleColor:UIColorFromRGB(0xff5933) forState:0];
        _messageButton.titleLabel.font = [UIFont systemFontOfSize:30*m6Scale];
    }
    return _messageButton;
}

/**
 *   密码明密文开关按钮
 */
- (void)buttonClick:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        
        self.pswField.secureTextEntry = YES;
        
    }else{
        
        self.pswField.secureTextEntry = NO;
        
    }
    
}

@end
