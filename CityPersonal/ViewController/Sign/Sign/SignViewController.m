//
//  SignViewController.m
//  CityJinFu
//
//  Created by xxlc on 16/8/16.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "SignViewController.h"
#import "AppDelegate.h"
#import "SignView.h"
#import "AccountSettingViewController.h"
#import "QuickView.h"
#import "ThirdPartyVC.h"
#import "WXApiManager.h"
#import "ThirdPartLoginViewController.h"
#import "WeiboSDK.h"

@interface SignViewController () 
@property (nonatomic, retain) SignView *sign;
@property (nonatomic, weak) XFDialogFrame *dialogView;//弹出框
@property (nonatomic, assign) NSInteger click;
@property (nonatomic, assign) BOOL flag;
@property (nonatomic, strong) QuickView *quick;
@property (nonatomic, copy) NSString *validPhoneExpiredTime;//验证码时间戳
@property (nonatomic, copy) NSString *timerRandom;//验证码
@property (nonatomic, copy) NSString *clip; //判断快捷或者密码登录
@property (nonatomic, strong) UIButton *button;//
@end

@implementation SignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //标题
//    [TitleLabelStyle addtitleViewToVC:self withTitle:@"登录" color:[UIColor blackColor]];
    self.view.backgroundColor = [UIColor whiteColor];
    //监听键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShownAction:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHiddenAction:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getWeiboOpenIdWithNoti:) name:@"weiboOpenId" object:nil];
    //左边按钮
//    UIButton *leftButton = [Factory addLeftBtnToVC:self];//左边的按钮
//    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    //登录页面
    _sign  = [[SignView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _sign.presentTag = self.presentTag;
     [_sign.quickButton addTarget:self action:@selector(quickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sign];
    //短信登录页面
    _quick = [[QuickView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight)];
    _quick.presentTag = self.presentTag;
    [self.view addSubview:_quick];
    [_quick.quickButton addTarget:self action:@selector(passwordButton:) forControlEvents:UIControlEventTouchUpInside];
    //默认跳转到短信登录页面
    [self quickButton:_sign.quickButton];
    //登录
    [self.quick.nextButton addTarget:self action:@selector(startQuickSureBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    //验证码
    [self.quick.verificationCodeButton addTarget:self action:@selector(verificationCodeButton:) forControlEvents:UIControlEventTouchUpInside];
    self.flag = YES;
    if (self.flag) {
        self.flag = NO;
        //密码登录
        [self.sign.signButton addTarget:self action:@selector(signButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        [self.sign.signButton addTarget:self action:@selector(startButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }

    self.click = 0;
    //接受注册登录成功之后自动登录的消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AutoLogin) name:@"AutoLogin" object:nil];
}

//获取到微博的openId
- (void)getWeiboOpenIdWithNoti:(NSNotification *)noti {
    
    NSLog(@"%@",noti.userInfo);
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    [DownLoadData postLoginWithOtherSelector:^(id obj, NSError *error) {
        
        NSLog(@"%@",obj);
        
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        //判断用户是否已经绑定
        if ([obj[@"result"] isEqualToString:@"success"]) {
            
            //用户ID存入本地
            [user setValue:[NSString stringWithFormat:@"%@",obj[@"userId"]] forKey:@"userId"];
            [user setValue:obj[@"result"] forKey:@"result"];
            [user setValue:obj[@"userToken"] forKey:@"userToken"];//userToken
            UserDefaults(@"fail", @"sxyRealName");
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
            
            
            [DownLoadData postUserSystemSetting:^(id object, NSError *error) {
                [self.hud hideAnimated:YES];
                if ([obj[@"messageCode"] isEqualToString:@"sys.error"]) {
                    
                    [self dialogWithTitle:TitleMes message:Message nsTag:1];
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
                        
                        [self dismissViewControllerAnimated:YES completion:nil];
                        
                    }
                    //账户设置弹出
                    else if ([self.presentTag isEqualToString:@"1"]) {
                        
                        [self dismissViewControllerAnimated:YES completion:nil];
                        
                        UINavigationController *navi = [delegate.leveyTabBarController.viewControllers lastObject];
                        [navi popToRootViewControllerAnimated:YES];
                        [delegate.leveyTabBarController hidesTabBar:NO animated:YES];
                    }
                    //立即投资弹出
                    else if ([self.presentTag isEqualToString:@"2"]) {
                        //                UINavigationController *navi = [delegate.leveyTabBarController.viewControllers firstObject];
                        //                [navi popViewControllerAnimated:YES];
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }else {
                        
                        [self dismissViewControllerAnimated:YES completion:nil];
                        
                    }
                }
            } userId:[user objectForKey:@"userId"]];
        }else {
            
            ThirdPartLoginViewController *thirdVC = [[ThirdPartLoginViewController alloc] init];
            
            thirdVC.loginType = @"weibo";
            
            thirdVC.openId = noti.userInfo[@"openId"];
            
            thirdVC.presentTag = self.presentTag;
            
            [self presentViewController:thirdVC animated:YES completion:nil];
            
        }
        
        
    } openId:noti.userInfo[@"openId"] type:@"weibo" clientId:[user objectForKey:@"clientId"] nickname:[user objectForKey:@"thirdMessage"][@"nickname"]];
    
}

//键盘弹出
- (void)keyboardWillShownAction:(NSNotification *)noti {
    
    if ([self.clip isEqualToString:@"quick"]) {
        
       [UIView animateWithDuration:0.3 animations:^{
          
            _quick.frame = CGRectMake(0, - 160 * m6Scale, kScreenWidth, kScreenHeight);
           _quick.cubeImageView.frame = CGRectMake((kScreenWidth / 2) - 71 * m6Scale, 0, 142 * m6Scale, 152 * m6Scale);
           _quick.cubeImageView.alpha = 0;
       }];
        
    }else {
//        _cubeImageView.frame = CGRectMake(0, 0, 142 * m6Scale, 152 * m6Scale);
//        _cubeImageView.center = CGPointMake(kScreenWidth / 2, 261 * m6Scale);
        
        [UIView animateWithDuration:0.3 animations:^{
            _sign.frame = CGRectMake(0, - 160 * m6Scale, kScreenWidth, kScreenHeight);
        
            _sign.cubeImageView.frame = CGRectMake((kScreenWidth / 2) - 71 * m6Scale, 0, 142 * m6Scale, 152 * m6Scale);
            _sign.cubeImageView.alpha = 0;
        }];
        
    }
    
    
}
//键盘消失
- (void)keyboardWillHiddenAction:(NSNotification *)noti {
    
    if ([self.clip isEqualToString:@"quick"]) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            _quick.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
            _quick.cubeImageView.alpha = 1;
            _quick.cubeImageView.frame = CGRectMake((kScreenWidth / 2) - 71 * m6Scale, 185 * m6Scale, 142 * m6Scale, 152 * m6Scale);
        }];
        
    }else {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            _sign.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
            
            _sign.cubeImageView.alpha = 1;
            _sign.cubeImageView.frame = CGRectMake((kScreenWidth / 2) - 71 * m6Scale, 185 * m6Scale, 142 * m6Scale, 152 * m6Scale);
        }];
        
    }
    
}
/**
 *  跳转快捷登录
 */
- (void)quickButton:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
    self.clip = @"quick";
    
    _sign.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
    
    _sign.passwordTextFiled.text = @"";
    
    if (_sign.userTextFiled.text != nil && _sign.userTextFiled.text.length > 0) {
        
        _quick.userTextFiled.text = _sign.userTextFiled.text;
        
    }
    
    _quick.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
}
/**
 *  跳转密码登录
 */
- (void)passwordButton:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
    self.clip = @"password";
    
    _sign.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
    _quick.verificationCodeTextFiled.text = @"";
    
    if (_quick.userTextFiled.text != nil && _quick.userTextFiled.text.length > 0) {
        
        _sign.userTextFiled.text = _quick.userTextFiled.text;
        
    }
    
    _quick.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
    
}
//防止连续点击
- (void)startQuickSureBtnClicked:(id)sender
{
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(nextButton:)object:sender];
    [self performSelector:@selector(nextButton:)withObject:sender afterDelay:1.5];
}
//防止连续点击
- (void)startButtonClicked:(id)sender {
    
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(signButton:)object:sender];
    [self performSelector:@selector(signButton:)withObject:sender afterDelay:1.5];
}
/**
 *  验证码
 */
- (void)verificationCodeButton:(UIButton *)sender
{
    if (self.quick.userTextFiled.text.length == 0 || self.quick.userTextFiled.text.length < 11) {
        if (self.quick.userTextFiled.text.length == 0) {
//            [self dialogWithTitle:@"温馨提示!" message:@"手机号为空!" nsTag:0];
            [Factory alertMes:@"手机号为空"];
        }else{
//            [self dialogWithTitle:@"温馨提示!" message:@"手机号位数错误!" nsTag:0];
            [Factory alertMes:@"手机号位数错误"];
        }
    }
    else if (self.quick.userTextFiled.text.length == 11){
        //手机号正则验证
        if ([Factory valiMobile:self.quick.userTextFiled.text] == YES) {
            //判断用户是否存在
            [DownLoadData postUsername:^(id obj, NSError *error) {
                
                NSLog(@"%@",obj[@"messageText"]);
                if ([obj[@"result"] isEqualToString:@"fail"]) {//手机号存在
                    
                    [self sendVaildPhoneCode];//验证码
                    [TimeOut timeOut:self.quick.verificationCodeButton]; //倒计时
                    
                }else{
                    
                    if ([obj[@"messageCode"] isEqualToString:@"sys.error"]) {
                        [Factory alertMes:Message];
                        
                    }else{

                        [Factory alertMes:@"用户名不存在,请先注册"];
                    }
                }
            } andusername:self.quick.userTextFiled.text];
        }else{
//            [self dialogWithTitle:@"温馨提示!" message:@"手机号非法!" nsTag:0];//提示框
            [Factory alertMes:@"手机号非法"];
        }
    }
}
/**
 *  快捷登录
 */
- (void)serveQuickData {
    
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
     _hud.label.text = NSLocalizedString(@"登录中...", @"HUD loading title");
    
    NSUserDefaults *user = HCJFNSUser;
    [DownLoadData postQuickSign:^(id obj, NSError *error) {
        if (error) {
            [_hud hideAnimated:YES];
            return ;
        }
        [_hud hideAnimated:YES];
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        //NSLog(@"%@",obj);
        if ([obj[@"result"] isEqualToString:@"success"]) {
            
            //用户ID存入本地
            NSUserDefaults *user = HCJFNSUser;
            [user setValue:[NSString stringWithFormat:@"%@",obj[@"userId"]] forKey:@"userId"];
            [user setValue:obj[@"result"] forKey:@"result"];
            [user setValue:obj[@"userToken"] forKey:@"userToken"];//userToken
            [user setValue:self.quick.userTextFiled.text forKey:@"userMobile"];
            [user setValue:obj[@"lastLoginTime"] forKey:@"lastLoginTime"];//最近登录时间
            [user setValue:obj[@"regesterTime"] forKey:@"regesterTime"];//注册时间
            UserDefaults(@"fail", @"sxyRealName");
            [user synchronize];
            
            [DownLoadData postUserSystemSetting:^(id object, NSError *error) {
                if (error) {
                    [_hud hideAnimated:YES];
                    return ;
                }
                [_hud hideAnimated:YES];
                if ([obj[@"messageCode"] isEqualToString:@"sys.error"]) {
                    
                    [self dialogWithTitle:TitleMes message:Message nsTag:2];
                }else {
                    
                    NSString *gestureLock = [NSString stringWithFormat:@"%@",object[@"whetherPatternLock"]];
                    NSString *touchIDLock = [NSString stringWithFormat:@"%@",object[@"whetherTouchIdLock"]];
                    NSString *protectLock = [NSString stringWithFormat:@"%@",object[@"whetherAccountProtect"]];
                    if ([gestureLock isEqualToString:@"1"]) {
                        
                        [user setValue:@"YES" forKey:@"gestureLock"];
                    }else {
                        
                        [user setValue:@"NO" forKey:@"gestureLock"];
                    }
                    
                    if ([touchIDLock isEqualToString:@"1"]) {
                        
                        [user setValue:@"YES" forKey:@"fingerSwitch"];
                    }else {
                        
                        [user setValue:@"NO" forKey:@"fingerSwitch"];
                        
                    }
                    if ([protectLock isEqualToString:@"1"]) {
                        
                        [user setValue:@"YES" forKey:@"switchGesture"];
                        [user synchronize];
                    }else {
                        
                        [user setValue:@"NO" forKey:@"switchGesture"];
                        [user synchronize];
                    }
                    //头像存入本地
                    [DownLoadData postUpdateIcon:^(id obj, NSError *error) {
                        
                        
                        NSLog(@"%@",obj);
                        if (![NSStringFromClass([obj[@"photo"] class]) isEqualToString:@"NSNull"]) {
                            
                            NSURL *url = [NSURL URLWithString:obj[@"photo"]];
                            NSData *data = [NSData dataWithContentsOfURL:url];
                            
                            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                            [user setValue:data forKey:@"userIcon"];
                            [user synchronize];
                        }
                        
                    } userId:[user objectForKey:@"userId"]];
                    //点击我的弹出
                    if ([self.presentTag isEqualToString:@"0"]) {
                        
                        [self dismissViewControllerAnimated:YES completion:nil];
                        
                    }
                    //账户设置弹出
                    else if ([self.presentTag isEqualToString:@"1"]) {
                        
                        [self dismissViewControllerAnimated:YES completion:nil];
                        
                        UINavigationController *navi = [delegate.leveyTabBarController.viewControllers lastObject];
                        [navi popToRootViewControllerAnimated:YES];
                        [delegate.leveyTabBarController hidesTabBar:NO animated:YES];
                    }
                    //立即投资弹出
                    else if ([self.presentTag isEqualToString:@"2"]) {
                        //                UINavigationController *navi = [delegate.leveyTabBarController.viewControllers firstObject];
                        //                [navi popViewControllerAnimated:YES];
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }else {
                        
                        [self dismissViewControllerAnimated:YES completion:nil];
                        
                    }
                    //用户在登录成功之后，发送通知，在个人中心判断用户是否已经实名，假如没有实名，弹窗提示用户去实名
                    NSNotification *notification = [[NSNotification alloc] initWithName:@"loginRealNameView" object:nil userInfo:nil];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                    
                }
                
                
            } userId:[user objectForKey:@"userId"]];
        }else {
            [_hud hideAnimated:YES];
            if ([obj[@"messageCode"] isEqualToString:@"sys.error"]) {
                [Factory alertMes:Message];
            }else{
                [Factory alertMes:obj[@"messageText"]];
            }
        }
        
    } andmobile:self.quick.userTextFiled.text andinputCode:self.quick.verificationCodeTextFiled.text andjsCode:_timerRandom andvalidPhoneExpiredTime:_validPhoneExpiredTime andclientId:[user objectForKey:@"clientId"]];
}
/**
 *  快捷登录
 */
- (void)nextButton:(UIButton *)sender
{
    if (self.quick.userTextFiled.text.length == 0 || self.quick.userTextFiled.text.length < 11) {
        if (self.quick.userTextFiled.text.length == 0) {
//            [self dialogWithTitle:@"温馨提示!" message:@"手机号为空!" nsTag:0];
            [Factory alertMes:@"手机号为空"];
        }else{
//            [self dialogWithTitle:@"温馨提示!" message:@"手机号位数错误!" nsTag:0];
            [Factory alertMes:@"手机号位数错误"];
        }
    }
    else if (self.quick.userTextFiled.text.length == 11){
        //手机号正则验证
        if ([Factory valiMobile:self.quick.userTextFiled.text] == YES) {
            
            if (self.quick.verificationCodeTextFiled.text.length == 0 || self.quick.verificationCodeTextFiled.text.length < 6){
                if (self.quick.verificationCodeTextFiled.text.length == 0) {
//                    [self dialogWithTitle:@"温馨提示!" message:@"验证码为空!" nsTag:0];
                    [Factory alertMes:@"验证码为空"];
                }else{
//                    [self dialogWithTitle:@"温馨提示!" message:@"验证码位数错误!" nsTag:0];
                    [Factory alertMes:@"验证码位数错误"];
                }
            }
            else if (_timerRandom == nil){
                 [Factory alertMes:@"请发送验证码"];
            }
            else if (self.quick.verificationCodeTextFiled.text.intValue != _timerRandom.intValue){
//                [self dialogWithTitle:@"温馨提示!" message:@"验证码错误!" nsTag:0];
                [Factory alertMes:@"验证码错误"];
            }
            else{
                [self serveQuickData];//服务器
            }
        }else{
//            [self dialogWithTitle:@"温馨提示!" message:@"手机号非法!" nsTag:0];//提示框
            [Factory alertMes:@"手机号非法"];
        }
    }
}
//验证码
- (void)sendVaildPhoneCode
{
    _timerRandom = [TimerRandom timerRandom];
    
    NSLog(@"%@,%@",_timerRandom,self.quick.userTextFiled.text);
    
    NSLog(@"888---%@------%@",_timerRandom,self.quick.userTextFiled.text);
    [DownLoadData postVaildPhoneCode:^(id obj, NSError *error) {
//        NSString *validPhoneExpiredTime = obj[@"validPhoneExpiredTime"];
////
//        NSLog(@"oooo----%@",validPhoneExpiredTime);
        
        _validPhoneExpiredTime = obj[@"validPhoneExpiredTime"];
        
    } andvaildPhoneCode:_timerRandom andmobile:self.quick.userTextFiled.text andtag:1 stat:@"1"];
}

/**
 * 密码登录
 */
- (void)signButton:(UIButton *)sender{
    
    [self.view endEditing:YES];
    
    if (self.sign.userTextFiled.text.length == 0 || self.sign.userTextFiled.text.length < 11) {
        if (self.sign.userTextFiled.text.length == 0) {
//            [self dialogWithTitle:@"温馨提示!" message:@"手机号为空!" nsTag:0];
            [Factory alertMes:@"手机号为空"];
        }
        else{
            [Factory alertMes:@"手机号位数错误"];
//            [self dialogWithTitle:@"温馨提示!" message:@"手机号位数错误!" nsTag:0];
        }
    }
    else if (self.sign.userTextFiled.text.length == 11){
        //手机号正则验证
        if ([Factory valiMobile:self.sign.userTextFiled.text] == NO) {
//            [self dialogWithTitle:@"温馨提示!" message:@"手机号非法!" nsTag:0];//提示框
            [Factory alertMes:@"手机号非法"];
            
        }else{
            if (self.sign.passwordTextFiled.text.length == 0){
//                [self dialogWithTitle:@"温馨提示!" message:@"密码为空!" nsTag:0];
                [Factory alertMes:@"密码为空"];
            }else{
                [self serverData];
            }
        }
    }
}
/**
 *  服务器
 */
- (void)serverData{
    NSUserDefaults *user = HCJFNSUser;
    NSLog(@"clientId:%@",[user objectForKey:@"clientId"]);
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _hud = [MBProgressHUD showHUDAddedTo:delegate.window animated:YES];
    
    // Set the label text.
    _hud.label.text = NSLocalizedString(@"登录中...", @"HUD loading title");
    
    [DownLoadData postWetherSign:^(id obj, NSError *error) {
        
        if (error) {
            [_hud hideAnimated:YES];
            return ;
        }
        [_hud hideAnimated:YES];
        if ([obj[@"result"] isEqualToString:@"fail"]) {
            [_hud hideAnimated:YES];
            if ([obj[@"messageCode"] isEqualToString:@"sys.error"]) {
//                [self dialogWithTitle:@"温馨提示!" message:Message nsTag:0];
                [Factory alertMes:Message];
            }else{
                [Factory alertMes:obj[@"messageText"]];
//                [self dialogWithTitle:@"温馨提示!" message:obj[@"messageText"] nsTag:0];
            }
        }else{
            //用户ID存入本地
            NSUserDefaults *user = HCJFNSUser;
            [user setValue:[NSString stringWithFormat:@"%@",obj[@"userId"]] forKey:@"userId"];
//            [user setObject:@"29266" forKey:@"userId"];
            [user setValue:obj[@"result"] forKey:@"result"];
            [user setValue:obj[@"userToken"] forKey:@"userToken"];//userToken
            [user setValue:self.sign.userTextFiled.text forKey:@"userMobile"];
            [user setValue:obj[@"lastLoginTime"] forKey:@"lastLoginTime"];//最近登录时间
            [user setValue:obj[@"regesterTime"] forKey:@"regesterTime"];//注册时间
            [user setValue:self.sign.userTextFiled.text forKey:@"userName"];//用户名
            [user setValue:self.sign.passwordTextFiled.text forKey:@"password"];//密码
            UserDefaults(@"fail", @"sxyRealName");
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
            [DownLoadData postUserSystemSetting:^(id object, NSError *error) {
                [_hud hideAnimated:YES];
                if (error) {
                    [_hud hideAnimated:YES];
                    return ;
                }
                 if ([obj[@"messageCode"] isEqualToString:@"sys.error"]) {
//                      [self dialogWithTitle:@"温馨提示!" message:Message nsTag:0];
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
                         
                         [self dismissViewControllerAnimated:YES completion:nil];
                         
                     }
                     //账户设置弹出
                     else if ([self.presentTag isEqualToString:@"1"]) {
                         
                         [self dismissViewControllerAnimated:YES completion:nil];
                         
                         UINavigationController *navi = [delegate.leveyTabBarController.viewControllers lastObject];
                         [navi popToRootViewControllerAnimated:YES];
                         [delegate.leveyTabBarController hidesTabBar:NO animated:YES];
                     }
                     //立即投资弹出
                     else if ([self.presentTag isEqualToString:@"2"]) {
                         //                UINavigationController *navi = [delegate.leveyTabBarController.viewControllers firstObject];
                         //                [navi popViewControllerAnimated:YES];
                         [self dismissViewControllerAnimated:YES completion:nil];
                     }else {
                         
                         [self dismissViewControllerAnimated:YES completion:nil];
                     }
                     //用户在登录成功之后，发送通知，在个人中心判断用户是否已经实名，假如没有实名，弹窗提示用户去实名
                     NSNotification *notification = [[NSNotification alloc] initWithName:@"loginRealNameView" object:nil userInfo:nil];
                     [[NSNotificationCenter defaultCenter] postNotification:notification];

                 }
            } userId:[user objectForKey:@"userId"]];
        }
        
    } andusername:self.sign.userTextFiled.text andpassword:self.sign.passwordTextFiled.text andclientId:[user objectForKey:@"clientId"]];
}
/**
 *
 */
- (void)onClickLeftItem
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSLog(@"%@",self.presentTag);
    //点击我的弹出
    if ([self.presentTag isEqualToString:@"0"]) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    //账户设置弹出
    else if ([self.presentTag isEqualToString:@"1"]) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        UINavigationController *navi = [delegate.leveyTabBarController.viewControllers lastObject];
        [navi popToRootViewControllerAnimated:YES];
        
        [delegate.leveyTabBarController hidesTabBar:NO animated:YES];
        delegate.leveyTabBarController.selectedIndex = 0;
    }
    //立即投资弹出
    else if ([self.presentTag isEqualToString:@"2"]) {
        UINavigationController *navi = [delegate.leveyTabBarController.viewControllers firstObject];
        [navi popViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }else {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        UINavigationController *navi = [delegate.leveyTabBarController.viewControllers objectAtIndex:self.leveyTabBarController.selectedIndex];
        
        [navi popToRootViewControllerAnimated:YES];
        
    }
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //隐藏导航栏的分割线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    self.navigationController.navigationBar.hidden = YES;
    
    if (_click == 0) {
        
        //创建一个导航栏
        UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
        [navBar setColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
        //隐藏导航栏的分割线
        [navBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        navBar.shadowImage = [[UIImage alloc] init];
        //创建一个导航栏集合
        UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"登录"];
        TitleLabelStyle *titleLabel = [[TitleLabelStyle alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
        [titleLabel titleLabel:@"登录" color:[UIColor blackColor]];
        navItem.titleView = titleLabel;
        //在这个集合Item中添加标题，按钮
        //style:设置按钮的风格，一共有三种选择
        //action：@selector:设置按钮的点击事件
        
        //创建一个左边按钮
        UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Back-Arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickLeftItem)];
        left.tintColor = [UIColor lightGrayColor];//改变返回按钮的颜色
        
        //设置导航栏的内容
        //    [navItem setTitle:@"车贷宝"];
        
        //把导航栏集合添加到导航栏中，设置动画关闭
        [navBar pushNavigationItem:navItem animated:NO];
        
        //把左右两个按钮添加到导航栏集合中去
        [navItem setLeftBarButtonItem:left];
        
        
        //将标题栏中的内容全部添加到主视图当中
        [self.view addSubview:navBar];
    }
    _click ++;
    
    //设置状态栏颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
}
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}
/**
 *注册成功之后自动登录
 */
- (void)AutoLogin{
    [self dismissViewControllerAnimated:NO completion:nil];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController *navi = [delegate.leveyTabBarController.viewControllers lastObject];
    [navi popToRootViewControllerAnimated:YES];
    [delegate.leveyTabBarController hidesTabBar:NO animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
