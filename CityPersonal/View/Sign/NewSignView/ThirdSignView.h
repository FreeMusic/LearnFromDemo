//
//  ThirdSignView.h
//  CityJinFu
//
//  Created by mic on 2017/10/10.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApiManager.h"

@interface ThirdSignView : UIView <UITextFieldDelegate,TencentLoginDelegate,TencentWebViewDelegate,WXApiManagerDelegate>

@property (nonatomic, strong) UIButton *blogButton;//微博登录按钮

@property (nonatomic, strong) UIButton *weChatButton;//微信登录按钮

@property (nonatomic, strong) UIButton *qqbutton;///QQ登录按钮

@property (retain, nonatomic) TencentOAuth *tencentOAuth;

@property (nonatomic, strong) NSString *presentTag;

@end
