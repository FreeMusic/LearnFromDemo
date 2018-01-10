//
//  ThirdPartyVC.m
//  CityJinFu
//
//  Created by xxlc on 16/8/25.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "ThirdPartyVC.h"
#import "ThridPartyView.h"
#import "WXApi.h"
#import "XFDialogFrame.h"

@interface ThirdPartyVC ()<WXApiDelegate>

@property (nonatomic, assign) NSInteger click;

@property (nonatomic, strong) ThridPartyView *thridParty;

@property (nonatomic, weak) XFDialogFrame *dialogView;//弹出框
@property (nonatomic, copy) NSString *timerRandom;//验证码
@property (nonatomic, copy) NSString *validPhoneExpiredTime;//验证码时间戳
@end

@implementation ThirdPartyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = @"绑定";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.thridParty = [[ThridPartyView alloc]initWithFrame:CGRectMake(0, 100, kScreenWidth, kScreenHeight-100)];
    
    [self.thridParty.nextButton addTarget:self action:@selector(relevanceButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.thridParty.verificationCodeButton addTarget:self action:@selector(verificationCodeButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.thridParty];
    
    
}

#pragma mark - 键盘监听
- (void)keyboardWillShownAction:(NSNotification *)noti {
    
    
    [UIView animateWithDuration:0.3 animations:^{
       
        
        self.thridParty.frame = CGRectMake(0, 100, kScreenWidth, kScreenHeight-100);
        
        self.thridParty.cubeImageView.frame = CGRectMake((kScreenWidth / 2) - 71 * m6Scale, 0, 142 * m6Scale, 152 * m6Scale);
        self.thridParty.cubeImageView.alpha = 0;
    }];
    
}

- (void)keyboardWillHiddenAction:(NSNotification *)noti {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.thridParty.frame = CGRectMake(0, 100, kScreenWidth, kScreenHeight-100);
        
        self.thridParty.cubeImageView.alpha = 1;
        self.thridParty.cubeImageView.frame = CGRectMake((kScreenWidth / 2) - 71 * m6Scale, 185 * m6Scale, 142 * m6Scale, 152 * m6Scale);
    }];
}

/**
 *  验证码
 */
- (void)verificationCodeButton:(UIButton *)sender
{
    if (self.thridParty.userTextFiled.text.length == 0 || self.thridParty.userTextFiled.text.length < 11) {
        if (self.thridParty.userTextFiled.text.length == 0) {
//            [self dialogWithTitle:@"温馨提示!" message:@"手机号为空!" nsTag:0];
            [Factory alertMes:@"手机号为空"];
        }else{
//            [self dialogWithTitle:@"温馨提示!" message:@"手机号位数错误!" nsTag:0];
            [Factory alertMes:@"手机号位数错误"];
        }
    }
    else if (self.thridParty.userTextFiled.text.length == 11){
        //手机号正则验证
        if ([Factory valiMobile:self.thridParty.userTextFiled.text] == YES) {
            //判断用户是否存在
            [DownLoadData postUsername:^(id obj, NSError *error) {
                
                NSLog(@"%@",obj[@"messageText"]);
                if ([obj[@"result"] isEqualToString:@"fail"]) {//手机号存在
                    
                    [self sendVaildPhoneCode];//验证码
                    
                }else{
                    
                    if ([obj[@"messageCode"] isEqualToString:@"sys.error"]) {
//                        [self dialogWithTitle:@"温馨提示!" message:Message nsTag:2];
                        [Factory alertMes:Message];
                        
                    }else{
//                        [self dialogWithTitle:TitleMes message:@"用户名不存在,请先注册!" nsTag:1];
                        [Factory alertMes:@"用户名不存在,请先注册"];
                    }
                }
            } andusername:self.thridParty.userTextFiled.text];
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
    
    NSLog(@"%@,%@",_timerRandom,self.thridParty.userTextFiled.text);
    
    NSLog(@"888---%@------%@---%@",_timerRandom,self.thridParty.userTextFiled.text,self.presentTag);
    [DownLoadData postVaildPhoneCode:^(id obj, NSError *error) {
        NSString *validPhoneExpiredTime = obj[@"validPhoneExpiredTime"];
        //
        NSLog(@"oooo----%@",validPhoneExpiredTime);
        if ([obj[@"result"] isEqualToString:@"success"]) {
            _validPhoneExpiredTime = obj[@"validPhoneExpiredTime"];
            [TimeOut timeOut:self.thridParty.verificationCodeButton]; //倒计时
        }else{
            [Factory alertMes:obj[@"messageText"]];
        }
        
        
    } andvaildPhoneCode:_timerRandom andmobile:self.thridParty.userTextFiled.text andtag:6 stat:@"1"];
}

- (void)relevanceButtonAction:(UIButton *)button {
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    //NSString *clip = [user objectForKey:@"thirdMessage"][@"nickname"];
    
    if (self.thridParty.userTextFiled.text.length == 0) {
        
//        [self dialogWithTitle:@"提示" message:@"手机号不能为空" nsTag:1];
        [Factory alertMes:@"手机号不能为空"];
    }else if (self.thridParty.userTextFiled.text.length < 11) {
        
//        [self dialogWithTitle:@"提示" message:@"手机号位数错误" nsTag:1];
        [Factory alertMes:@"手机号位数错误"];
    }else if (self.thridParty.userTextFiled.text.length == 11) {
        
        if (self.thridParty.verificationCodeTextFiled.text.length == 0) {
            
//            [self dialogWithTitle:@"提示" message:@"验证码不能为空" nsTag:1];
            [Factory alertMes:@"验证码不能为空"];
        }else if (self.thridParty.verificationCodeTextFiled.text.length < 6) {
            
//             [self dialogWithTitle:@"提示" message:@"验证码位数错误" nsTag:1];
            [Factory alertMes:@"验证码位数错误"];
        }else {
            
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
        hud.label.text = NSLocalizedString(@"绑定中...", @"HUD loading title");
            
        [DownLoadData postRelevanceLogin:^(id obj, NSError *error) {
            
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            
            if ([obj[@"result"] isEqualToString:@"success"]) {
                [hud hideAnimated:YES];
                //用户ID存入本地
                NSUserDefaults *user = HCJFNSUser;
                [user setValue:[NSString stringWithFormat:@"%@",obj[@"userId"]] forKey:@"userId"];
                [user setValue:obj[@"result"] forKey:@"result"];
                [user setValue:obj[@"userToken"] forKey:@"userToken"];//userToken
                [user setValue:self.thridParty.userTextFiled.text forKey:@"userMobile"];
                [user setValue:obj[@"lastLoginTime"] forKey:@"lastLoginTime"];//最近登录时间
                [user setValue:obj[@"regesterTime"] forKey:@"regesterTime"];//注册时间
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
                    
                    [hud hideAnimated:YES];
                    
                    if ([obj[@"messageCode"] isEqualToString:@"sys.error"]) {
                        
//                        [self dialogWithTitle:@"温馨提示!" message:Message nsTag:0];
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
//                        if ([protectLock isEqualToString:@"1"]) {
//                            
//                            [user setObject:@"YES" forKey:@"switchGesture"];
//                            [user synchronize];
//                        }else {
//                            
//                            [user setObject:@"NO" forKey:@"switchGesture"];
//                            [user synchronize];
//                        }
//                        //点击我的弹出
//                        if ([self.presentTag isEqualToString:@"0"]) {
//                            
//                            [self dismissToRootViewController];
//                            
//                        }
//                        //账户设置弹出
//                        else if ([self.presentTag isEqualToString:@"1"]) {
//                            
//                            [self dismissToRootViewController];
//                            
//                            UINavigationController *navi = [delegate.leveyTabBarController.viewControllers lastObject];
//                            [navi popToRootViewControllerAnimated:YES];
//                            [delegate.leveyTabBarController hidesTabBar:NO animated:YES];
//                        }
//                        //立即投资弹出
//                        else if ([self.presentTag isEqualToString:@"2"]) {
//                                            UINavigationController *navi = [delegate.leveyTabBarController.viewControllers firstObject];
//                                            [navi popViewControllerAnimated:YES];
//                            [self dismissToRootViewController];
//                        }
                        
                        [self dismissToRootViewController];
            
                    }
                } userId:[user objectForKey:@"userId"]];
                
            }else {
                
                [hud hideAnimated:YES];
            }
            
            NSLog(@"%@",obj);
        } openId:self.openId type:self.loginType mobile:self.thridParty.userTextFiled.text clientId:[user objectForKey:@"clientId"] inputRandomCode:self.thridParty.verificationCodeTextFiled.text jsCode:_timerRandom validPhoneExpiredTime:_validPhoneExpiredTime nickname:[user objectForKey:@"thirdMessage"][@"nickname"]];
            
        }
        
    }
    
    NSLog(@"success:%@,%@,%@%@",self.thridParty.userTextFiled.text,self.thridParty.verificationCodeTextFiled.text,self.openId,self.loginType);
    
}


/**
 *  返回
 */
- (void)onClickLeftItem
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    //设置状态栏颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

@end
