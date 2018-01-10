//
//  MessageSignView.h
//  CityJinFu
//
//  Created by mic on 2017/10/11.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VerCodeBtn.h"

@interface MessageSignView : UIView

@property (nonatomic, strong) UITextField *messageField;//短信验证码输入框

@property (nonatomic, strong) UIButton *pswButton;//密码登录按钮

@property (nonatomic, strong) UIButton *verificationCodeButton;

@end
