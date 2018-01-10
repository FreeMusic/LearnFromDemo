//
//  SignView.m
//  CityJinFu
//
//  Created by xxlc on 16/8/16.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "SignView.h"
#import "RegisterViewController.h"
#import "BackPasswordViewController.h"
#import "QuickVC.h"
#import "WeiboSDK.h"
#import "WXApiRequestHandler.h"
#import "ThirdPartLoginViewController.h"
#import "AppDelegate.h"
#import "NewSignVC.h"

@implementation SignView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self createView];//创建布局
    }
    return self;
}
/**
 *  创建界面布局
 */
- (void)createView
{
    
    _signButton = [GXJButton buttonWithType:UIButtonTypeCustom];
    [_signButton setTitle:@"登录" forState:UIControlStateNormal];
    _signButton.layer.cornerRadius = 5.0;
    _signButton.time = 2.0;

    [self addSubview:self.cubeImageView];
    [self addSubview:self.passWordImageView];
    [self addSubview:self.phoneImageView];
    [self.phoneImageView addSubview:self.userTextFiled];
    [self.passWordImageView addSubview:self.passwordTextFiled];
    [self.passWordImageView addSubview:self.passwordbutton];
    [self addSubview:self.signButton];
    [self addSubview:self.forgetButton];
    [self addSubview:self.quickButton];
    [self addSubview:self.resgisterLabel];
    [self addSubview:self.dividerView];
    
    //立方体
    _cubeImageView.frame = CGRectMake(0, 0, 142 * m6Scale, 152 * m6Scale);
    _cubeImageView.center = CGPointMake(kScreenWidth / 2, 261 * m6Scale);

    // 用户名
    [_phoneImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(85*m6Scale);
        make.right.equalTo(self.mas_right).offset(-85*m6Scale);
        make.height.mas_equalTo(@(111*m6Scale));//phone高111
        make.top.equalTo(self.mas_top).offset(437*m6Scale);
    }];
    [self.userTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneImageView.mas_left).offset(100*m6Scale);
        if (iPhone5) {
            make.centerY.equalTo(self.phoneImageView.mas_centerY).offset(15.5 * m6Scale);
        } else {
            make.centerY.equalTo(self.phoneImageView.mas_centerY).offset(10.5 * m6Scale);
        }
        make.right.equalTo(self.phoneImageView.mas_right).mas_offset(-5*m6Scale);
        make.height.mas_equalTo(@(59*m6Scale));

    }];
    //密码的显示和隐藏
    [_passwordbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_passWordImageView.mas_right).offset(10*m6Scale);
        make.centerY.equalTo(_passWordImageView.mas_centerY).offset(10 * m6Scale);
        make.size.mas_equalTo(CGSizeMake(120*m6Scale, 120*m6Scale));
    }];
    //密码
    [self.passWordImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(85*m6Scale);
        make.right.equalTo(self.mas_right).offset(-85*m6Scale);
        make.height.mas_equalTo(@(117*m6Scale));//lock_高117
        make.top.equalTo(_phoneImageView.mas_bottom).offset(20*m6Scale);
    }];
    [self.passwordTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_passWordImageView.mas_left).offset(100*m6Scale);
        make.right.equalTo(_passwordbutton.mas_left).offset(10*m6Scale);
        if (iPhone5) {
            make.centerY.equalTo(self.passWordImageView.mas_centerY).offset(18.5 * m6Scale);
        } else {
            make.centerY.equalTo(self.passWordImageView.mas_centerY).offset(13.5 * m6Scale);
        }
        make.height.mas_equalTo(@(59*m6Scale));
    }];
    //登录
    [_signButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset((kScreenWidth - 600*m6Scale) / 2);
        make.right.equalTo(self.mas_right).offset(-(kScreenWidth - 600*m6Scale) / 2);
        make.top.equalTo(_passWordImageView.mas_bottom).offset(100*m6Scale);
        make.height.mas_equalTo(@(90*m6Scale));
    }];
    //忘记密码
    [_forgetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset((kScreenWidth - 600*m6Scale) / 2);
        make.top.equalTo(_passWordImageView.mas_bottom).offset(25 * m6Scale);
        make.height.mas_equalTo(@(40*m6Scale));
    }];
    //快捷登录
    [_quickButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-(kScreenWidth - 600*m6Scale) / 2);
        make.top.equalTo(_passWordImageView.mas_bottom).offset(25 * m6Scale);
        make.height.mas_equalTo(@(40*m6Scale));
    }];
    //注册
    [_resgisterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@(350*m6Scale));
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.equalTo(_signButton.mas_bottom).offset(42*m6Scale);
    }];
    //分割线
    [_dividerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.signButton.mas_left).offset(15 * m6Scale);
        make.right.equalTo(self.signButton.mas_right).offset(-15 * m6Scale);
        make.top.equalTo(self.mas_top).offset(1071*m6Scale);
        make.height.mas_equalTo(@(1*m6Scale));

    }];
    

    NSArray *imageArray = @[@"微信clip",@"微博clip",@"QQclip"];
    NSArray *nameArr = @[@"微信",@"微博",@"QQ"];
    for (int i = 0; i < 3; i++) {

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
        button.tag = 100 + i;
        [button addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX).offset((i - 1) * 130 * m6Scale);
            make.top.equalTo(_dividerView.mas_bottom).offset(39*m6Scale);
            make.size.mas_equalTo(CGSizeMake(59*m6Scale, 59*m6Scale));
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = nameArr[i];
        titleLabel.textColor = [UIColor colorWithRed:172 / 255.0 green:173 / 255.0 blue:174 / 255.0 alpha:1];
        titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:26 * m6Scale];
        [self addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(button.mas_bottom).offset(15 * m6Scale);
            make.centerX.equalTo(button.mas_centerX);
        }];
    }


}
/**
 *  立方体
 */
- (UIImageView *)cubeImageView
{
    if (!_cubeImageView) {
        _cubeImageView = [Factory imageView:@"thumb"];
    }
    return _cubeImageView;
}
/**
 *   用户名
 */
- (UITextField *)userTextFiled
{
    if (!_userTextFiled) {
        _userTextFiled = [HCJFTextField textStr:@"请输入手机号" andTag:10 andFont:28*m6Scale];
        _userTextFiled.delegate = self;
        _userTextFiled.returnKeyType = UIReturnKeyDefault;
        _userTextFiled.keyboardType = UIKeyboardTypeNumberPad;
        KeyBoard *key = [[KeyBoard alloc]init];
        UIView *clip = [key keyBoardview];
        [key.doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
        
        _userTextFiled.inputAccessoryView = clip;
    }
    return _userTextFiled;
}
- (UIImageView *)phoneImageView
{
    if (!_phoneImageView) {
        _phoneImageView = [Factory imageView:@"phone"];
    }
    return _phoneImageView;
}
/**
 *  密码
 */
- (UITextField *)passwordTextFiled
{
    if (!_passwordTextFiled) {
        _passwordTextFiled = [HCJFTextField textStr:@"请输入登录密码" andTag:20 andFont:28*m6Scale];
        _passwordTextFiled.delegate = self;
        _passwordTextFiled.secureTextEntry = YES;
        _passwordTextFiled.keyboardType =  UIKeyboardTypeDefault;
        //定制的键盘
        KeyBoard *key = [[KeyBoard alloc]init];
        UIView *clip = [key keyBoardview];
        [key.doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
        
        _passwordTextFiled.inputAccessoryView = clip;
    }
    return _passwordTextFiled;
}
- (UIImageView *)passWordImageView
{
    if (!_passWordImageView) {
        _passWordImageView = [Factory imageView:@"lock-"];
    }
    return _passWordImageView;
}
/**
 *  密码的隐藏和显示
 */
- (UIButton *)passwordbutton
{
    if (!_passwordbutton) {
        _passwordbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_passwordbutton setImage:[UIImage imageNamed:@"隐藏密码"] forState:UIControlStateNormal];
        [_passwordbutton setImage:[UIImage imageNamed:@"显示密码"] forState:UIControlStateSelected];
        [_passwordbutton addTarget:self action:@selector(passwordbutton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _passwordbutton;
}
/**
 *  忘记密码
 */
- (UIButton *)forgetButton
{
    if (!_forgetButton) {
        _forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forgetButton setTitle:@"忘记密码" forState:UIControlStateNormal];
        _forgetButton.titleLabel.font = [UIFont systemFontOfSize:28*m6Scale];
        [_forgetButton setTitleColor:textFieldColor forState:UIControlStateNormal];
        [_forgetButton addTarget:self action:@selector(forgetButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetButton;
}
/**
 *  快捷登录
 */
- (UIButton *)quickButton
{
    if (!_quickButton) {
        _quickButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_quickButton setTitle:@"短信登录" forState:UIControlStateNormal];
        _quickButton.titleLabel.font = [UIFont systemFontOfSize:28*m6Scale];
       
        [_quickButton setTitleColor:textFieldColor forState:UIControlStateNormal];
    }
    return _quickButton;
}
/**
 *  注册
 */
- (UILabel *)resgisterLabel
{
    if (!_resgisterLabel) {
        _resgisterLabel = [UILabel new];
        _resgisterLabel.text = @"还没有账号?  注册";
        _resgisterLabel.textColor = [UIColor colorWithRed:176 / 255.0 green:175 / 255.0 blue:175 / 255.0 alpha:1.0];
        _resgisterLabel.textAlignment = NSTextAlignmentCenter;
        _resgisterLabel.userInteractionEnabled = YES;
        _resgisterLabel.font = [UIFont systemFontOfSize:30 * m6Scale];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:_resgisterLabel.text attributes:nil];
        [att addAttribute:NSForegroundColorAttributeName value:ButtonColor range:[_resgisterLabel.text rangeOfString:@"注册"]];
        _resgisterLabel.attributedText = att;
        UITapGestureRecognizer * singleRecognizer =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resgister:)];//手势
        singleRecognizer.numberOfTapsRequired = 1;
        [self.resgisterLabel addGestureRecognizer:singleRecognizer];
    }
    return _resgisterLabel;
}
/**
 *  分割线
 */
- (UIView *)dividerView
{
    if (!_dividerView) {
        _dividerView = [UIView new];
        _dividerView.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:222 / 255.0 blue:223 / 255.0 alpha:1];
    }
    return _dividerView;
}
/**
 *  忘记密码
 */
- (void)forgetButton:(UIButton *)sender
{
    UIViewController *ctr = (UIViewController *)[self ViewController];
    BackPasswordViewController *backPassword = [BackPasswordViewController new];
    [ctr presentViewController:backPassword animated:YES completion:nil];
}
/**
 *  注册
 */
- (void)resgister:(UITapGestureRecognizer *)sender
{
    UIViewController *ctr = (UIViewController *)[self ViewController];
    RegisterViewController *registerVC = [RegisterViewController new];
    registerVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    registerVC.presentTag = self.presentTag;
    [ctr presentViewController:registerVC animated:YES completion:nil];
}
/**
 *  密码显示的切换
 */
- (void)passwordbutton:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.passwordTextFiled.secureTextEntry = NO;
    }else{
        self.passwordTextFiled.secureTextEntry = YES;
    }
}
/**
 *  第三方登录
 */
- (void)button:(UIButton *)sender{
//    UIViewController *ctr = (UIViewController *)[self ViewController];
//    ThirdPartyVC *thridParty = [ThirdPartyVC new];
//    [ctr.navigationController pushViewController:thridParty animated:YES];
    
//    //构造SendAuthReq结构体
//    SendAuthReq* req =[[SendAuthReq alloc] init];
//    req.scope = @"snsapi_userinfo" ;
//    req.state = @"123" ;
//    req.openID = @"wxe288f2e30492370f";
//    //第三方向微信终端发送一个SendAuthReq消息结构
//    [WXApi sendReq:req];
//    return [WXApi sendAuthReq:req
//               viewController:self
//                     delegate:[WXApiManager sharedManager]];
//    [ctr presentViewController:thridParty animated:YES completion:nil];
    //qq授权登录
    if (sender.tag == 102) {
        
        self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1105689249" andDelegate:self];
        
        NSArray* permissions = [NSArray arrayWithObjects:
                                kOPEN_PERMISSION_GET_USER_INFO,
                                kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                                kOPEN_PERMISSION_ADD_SHARE,
                                kOPEN_PERMISSION_CHECK_PAGE_FANS,
                                kOPEN_PERMISSION_GET_INFO,
                                kOPEN_PERMISSION_GET_OTHER_INFO,
                                kOPEN_PERMISSION_GET_VIP_INFO,
                                kOPEN_PERMISSION_GET_VIP_RICH_INFO,
                                nil];
        
        [self.tencentOAuth authorize:permissions localAppId:@"1105689249" inSafari:NO];
    }
    //微博授权登录
    else if (sender.tag == 101) {
        
        WBAuthorizeRequest *request = [WBAuthorizeRequest request];
        request.redirectURI = @"https://api.weibo.com/oauth2/default.html";
        request.scope = @"all";
        request.userInfo = @{@"SSO_From": @"NewSignVC",
                             @"Other_Info_1": [NSNumber numberWithInt:123],
                             @"Other_Info_2": @[@"obj1", @"obj2"],
                             @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
        [WeiboSDK sendRequest:request];
        
    }
    //微信授权登录
    else {
        
        [self sendAuthRequest];
        
    }
}
//三方登录微信相关
- (void)sendAuthRequest {
    [WXApiManager sharedManager].delegate = self;
    [WXApiRequestHandler sendAuthRequestScope:@"snsapi_userinfo"
                                        State:@"123"
                                       OpenID:@" "
                             InViewController:[self ViewController]];
}
#pragma mark - WXApiManagerDelegate
- (void)managerDidRecvAuthResponse:(SendAuthResp *)response {

    if (response.code.length > 0) {
        
        //获取微信用户openId
       [DownLoadData getWechatMessage:^(id obj, NSError *error) {
           
           if (obj[@"openid"]) {
               
             //获取微信用户头像
               NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
               
               
                   
                   [DownLoadData getWechatUserInfo:^(id object, NSError *error) {
                       
                       NSLog(@"%@",object[@"headimgurl"]);
                    if (![user objectForKey:@"userIcon"]) {
                        
                       NSURL *url = [NSURL URLWithString:object[@"headimgurl"]];
                       NSData *data = [NSData dataWithContentsOfURL:url];
                       
                       [user setValue:data forKey:@"userIcon"];
                       [user synchronize];
                    }
                       
                        [self judgeThirdWithOpenId:obj[@"openid"] type:@"weixin" nickname:object[@"nickname"]];
                       
                   } token:obj[@"access_token"] openId:obj[@"openId"]];
            }
           
       } code:response.code];
        
    }
}
#pragma mark - QQ相关
- (void)tencentDidLogin {
    
    NSLog(@"%@,%@",self.tencentOAuth.accessToken,self.tencentOAuth.openId);
  
    [self.tencentOAuth getUserInfo];
  
   
}

//获取qq用户个人信息
- (void)getUserInfoResponse:(APIResponse*)response {
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    if (![user objectForKey:@"userIcon"]) {
        
        NSURL *url = [NSURL URLWithString:response.jsonResponse[@"figureurl_qq_2"]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        [user setValue:data forKey:@"userIcon"];
        [user synchronize];
    }
    
    
    
    if (self.tencentOAuth.accessToken.length > 0) {
        
        [self judgeThirdWithOpenId:self.tencentOAuth.openId type:@"qq" nickname:response.jsonResponse[@"nickname"]];
        
    }
}
- (void)tencentDidNotLogin:(BOOL)cancelled {
    if (cancelled) {
        
        NSLog(@"cancel");
    }else {
        
        NSLog(@"other");
    }
}

- (void)tencentDidNotNetWork {
    
    
}

- (void)judgeThirdWithOpenId:(NSString *)openId type:(NSString *)type nickname:(NSString *)nickname {
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    [DownLoadData postLoginWithOtherSelector:^(id obj, NSError *error) {
        
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        NSLog(@"%@",obj);
        
        if ([obj[@"result"] isEqualToString:@"success"]) {
            
            //用户ID存入本地
            [user setValue:[NSString stringWithFormat:@"%@",obj[@"userId"]] forKey:@"userId"];
            [user setValue:obj[@"result"] forKey:@"result"];
            [user setValue:obj[@"userToken"] forKey:@"userToken"];//userToken
            [user synchronize];
            //头像存入本地
            [DownLoadData postUpdateIcon:^(id obj, NSError *error) {
                
                
                NSLog(@"%@,%@",obj,NSStringFromClass([obj[@"photo"] class]));
                if (![NSStringFromClass([obj[@"photo"] class]) isEqualToString:@"NSNull"]) {
                    
                    NSURL *url = [NSURL URLWithString:obj[@"photo"]];
                    NSData *data = [NSData dataWithContentsOfURL:url];
                    
                    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                    [user setValue:data forKey:@"userIcon"];
                    [user synchronize];
                }
                
            } userId:[user objectForKey:@"userId"]];
            
            NewSignVC *signVC = (NewSignVC *)[self ViewController];
            
            [DownLoadData postUserSystemSetting:^(id object, NSError *error) {
                [signVC.hud hideAnimated:YES];
                if ([obj[@"messageCode"] isEqualToString:@"sys.error"]) {
                    
//                    [signVC dialogWithTitle:TitleMes message:Message nsTag:0];
                    [Factory alertMes:Message];
                }else {
                    NSLog(@"%@",object);
                    NSString *gestureLock = [NSString stringWithFormat:@"%@",object[@"whetherPatternLock"]];
                    NSString *touchIDLock = [NSString stringWithFormat:@"%@",object[@"whetherTouchIdLock"]];
                    NSString *protectLock = [NSString stringWithFormat:@"%@",object[@"whetherAccountProtect"]];
                    if ([gestureLock isEqualToString:@"1"]) {
                        
                        [user setValue:@"YES" forKey:@"gestureLock"];
                        [user synchronize];
                    }else {
                        
                        [user setValue:@"NO" forKey:@"gestureLock"];
                        [user synchronize];
                    }
                    
                    if ([touchIDLock isEqualToString:@"1"]) {
                        
                        [user setValue:@"YES" forKey:@"fingerSwitch"];
                        [user synchronize];
                    }else {
                        
                        [user setValue:@"NO" forKey:@"fingerSwitch"];
                        [user synchronize];
                        
                    }
                    if ([protectLock isEqualToString:@"1"]) {
                        
                        [user setValue:@"YES" forKey:@"switchGesture"];
                        [user synchronize];
                    }else {
                        
                        [user setValue:@"NO" forKey:@"switchGesture"];
                        [user synchronize];
                    }
                    //点击我的弹出
                    if ([self.presentTag isEqualToString:@"0"]) {
                        
                        [signVC dismissViewControllerAnimated:YES completion:nil];
                        
                    }
                    //账户设置弹出
                    else if ([self.presentTag isEqualToString:@"1"]) {
                        
                        [signVC dismissViewControllerAnimated:YES completion:nil];
                        
                        UINavigationController *navi = [delegate.leveyTabBarController.viewControllers lastObject];
                        [navi popToRootViewControllerAnimated:YES];
                        [delegate.leveyTabBarController hidesTabBar:NO animated:YES];
                    }
                    //立即投资弹出
                    else if ([self.presentTag isEqualToString:@"2"]) {
                        //                UINavigationController *navi = [delegate.leveyTabBarController.viewControllers firstObject];
                        //                [navi popViewControllerAnimated:YES];
                        [signVC dismissViewControllerAnimated:YES completion:nil];
                    }else {
                        
                        
                        [signVC dismissViewControllerAnimated:YES completion:nil];
                    }
                    //用户在登录成功之后，发送通知，在个人中心判断用户是否已经实名，假如没有实名，弹窗提示用户去实名
                    NSNotification *notification = [[NSNotification alloc] initWithName:@"loginRealNameView" object:nil userInfo:nil];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                    UserDefaults(@"fail", @"sxyRealName");
                }
            } userId:[user objectForKey:@"userId"]];
            
        }else {
            
            ThirdPartLoginViewController *thirdVC = [[ThirdPartLoginViewController alloc] init];
            
            thirdVC.loginType = type;
            
            thirdVC.openId = openId;
            
            thirdVC.presentTag = self.presentTag;
            
            [[self ViewController] presentViewController:thirdVC animated:YES completion:nil];
            
        }
        
    } openId:openId type:type clientId:[user objectForKey:@"clientId"] nickname:[user objectForKey:@"thirdMessage"][@"nickname"]];
}

/**
 *  第一响应者
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _userTextFiled) {
        return [self.userTextFiled resignFirstResponder];
    }
    else{
        return [self.passwordTextFiled resignFirstResponder];
    }
}
/**
 *  文本框的内容是否符合要求
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    UITextField *text = (UITextField *)[self viewWithTag:10];
//    NSString *resultStr;
//    if ([string isEqualToString:@""]) {
//        //获取到上一次操作的字符串长度
//        NSInteger clip = textField.text.length;
//        //截取字符串 将最后一个字符删除
//        resultStr = [textField.text substringToIndex:clip - 1];
//        
//    } else {
//        resultStr = [textField.text stringByAppendingString:string];
//    }
    if (text == textField) {
        
        if (range.location >= 11) {
            return NO;
        }
        return YES;
    }
    else{
        
        if (range.location >= 16) {
            return NO;
        }
        return YES;
    }
}

/**
 *  用户点击空白区域键盘的隐藏
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.userTextFiled resignFirstResponder];
    [self.passwordTextFiled resignFirstResponder];
}
/**
 *  键盘消失
 */
- (void)doneButton:(UIButton *)button {
    
    [self endEditing:YES];
    
}

@end
