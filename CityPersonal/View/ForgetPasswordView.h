//
//  ForgetPasswordView.h
//  CityJinFu
//
//  Created by 姜姜敏 on 16/10/19.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetPasswordView : UIView

@property (nonatomic, strong) UIButton *reSendButton; //发送验证码

@property (nonatomic, copy) NSString *passwordText; //验证码
@property (nonatomic, copy) NSString *phoneNum; //手机号
@property (nonatomic, strong) UIImageView *cancelImageView; //取消

@property (nonatomic, strong) UILabel *messageLabel;
@end
