//
//  RegisterView.h
//  CityJinFu
//
//  Created by xxlc on 16/8/16.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GXJButton.h"

@interface RegisterView : UIView <UITextFieldDelegate>
@property (nonatomic, strong) UIImageView *cubeImageView;//立方体
@property (nonatomic, strong) UITextField *userTextFiled;//用户名
@property (nonatomic, strong) UITextField *verificationCodeTextFiled;//验证码
@property (nonatomic, strong) UIImageView *phoneImageView;//用户名图片
@property (nonatomic, strong) UIImageView *passWordImageView;//密码图片
@property (nonatomic, strong) UIImageView *inviteImgView;//邀请码图片
@property (nonatomic, strong) UITextField *inviteTextFiled;//邀请码输入框
@property (nonatomic, strong) UIButton *nextButton;//下一步按钮
@property (nonatomic, strong) GXJButton *verificationCodeButton;//验证码按钮
@property (nonatomic, strong) UIButton *selectButton;//协议选择按钮
@property (nonatomic, strong) UILabel *agreementLabel;//协议
@property (nonatomic, strong) UILabel *resgisterLabel;//注册
@property (nonatomic, strong) UILabel *servicephoneLabel;//客服电话
@property (nonatomic, strong) UILabel *serviceTimeLabel;//客服时间

//@property (nonatomic, strong) UIButton *clearUserTF;
//@property (nonatomic, strong) UIButton *clearPwdTF;

@end
