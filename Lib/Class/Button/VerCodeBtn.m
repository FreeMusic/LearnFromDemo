//
//  VerCodeBtn.m
//  CityJinFu
//
//  Created by xxlc on 16/8/28.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "VerCodeBtn.h"

@implementation VerCodeBtn

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = [UIColor colorWithRed:227/255.0 green:174/255.0 blue:39/255.0 alpha:1];
        self.backgroundColor = ButtonColor;
        [self setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:33*m6Scale];
//        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return self;
}

@end
