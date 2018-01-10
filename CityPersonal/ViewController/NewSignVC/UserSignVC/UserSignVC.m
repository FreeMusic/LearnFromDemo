//
//  UserSignVC.m
//  CityJinFu
//
//  Created by mic on 2017/10/11.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "UserSignVC.h"
#import "AscertainView.h"
#import "ThirdSignView.h"
#import "SignPasswordView.h"
#import "MessageSignView.h"

@interface UserSignVC ()<UITextFieldDelegate>

@property (nonatomic, assign) NSInteger click;

@property (nonatomic, strong) AscertainView *ascertainView;//确定按钮视图

@property (nonatomic, strong) ThirdSignView *thirdSignView;//第三方登录视图

@property (nonatomic, strong) SignPasswordView *passwordView;//登录密码输入视图

@property (nonatomic, strong) MessageSignView *messageSignView;//短信登录输入视图

@property (nonatomic, strong) UIView *userView;//用户头像和手机号View

@property (nonatomic, strong) MBProgressHUD *hud;

@property (nonatomic, strong) NSString *timerRandom;

@property (nonatomic, strong) NSString *validPhoneExpiredTime;

@end

@implementation UserSignVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = backGroundColor;
    
    //用户个人信息
    [self userView];
    
    //登录密码输入视图
    [self.view addSubview:self.passwordView];
    
    //确定按钮视图
    [self.view addSubview:self.ascertainView];
    self.ascertainView.frame = CGRectMake(0, 658*m6Scale, kScreenWidth, 145*m6Scale);
    
    //第三方登录视图
    [self.view addSubview:self.thirdSignView];
    
    [self.thirdSignView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(290*m6Scale);
    }];
    
    self.messageSignView.hidden = YES;
}
/**
 *   确定按钮视图
 */
- (AscertainView *)ascertainView{
    if(!_ascertainView){
        _ascertainView = [[AscertainView alloc] init];
        
        [_ascertainView.button addTarget:self action:@selector(ascertainViewButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _ascertainView.iconType = IconType_Safe;
        __weak typeof(self) weakSelf = self;
        [_ascertainView setGetVoiceCodeBlock:^(IconType type, UILabel *label, UIButton *button) {
            if (type == IconType_Voice) {
                button.userInteractionEnabled = YES;
                
                _timerRandom = [TimerRandom timerRandom];
                //获取语音验证码
                [DownLoadData postVaildPhoneCode:^(id obj, NSError *error) {
                    
                    if ([obj[@"result"] isEqualToString:@"fail"]) {
                        
                        [Factory alertMes:obj[@"messageText"]];
                        
                    }else{
                        
                        [Factory alertMes:@"验证码已经发送，请注意查收"];
                        _validPhoneExpiredTime = obj[@"validPhoneExpiredTime"];
                        NSLog(@" 语音验证码  %@", weakSelf.timerRandom);
                        
                        [TimeOut timeCountdown:label];
                        
                        [weakSelf.messageSignView.verificationCodeButton setTitle:@"重新获取" forState:0];
                    }
                    
                } andvaildPhoneCode:weakSelf.timerRandom andmobile:weakSelf.mobile andtag:1 stat:@"0"];
            }
        }];
    }
    return _ascertainView;
}
/**
 *  第三方登录视图
 */
- (ThirdSignView *)thirdSignView{
    if(!_thirdSignView){
        _thirdSignView = [[ThirdSignView alloc] init];
    }
    return _thirdSignView;
}
/**
 *  登录密码输入视图
 */
- (SignPasswordView *)passwordView{
    if(!_passwordView){
        
        _passwordView = [[SignPasswordView alloc] initWithFrame:CGRectMake(0, 448*m6Scale, kScreenWidth, 170*m6Scale)];

        [_passwordView.pswField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
        [_passwordView.messageButton addTarget:self action:@selector(SignPasswordViewButtonClick) forControlEvents:UIControlEventTouchUpInside];
        //定制的键盘
        KeyBoard *key = [[KeyBoard alloc]init];
        UIView *clip = [key keyBoardview];
        [key.doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
        
        _passwordView.pswField.inputAccessoryView = clip;
        _passwordView.pswField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _passwordView;
}
/**
 *  短信验证码登录视图
 */
- (MessageSignView *)messageSignView{
    if(!_messageSignView){
        _messageSignView = [[MessageSignView alloc] initWithFrame:CGRectMake(0, 448*m6Scale, kScreenWidth, 170*m6Scale)];
        [_messageSignView.messageField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
        [_messageSignView.pswButton addTarget:self action:@selector(MessageSignViewButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_messageSignView.verificationCodeButton addTarget:self action:@selector(verificationCodeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _messageSignView.messageField.keyboardType = UIKeyboardTypeNumberPad;
        //定制的键盘
        KeyBoard *key = [[KeyBoard alloc]init];
        UIView *clip = [key keyBoardview];
        [key.doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
        
        _messageSignView.messageField.inputAccessoryView = clip;
        _messageSignView.messageField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        [self.view addSubview:_messageSignView];
    }
    return _messageSignView;
}
/**
 *   用户头像和手机号View
 */
- (UIView *)userView{
    if(!_userView){
        _userView = [[UIView alloc] init];
        
        [self.view addSubview:_userView];
        [_userView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(204*m6Scale);
            make.height.mas_equalTo(50*m6Scale);
        }];
        
        //用户头像
        UIImageView *userImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NewSign_我的"]];
        [_userView addSubview:userImgView];
        [userImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(50*m6Scale, 50*m6Scale));
            make.centerY.mas_equalTo(_userView.mas_centerY);
        }];
        
        //用户手机号
        UILabel *mobileLabel = [Factory CreateLabelWithTextColor:0.3 andTextFont:35 andText:self.mobile addSubView:_userView];
        [mobileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(userImgView.mas_right).mas_equalTo(10*m6Scale);
            make.centerY.mas_equalTo(_userView.mas_centerY);
        }];
        
        [_userView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(userImgView.mas_left);
            make.right.mas_equalTo(mobileLabel.mas_right);
            make.top.mas_equalTo(204*m6Scale);
            make.height.mas_equalTo(60*m6Scale);
            make.centerX.mas_equalTo(self.view.mas_centerX);
        }];
    }
    return _userView;
}
/**
 *   监听密码输入
 */
- (void)textChanged:(UITextField *)textFiled{
    //监听密码输入
    if ([textFiled isEqual:self.passwordView.pswField]) {
        if (textFiled.text.length < 6) {
            self.ascertainView.button.buttonWhetherClick = ButtonCanNotClickWithHalfAlpha;
        }else  if(textFiled.text.length < 17){
            self.ascertainView.button.buttonWhetherClick = ButtonCanClick;
        }else{
            textFiled.text = [textFiled.text stringByReplacingCharactersInRange:NSMakeRange(16, 1) withString:@""];
        }
    }else{
        //监听短信验证码输入
        if (textFiled.text.length < 6) {
            self.ascertainView.button.buttonWhetherClick = ButtonCanNotClickWithHalfAlpha;
        }else  if(textFiled.text.length == 6){
            self.ascertainView.button.buttonWhetherClick = ButtonCanClick;
        }else{
            textFiled.text = [textFiled.text stringByReplacingCharactersInRange:NSMakeRange(6, 1) withString:@""];
        }
    }
}
/**
 *  SignPasswordView
 */
- (void)SignPasswordViewButtonClick{
    
    self.passwordView.hidden = YES;
    
    self.messageSignView.hidden = NO;
    
    self.ascertainView.iconType = IconType_Voice;
    
    self.passwordView.pswField.text = @"";
    
    self.messageSignView.messageField.text = @"";
    
    [self verificationCodeButtonClick];
}
/**
 *  MessageSignViewButtonClick
 */
- (void)MessageSignViewButtonClick{
    
    self.passwordView.hidden = NO;
    
    self.messageSignView.hidden = YES;
    
    self.ascertainView.iconType = IconType_Safe;
    
    self.passwordView.pswField.text = @"";
    
    self.messageSignView.messageField.text = @"";
}
- (void)verificationCodeButtonClick{
    
    [self sendVaildPhoneCode];//验证码
}
//验证码
- (void)sendVaildPhoneCode
{
    _timerRandom = [TimerRandom timerRandom];
    
    NSLog(@"%@,%@",_timerRandom,self.messageSignView.messageField.text);
    [DownLoadData postVaildPhoneCode:^(id obj, NSError *error) {

        if ([obj[@"result"] isEqualToString:@"fail"]) {
            
            [Factory alertMes:obj[@"messageText"]];
            
        }else{
            
            [Factory alertMes:@"验证码已经发送，请注意查收"];
            _validPhoneExpiredTime = obj[@"validPhoneExpiredTime"];
            
            [TimeOut timeOut:self.messageSignView.verificationCodeButton]; //倒计时
            
            self.ascertainView.label.text = @"收不到验证码，点击获取语音验证码";
            self.ascertainView.label.textColor = UIColorFromRGB(0xff5933);
            [Factory ChangeColorString:@"收不到验证码，点击获取" andLabel:self.ascertainView.label andColor:UIColorFromRGB(0x8f8f8f)];
        }
        
    } andvaildPhoneCode:_timerRandom andmobile:self.mobile andtag:1 stat:@"1"];
}
/**
 *  确定按钮点击事件
 */
- (void)ascertainViewButtonClick{
    
    if (self.messageSignView.hidden) {
        
        [self normalLogin];
        
    }else{
        
        [self quickLogin];
        
    }

}
/**
 *   验证码登录
 */
- (void)quickLogin{
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.label.text = NSLocalizedString(@"登录中...", @"HUD loading title");
    
    NSUserDefaults *user = HCJFNSUser;
    [DownLoadData postQuickSign:^(id obj, NSError *error) {
        if (error) {
            [_hud hideAnimated:YES];
            return ;
        }
        [_hud hideAnimated:YES];
        //NSLog(@"%@",obj);
        if ([obj[@"result"] isEqualToString:@"success"]) {
            
            //用户ID存入本地
            NSUserDefaults *user = HCJFNSUser;
            [user setValue:[NSString stringWithFormat:@"%@",obj[@"userId"]] forKey:@"userId"];
            [user setValue:obj[@"result"] forKey:@"result"];
            [user setValue:obj[@"userToken"] forKey:@"userToken"];//userToken
            [user setValue:self.mobile forKey:@"userMobile"];
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
                    
                    //[self dialogWithTitle:TitleMes message:Message nsTag:2];
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
                    [self dismissToRootViewController];
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
        
    } andmobile:self.mobile andinputCode:self.messageSignView.messageField.text andjsCode:_timerRandom andvalidPhoneExpiredTime:_validPhoneExpiredTime andclientId:[user objectForKey:@"clientId"]];
}
/**
 *   密码登录
 */
- (void)normalLogin{
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
            [user setValue:self.mobile forKey:@"userMobile"];
            [user setValue:obj[@"lastLoginTime"] forKey:@"lastLoginTime"];//最近登录时间
            [user setValue:obj[@"regesterTime"] forKey:@"regesterTime"];//注册时间
            [user setValue:self.mobile forKey:@"userName"];//用户名
            [user setValue:self.passwordView.pswField.text forKey:@"password"];//密码
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
                    [self dismissToRootViewController];
                    //用户在登录成功之后，发送通知，在个人中心判断用户是否已经实名，假如没有实名，弹窗提示用户去实名
                    NSNotification *notification = [[NSNotification alloc] initWithName:@"loginRealNameView" object:nil userInfo:nil];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                    
                }
            } userId:[user objectForKey:@"userId"]];
        }
        
    } andusername:self.mobile andpassword:self.passwordView.pswField.text andclientId:[user objectForKey:@"clientId"]];
}
/**
 *  键盘消失
 */
- (void)doneButton:(UIButton *)button {
    
    [self.view endEditing:YES];
    
}
- (void)onClickLeftItem {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //隐藏导航栏的分割线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    self.navigationController.navigationBar.hidden = YES;
    
    if (_click == 0) {
        
        self.titleLabel.text = @"登录";
    }
    _click ++;
    
    //设置状态栏颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

@end
