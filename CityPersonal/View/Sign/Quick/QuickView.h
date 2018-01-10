//
//  QuickView.h
//  CityJinFu
//
//  Created by xxlc on 16/8/25.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApiManager.h"

@interface QuickView : UIView <UITextFieldDelegate,TencentLoginDelegate,TencentWebViewDelegate,WXApiManagerDelegate>
@property (nonatomic, strong) UIImageView *cubeImageView;//立方体
@property (nonatomic, strong) UITextField *userTextFiled;//用户名
@property (nonatomic, strong) UITextField *verificationCodeTextFiled;//验证码
@property (nonatomic, strong) UIImageView *phoneImageView;//用户名图片
@property (nonatomic, strong) UIImageView *passWordImageView;//密码图片
@property (nonatomic, strong) UIButton *nextButton;//下一步按钮
@property (nonatomic, strong) UIButton *verificationCodeButton;//验证码按钮
@property (nonatomic, strong) UIButton *quickButton;//快速登录
@property (nonatomic, strong) UILabel *resgisterLabel;//注册
@property (nonatomic, strong) UIView *dividerView;//分割线
@property (nonatomic, strong) UIButton *wechatButton;//微信
@property (nonatomic, strong) UIButton *weiboButton;//微博
@property (nonatomic, strong) UIButton *qqButton;//QQ
@property (nonatomic,copy) NSString *presentTag;
@property (retain, nonatomic) TencentOAuth *tencentOAuth;

@end
