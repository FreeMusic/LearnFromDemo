//
//  ForgetPasswordView.m
//  CityJinFu
//
//  Created by 姜姜敏 on 16/10/19.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "ForgetPasswordView.h"

@interface ForgetPasswordView ()

@property (nonatomic, strong) NSMutableArray *textfieldArr; //存放textfield
@property (nonatomic, strong) NSMutableArray *textArr; //存放字符串



@end

@implementation ForgetPasswordView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self createView];
        
    }
    
    return self;
    
}

- (NSMutableArray *)textfieldArr {
    
    if (_textfieldArr == nil) {
        
        
        _textfieldArr = [NSMutableArray array];
    }
    
    return _textfieldArr;
}

- (NSMutableArray *)textArr {
    
    if (_textArr == nil) {
        
        
        _textArr = [NSMutableArray array];
    }
    
    return _textArr;
}

- (void)createView {
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    self.messageLabel = [[UILabel alloc] init];
    self.messageLabel.textColor = [UIColor grayColor];
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.phoneNum = [user objectForKey:@"userMobile"];
    self.messageLabel.numberOfLines = 0;
    self.messageLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:30 * m6Scale];
    [DownLoadData postUserInformation:^(id obj, NSError *error) {
        NSLog(@"%@",obj);
        
        self.messageLabel.text = [NSString stringWithFormat:@"验证码已发送至%@\n请输入验证码",self.phoneNum];//手机号
        
    } userId:[user objectForKey:@"userId"]];
    
    [self addSubview:self.messageLabel];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_top).offset(50 * m6Scale);
    }];
    
    self.cancelImageView = [[UIImageView alloc] init];
    self.cancelImageView.image = [UIImage imageNamed:@"calculatorCancel"];
    self.cancelImageView.userInteractionEnabled = YES;
    [self addSubview:self.cancelImageView];
    
    [self.cancelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.size.mas_equalTo(CGSizeMake(40 * m6Scale, 40 * m6Scale));
        make.top.equalTo(self.mas_top).offset(31 * m6Scale);
        make.right.equalTo(self.mas_right).offset(-35 * m6Scale);
    }];
    
    CALayer *messageLayer = [[CALayer alloc] init];
    messageLayer.frame = CGRectMake(0, 100 * m6Scale, kScreenWidth, 1 * m6Scale);
    messageLayer.backgroundColor = [UIColor colorWithRed:222 / 255.0 green:222 / 255.0 blue:222 / 255.0 alpha:1].CGColor;
    [self.layer addSublayer:messageLayer];
    
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.image = [UIImage imageNamed:@"frame"];
    [self addSubview:backImageView];
    
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.mas_left).offset(75 * m6Scale);
        make.top.equalTo(self.mas_top).offset(125 * m6Scale);
        make.size.mas_equalTo(CGSizeMake(612 * m6Scale, 103 * m6Scale));
    }];
    
    for (NSInteger i = 0; i < 6 ; i ++) {
        
        UITextField *textfield = [[UITextField alloc] init];
        textfield.secureTextEntry = YES;
        textfield.userInteractionEnabled = NO;
        textfield.textAlignment = NSTextAlignmentCenter;
        textfield.font = [UIFont systemFontOfSize:45 * m6Scale];
        [backImageView addSubview:textfield];
        
        [textfield mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.size.mas_equalTo(CGSizeMake(102 * m6Scale, 102 * m6Scale));
            make.top.equalTo(backImageView.mas_top);
            make.left.equalTo(backImageView.mas_left).offset(i * 102 * m6Scale);
        }];
        
        [self.textfieldArr addObject:textfield];
    }
    
    CALayer *clipLayer = [[CALayer alloc] init];
    clipLayer.frame = CGRectMake(0, 250 * m6Scale, kScreenWidth, 1 * m6Scale);
    clipLayer.backgroundColor = [UIColor colorWithRed:222 / 255.0 green:222 / 255.0 blue:222 / 255.0 alpha:1].CGColor;
    [self.layer addSublayer:clipLayer];
    
    self.reSendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.reSendButton setTitleColor:[UIColor colorWithRed:241 / 255.0 green:126 / 255.0 blue:60 / 255.0 alpha:1] forState:UIControlStateNormal];
    self.reSendButton.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:36 * m6Scale];
    [self.reSendButton setTitle:@"重新发送" forState:UIControlStateNormal];
    [self addSubview:self.reSendButton];
    
    [self.reSendButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self.mas_right).offset(- 44 * m6Scale);
        make.centerY.equalTo(self.mas_top).offset(304 * m6Scale);
        make.size.mas_equalTo(CGSizeMake(180 * m6Scale, 50 * m6Scale));
        
    }];
    
    CALayer *bottomLayer = [[CALayer alloc] init];
    bottomLayer.frame = CGRectMake(0, 354 * m6Scale, kScreenWidth, 1 * m6Scale);
    bottomLayer.backgroundColor = [UIColor colorWithRed:222 / 255.0 green:222 / 255.0 blue:222 / 255.0 alpha:1].CGColor;
    [self.layer addSublayer:bottomLayer];
    
            
}

- (void)setPasswordText:(NSString *)passwordText {
    
    [self.textArr removeAllObjects];
    
    _passwordText = passwordText;
    
    for (NSInteger i = 0; i < _passwordText.length; i ++) {
        
        NSRange range = NSMakeRange(i, 1);
        
        NSString *str = [_passwordText substringWithRange:range];
        
        [self.textArr addObject:str];
    }
    //清空所有textfield的值
    for (UITextField *text in self.textfieldArr) {
        
        text.text = nil;
    }
    
    for (NSInteger i = 0; i < self.textArr.count; i ++) {
        
        UITextField *textfield = self.textfieldArr[i];
        
        textfield.text = self.textArr[i];
    }
    
    
}





@end
