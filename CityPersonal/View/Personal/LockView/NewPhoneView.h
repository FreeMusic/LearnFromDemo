//
//  NewPhoneView.h
//  CityJinFu
//
//  Created by xxlc on 16/8/19.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewPhoneView : UIView <UITextFieldDelegate>
@property (nonatomic, strong) UITextField *PhoneText;
@property (nonatomic, strong) UITextField *verificationCodeText;//验证码
@property (nonatomic, strong) UIButton *verificationCodeBtn;//验证码按钮
@property (nonatomic, strong) UIButton *sureButton;//确定按钮
@property (nonatomic, strong) UIView *dividerView;//分割线

@end
