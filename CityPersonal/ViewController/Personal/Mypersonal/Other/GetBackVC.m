//
//  GetBackVC.m
//  CityJinFu
//
//  Created by 姜姜敏 on 16/9/28.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "GetBackVC.h"
#import "TimerRandom.h"
#import "SignViewController.h"

@interface GetBackVC ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *loginNameText;//旧的登录密码
@property (nonatomic, strong) UITextField *newlyTextpassword;//新的登录密码
@property (nonatomic, strong) UITextField *VerificationCodeText;//验证码
@property (nonatomic, strong) UIButton *getButton;//获取验证码按钮
@property (nonatomic, strong) UIButton *loginButton;//登录按钮
@property (nonatomic, strong) NSString *str;//随机数
@property (nonatomic ,strong) MBProgressHUD *hud;
@property (nonatomic, strong) UIButton *passwordbutton;//密码的显示和隐藏
@property (nonatomic, strong) NSString *validPhoneExpiredTime;//后台返回的时间戳

@end

@implementation GetBackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.view.backgroundColor = backGroundColor;
    //自定义标题视图
    [TitleLabelStyle addtitleViewToVC:self withTitle:@"修改密码"];
    [self addView];
    //左边按钮
    UIButton *leftButton = [Factory addLeftbottonToVC:self];//左边的按钮
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
}    /**
 *  侧滑按钮
 */
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -Data
-(void)Data{
    NSUserDefaults * use =[NSUserDefaults standardUserDefaults];
    if (_newlyTextpassword.text.length>16||_newlyTextpassword.text.length< 6)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码长度不对应"preferredStyle:  UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:true completion:nil];
    } else if (![self.VerificationCodeText.text isEqualToString:_str]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"验证码出错，请仔细核对"preferredStyle:  UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:true completion:nil];
    } else {
        [self labelExample];//HUD6
        [DownLoadData postChange_passwordRecord:^(id obj, NSError *err) {
            NSString * str = [NSString stringWithFormat:@"%@",obj[@"result"]];
            NSLog(@"%@",obj[@"result"]);
            dispatch_async(dispatch_get_main_queue(), ^{
                [_hud hideAnimated:YES];
            });
            if ([str isEqualToString:@"success"]) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码修改成功"preferredStyle:  UIAlertControllerStyleAlert];
                //修改成功跳出提示是否退出登录
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    NSUserDefaults *user = HCJFNSUser;
                    [user removeObjectForKey:@"result"];
                    [user synchronize];
                    [user removeObjectForKey:@"userId"];
                    [user synchronize];
                    [user removeObjectForKey:@"switchGesture"];
                    [user removeObjectForKey:@"userIcon"];
                    [user synchronize];
                    [user removeObjectForKey:@"gesturePassword"];
                    [user synchronize];
                    [user removeObjectForKey:@"fingerSwitch"];
                    [user synchronize];
                    [user removeObjectForKey:@"gestureLock"];
                    [user synchronize];
                    [user removeObjectForKey:@"userToken"];
                    [user synchronize];
                    
                    //退出登录，需要注销网易七鱼
                    [[QYSDK sharedSDK] logout:^{
                        SignViewController *signVC = [[SignViewController alloc] init];
                        signVC.presentTag = @"1";
                        [self presentViewController:signVC animated:YES completion:nil];
                        
                    }];
                
                }]];
                [self presentViewController:alert animated:true completion:nil];
                
            }else{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码修改失败，请重新修改"preferredStyle:  UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [self presentViewController:alert animated:true completion:nil];
                
            }
        } andLoginName:[use objectForKey:@"userMobile"] andnewPassword:_newlyTextpassword.text andphoneCode:_VerificationCodeText.text andjsCode:_str andimageTime:self.validPhoneExpiredTime];
    }
}

#pragma mark -addview
- (void)addView
{
    
    [self.view addSubview:self.loginButton];//登录按钮
    //验证码背景
    UIView *verificationCodeView = [[UIView alloc] init];
    verificationCodeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:verificationCodeView];
    [verificationCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(18 * m6Scale+NavigationBarHeight);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 88 * m6Scale));
    }];
    [verificationCodeView addSubview:self.getButton];//获取验证码按钮
    [verificationCodeView addSubview:self.VerificationCodeText];//验证码
    [verificationCodeView addSubview:self.getButton];//获取验证码按钮
    //验证码
    [self.VerificationCodeText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(verificationCodeView.mas_left).offset(50*m6Scale);
        make.centerY.mas_equalTo(verificationCodeView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(400*m6Scale, 88*m6Scale));
    }];
    //获取验证码按钮
    [self.getButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-30 * m6Scale);
        make.centerY.equalTo(verificationCodeView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(150 * m6Scale, 60 * m6Scale));
    }];
    //密码背景
    UIView *leftView1 = [UIView new];
    leftView1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:leftView1];
    [leftView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(verificationCodeView.mas_bottom).offset(1);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 88 * m6Scale));
    }];
    [leftView1 addSubview:self.newlyTextpassword];//新的登录密码
    [leftView1 addSubview:self.passwordbutton];//密码的显示和隐藏
    //新的登录密码
    [self.newlyTextpassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftView1.mas_left).offset(50*m6Scale);
        make.top.equalTo(verificationCodeView.mas_bottom).offset(1);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth - (200 * m6Scale), 88 * m6Scale));
    }];
    //密码的显示和隐藏
    [_passwordbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(leftView1.mas_right).offset(-30*m6Scale);
        make.centerY.equalTo(leftView1.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(120*m6Scale, 88*m6Scale));
    }];
    //确认修改按钮
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(leftView1.mas_bottom).mas_equalTo(50*m6Scale);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth - 60*m6Scale, 90*m6Scale));
    }];
    
}
#pragma mark -newlyTextpassword
- (UITextField *)newlyTextpassword
{
    if (!_newlyTextpassword) {
        _newlyTextpassword = [[UITextField alloc]init];
        _newlyTextpassword.placeholder = @"请输入新的密码（6位~16位）";
        _newlyTextpassword.textAlignment = NSTextAlignmentLeft;
        [_newlyTextpassword setValue:[UIFont boldSystemFontOfSize:28 * m6Scale] forKeyPath:@"_placeholderLabel.font"];
        _newlyTextpassword.tag = 101;
//        [_newlyTextpassword setSecureTextEntry:YES];//不可见
        _newlyTextpassword.delegate = self;
        [_newlyTextpassword setReturnKeyType:UIReturnKeyDone];
        _newlyTextpassword.backgroundColor = [UIColor whiteColor];
        _newlyTextpassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _newlyTextpassword;
}
#pragma mark -VerificationCodeText
- (UITextField *)VerificationCodeText
{
    if (!_VerificationCodeText) {
        _VerificationCodeText = [[UITextField alloc]init];
        _VerificationCodeText.placeholder = @"请您输入验证码";
        _VerificationCodeText.textAlignment = NSTextAlignmentLeft;
        [_VerificationCodeText setValue:[UIFont boldSystemFontOfSize:28 * m6Scale] forKeyPath:@"_placeholderLabel.font"];
        _VerificationCodeText.keyboardType = UIKeyboardTypeDecimalPad;
        _VerificationCodeText.backgroundColor = [UIColor whiteColor];
        _VerificationCodeText.clearButtonMode = UITextFieldViewModeWhileEditing;
        _VerificationCodeText.tag = 100;
        _VerificationCodeText.delegate = self;
    }
    return _VerificationCodeText;
}
#pragma mark -getButton
- (UIButton *)getButton
{
    if (!_getButton) {
        _getButton = [[UIButton alloc]init];
        [_getButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        _getButton.titleLabel.font = [UIFont systemFontOfSize:26*m6Scale];
        _getButton.backgroundColor = ButtonColor;
        _getButton.layer.cornerRadius = 3;
        [_getButton addTarget:self action:@selector(getButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _getButton;
}
/**
 *  密码的隐藏和显示
 */
- (UIButton *)passwordbutton
{
    if (!_passwordbutton) {
        _passwordbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        _passwordbutton.backgroundColor = [UIColor whiteColor];
        [_passwordbutton setImage:[UIImage imageNamed:@"显示密码"] forState:UIControlStateNormal];
        [_passwordbutton setImage:[UIImage imageNamed:@"隐藏密码"] forState:UIControlStateSelected];
        [_passwordbutton addTarget:self action:@selector(passwordbutton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _passwordbutton;
}
#pragma mark -loginButton
- (UIButton *)loginButton
{
    if (!_loginButton) {
        _loginButton = [[UIButton alloc]init];
        [_loginButton setTitle:@"确认修改" forState:UIControlStateNormal];
        _loginButton.layer.cornerRadius = 7.0;
        _loginButton.backgroundColor = ButtonColor;
        [_loginButton addTarget:self action:@selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}
- (void)loginButtonClick:(UIButton *)sender
{
    [self Data];
}
//获取验证码
- (void)getButtonClick:(UIButton *)sender
{
    [self sendVaildPhoneCode];
    __block int  timeOut = 60;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t sourceTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(sourceTimer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);//每秒执行
    dispatch_source_set_event_handler(sourceTimer, ^{
        if (timeOut <= 0) {
            //倒计时结束，关闭
            dispatch_source_cancel(sourceTimer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [_getButton setTitle:@"重发验证码" forState:UIControlStateNormal];
                _getButton.titleLabel.font = [UIFont systemFontOfSize:26*m6Scale];
                _getButton.userInteractionEnabled = YES;
            });
        }
        else
        {
            int seconds = timeOut % 120;
            NSString *stringTimer = [NSString stringWithFormat:@"%.2d",seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_getButton setTitle:[NSString stringWithFormat:@"%@秒重发",stringTimer] forState:UIControlStateNormal];
                _getButton.titleLabel.font = [UIFont systemFontOfSize:26*m6Scale];
                _getButton.userInteractionEnabled = NO;
            });
            timeOut--;
        }
    });
    dispatch_resume(sourceTimer);//使用 dispatch_resume 函数来恢复
}
//发送验证码
- (void)sendVaildPhoneCode
{
    _str = [TimerRandom timerRandom];
    NSLog(@"_str验证码 = %@",_str);
//    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    [param setValue:[user objectForKey:@"userId"] forKey:@"userId"];
//    [param setValue:_str forKey:@"vaildPhoneCode"];
    //常用短信验证码接口
    [DownLoadData PostWithVerificationUserCode:^(id obj, NSError *err) {
        self.validPhoneExpiredTime = [NSString stringWithFormat:@"%@", obj[@"validPhoneExpiredTime"]];
    } vaildPhoneCode:_str userId:[HCJFNSUser stringForKey:@"userMobile"]];
}
/**
 *  密码显示的切换
 */
- (void)passwordbutton:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.newlyTextpassword.secureTextEntry = YES;
    }else{
        self.newlyTextpassword.secureTextEntry = NO;
    }
}
//键盘的隐藏
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.loginNameText)
    {
        return [self.loginNameText resignFirstResponder];
    }
    else
    {
        return [self.newlyTextpassword resignFirstResponder];
    }
//    else
//    {
//        return [self.sureTextPassword resignFirstResponder];
//    }
}

/**
 *  文本框的内容是否符合要求
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    UITextField *text1 = (UITextField *)[self.view viewWithTag:100];
    UITextField *text2 = (UITextField *)[self.view viewWithTag:101];
    if (text1 == textField) {
        if (range.location >= 6) {
            return NO;
        }
        return YES;
    }
    else if (text2 == textField) {
        if (range.location >= 16) {
            return NO;
        }
        return YES;
    
    }
    else {
        if (range.location >= 16) {
            return NO;
        }
        return YES;
    }
    
}

//点击空白区域键盘隐藏
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
//HUD
- (void)labelExample {
    _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    // Set the label text.
    _hud.label.text = NSLocalizedString(@"加载中...", @"HUD loading title");
    // You can also adjust other label properties if needed.
    // hud.label.font = [UIFont italicSystemFontOfSize:16.f];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        sleep(10.);
    });
}

@end
