//
//  NewSignPhoneView.m
//  CityJinFu
//
//  Created by mic on 2017/10/10.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "NewSignPhoneView.h"

@implementation NewSignPhoneView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        //下标单线
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = UIColorFromRGB(0xe7e7e7);
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.bottom.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(596*m6Scale, 1));
        }];
        
        //手机图标
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:@"NewSign_Phone"];
        [self addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(line.mas_left);
            make.bottom.mas_equalTo(-20*m6Scale);
            make.size.mas_equalTo(CGSizeMake(40*m6Scale, 40*m6Scale));
        }];
        
        //手机号码输入框
        [self addSubview:self.phoneFiled];
        [self.phoneFiled mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kScreenWidth-150*m6Scale);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(imgView.mas_bottom).offset(10*m6Scale);
            make.height.mas_equalTo(60*m6Scale);
        }];
    }
    
    return self;
    
}

/**
 *  手机号码输入框
 */
- (UITextField *)phoneFiled{
    if(!_phoneFiled){
        _phoneFiled = [[UITextField alloc] init];
        _phoneFiled.placeholder = @"请输入您的手机号码";
        
        _phoneFiled.font = [UIFont systemFontOfSize:34*m6Scale];
        _phoneFiled.textColor = UIColorFromRGB(0x2a2a2a);
        
        [_phoneFiled setValue:UIColorFromRGB(0xa0a0a0) forKeyPath:@"_placeholderLabel.textColor"];
    }
    return _phoneFiled;
}

@end
