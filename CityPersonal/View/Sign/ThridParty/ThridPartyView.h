//
//  ThridPartyView.h
//  CityJinFu
//
//  Created by xxlc on 16/8/25.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GXJButton.h"

@interface ThridPartyView : UIView <UITextFieldDelegate>
@property (nonatomic, strong) UIImageView *cubeImageView;//立方体
@property (nonatomic, strong) UITextField *userTextFiled;//用户名
@property (nonatomic, strong) UITextField *verificationCodeTextFiled;//验证码
@property (nonatomic, strong) UIImageView *phoneImageView;//用户名图片
@property (nonatomic, strong) UIImageView *passWordImageView;//密码图片
@property (nonatomic, strong) UIButton *nextButton;//下一步按钮
@property (nonatomic, strong) GXJButton *verificationCodeButton;//验证码按钮
@end
