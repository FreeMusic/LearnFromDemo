//
//  CreatView.h
//  CityJinFu
//
//  Created by xxlc on 16/9/27.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreatView : UIView <UITextFieldDelegate>
@property (nonatomic, strong) UITextField *textField;//验证码
@property (nonatomic, strong) UIButton *verificationCodeButton;//验证码按钮
@property (nonatomic, strong) UIButton *sureBtn;//确定按钮
@property (nonatomic, strong) NSString *phoneStr;//手机号


@end
