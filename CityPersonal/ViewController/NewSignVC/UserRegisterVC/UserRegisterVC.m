//
//  UserRegisterVC.m
//  CityJinFu
//
//  Created by mic on 2017/10/11.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "UserRegisterVC.h"
#import "ProtocolVC.h"

@interface UserRegisterVC ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UIView *userView;//用户头像和手机号View

@property (nonatomic, assign) NSInteger click;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *verificationCodeButton;

@property (nonatomic, strong) NSString *timerRandom;

@property (nonatomic, strong) NSString *validPhoneExpiredTime;

@property (nonatomic, strong) UIButton *button;//同意协议按钮

@property (nonatomic, strong) UIButton *registerBtn;

@property (nonatomic, assign) BOOL messageAllow;

@property (nonatomic, assign) BOOL pswAllow;

@property (nonatomic, strong) UILabel *voiceLabel;

@end

@implementation UserRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = backGroundColor;
    
    self.messageAllow = NO;
    
    self.pswAllow = NO;
    
    //用户个人信息
    [self userView];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.userView.mas_bottom).offset(142*m6Scale);
        make.height.mas_equalTo(114*m6Scale*3);
    }];
    
    //注册按钮
    [self registerView];
    //客服电话
    [self mobilePhone];
    //自动发送短信
    [self verificationCodeButtonClick];
}
/**
 *tableView的懒加载
 */
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] init];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = backGroundColor;
    }
    return _tableView;
}
/**
 *  验证码按钮
 */
- (UIButton *)verificationCodeButton
{
    if (!_verificationCodeButton) {
        _verificationCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _verificationCodeButton.layer.masksToBounds = YES;
        [_verificationCodeButton setTitle:@"发送验证码" forState:0];
        [_verificationCodeButton setTitleColor:UIColorFromRGB(0x949494) forState:0];
        _verificationCodeButton.layer.cornerRadius = 5*m6Scale;
        _verificationCodeButton.layer.borderColor = UIColorFromRGB(0x949494).CGColor;
        _verificationCodeButton.titleLabel.font = [UIFont systemFontOfSize:30*m6Scale];
        _verificationCodeButton.layer.borderWidth = 1;
        
        _verificationCodeButton.clipsToBounds = YES;
        
        [_verificationCodeButton addTarget:self action:@selector(verificationCodeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _verificationCodeButton;
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
 *  客服电话
 */
- (void)mobilePhone{
    
    //客服时间
    UILabel *timeLabel = [Factory CreateLabelWithTextColor:0 andTextFont:26 andText:@"客服时间：9：00-17：30(工作日)" addSubView:self.view];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.textColor = UIColorFromRGB(0x9b9b9b);
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-64*m6Scale);
    }];
    
    //客服电话
    UILabel *mobileLabel = [Factory CreateLabelWithTextColor:0 andTextFont:24 andText:@"客服电话：400-0571-909" addSubView:self.view];
    mobileLabel.textAlignment = NSTextAlignmentCenter;
    mobileLabel.textColor = UIColorFromRGB(0x9b9b9b);
    [mobileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(timeLabel.mas_top).offset(-15*m6Scale);
    }];
}
/**
 *  创建注册按钮
 */
- (void)registerView{
    
    //按钮
    _button = [UIButton buttonWithType:0];
    [_button setImage:[UIImage imageNamed:@"NewSign_椭圆-5"] forState:0];
    [_button setImage:[UIImage imageNamed:@"NewSign_椭圆-4"] forState:UIControlStateSelected];
    [_button addTarget:self action:@selector(agreeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(70*m6Scale);
        make.top.mas_equalTo(self.tableView.mas_bottom).offset(50*m6Scale);
        make.size.mas_equalTo(CGSizeMake(22*m6Scale, 22*m6Scale));
    }];
    
    //同意协议标题
    UILabel *titleLabel = [Factory CreateLabelWithTextColor:0.5 andTextFont:28 andText:@"我同意《汇诚金服注册协议》" addSubView:self.view];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(skipToRegister)];
    titleLabel.userInteractionEnabled = YES;
    [titleLabel addGestureRecognizer:tap];
    titleLabel.textColor = UIColorFromRGB(0x8f8f8f);
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_button.mas_right).offset(10*m6Scale);
        make.top.mas_equalTo(self.tableView.mas_bottom).offset(48*m6Scale);
    }];
    
    //注册按钮
    _registerBtn = [Factory ButtonWithTitle:@"注册" andTitleColor:[UIColor whiteColor] andButtonbackGroundColor:navigationYellowColor andCornerRadius:10 addTarget:self action:@"registerButtonClick" addSubView:self.view];
    [_registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(596*m6Scale, 86*m6Scale));
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.tableView.mas_bottom).offset(102*m6Scale);
    }];
    //语音验证码View
    [self VoiceVerificationView];
}
/**
 *  语音验证码View
 */
- (void)VoiceVerificationView{
    //语音验证码View
    UIView *voiceView = [[UIView alloc] init];
    [self.view addSubview:voiceView];
    [voiceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 400));
        make.top.mas_equalTo(_registerBtn.mas_bottom).offset(20*m6Scale);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    //语音小图标
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NewSign_语音"]];
    [voiceView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(19*m6Scale, 29*m6Scale));
        make.centerY.mas_equalTo(voiceView.mas_centerY);
    }];
    //语音验证标签
    _voiceLabel = [Factory CreateLabelWithColor:UIColorFromRGB(0xff5933) andTextFont:26 andText:@"收不到验证码，点击获取语音验证码" addSubView:voiceView];
    [Factory ChangeColorString:@"收不到验证码，点击获取" andLabel:_voiceLabel andColor:UIColorFromRGB(0x8f8f8f)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(voiceVerification)];
    [_voiceLabel addGestureRecognizer:tap];
    _voiceLabel.userInteractionEnabled = YES;
    [_voiceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageView.mas_right).offset(10*m6Scale);
        make.centerY.mas_equalTo(voiceView.mas_centerY);
    }];
    
    [voiceView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageView.mas_left);
        make.right.mas_equalTo(_voiceLabel.mas_right);
        make.height.mas_equalTo(40*m6Scale);
        make.top.mas_equalTo(_registerBtn.mas_bottom).offset(20*m6Scale);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
}
/**
 *  获取语音验证码
 */
- (void)voiceVerification{
    _timerRandom = [TimerRandom timerRandom];
    [DownLoadData postVaildPhoneCode:^(id obj, NSError *error) {
        
        if ([obj[@"result"] isEqualToString:@"fail"]) {
            
            [Factory alertMes:obj[@"messageText"]];
            
        }else{
            
            [Factory alertMes:@"验证码已经发送，请注意查收"];
            _validPhoneExpiredTime = obj[@"validPhoneExpiredTime"];
            
            [TimeOut timeCountdown:_voiceLabel];
            
        }
        
    } andvaildPhoneCode:_timerRandom andmobile:self.mobile andtag:0 stat:@"0"];
}
/**
 *  注册协议点击事件
 */
- (void)skipToRegister{
    ProtocolVC *protocol = [ProtocolVC new];
    protocol.strTag = @"0";
    [self presentViewController:protocol animated:YES completion:nil];
}
/**
 *  同意协议按钮点击事件
 */
- (void)agreeButtonClick:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    
}
/**
 *  注册按钮点击事件
 */
- (void)registerButtonClick{
    //短信验证码输入框
    UITextField *messageFiled = (UITextField *)[self.view viewWithTag:100];
    //登录密码输入框
    UITextField *pswFiled = (UITextField *)[self.view viewWithTag:101];
    //邀请人
    UITextField *inviteFiled = (UITextField *)[self.view viewWithTag:102];
    
    if (!_button.selected) {
        
        if ([messageFiled.text isEqualToString:@""] || [pswFiled.text isEqualToString:@""]) {
            [Factory alertMes:@"请完善您的注册信息"];
        }else{
            if (_timerRandom.integerValue) {
                if (pswFiled.text.length < 17 && pswFiled.text.length > 5) {
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    
                    hud.label.text = NSLocalizedString(@"注册中...", @"HUD loading title");
                    
                    [DownLoadData postRegister:^(id obj, NSError *error) {
                        
                        NSLog(@"8888++++%@,%@",obj[@"messageText"],obj);
                        [hud setHidden:YES];
                        
                        if ([obj[@"result"] isEqualToString:@"fail"]) {
                            
                            if ([obj[@"messageCode"] isEqualToString:@"sys.error"]) {
                                ;
                                [Factory alertMes:obj[@"messageText"]];
                                
                            }else{
                                
                                [Factory alertMes:obj[@"messageText"]];
                            }
                        }
                        else{
                            //用户ID存入本地
                            [HCJFNSUser setValue:[NSString stringWithFormat:@"%@",obj[@"userId"]] forKey:@"userId"];
                            [HCJFNSUser setValue:obj[@"result"] forKey:@"result"];
                            [HCJFNSUser setValue:obj[@"userToken"] forKey:@"userToken"];//userToken
                            [HCJFNSUser setValue:obj[@"userId"] forKey:@"userId"];//userToken
                            [HCJFNSUser synchronize];
                            
                            [self passWordAlter];
                            
                        }
                        
                    } andmobile:self.mobile andpassword:pswFiled.text andinputCode:messageFiled.text andjsCode:_timerRandom andvalidPhoneExpiredTime:_validPhoneExpiredTime openId:self.openId type:self.type andidfa:@"" version:@"" invitePerson:inviteFiled.text];
                }else{
                    [Factory alertMes:@"登录密码的长度介于6到16位"];
                }
            }else{
                
                [Factory alertMes:@"请您发送验证码"];
                
            }
        }
        
    }else{
        
        [Factory alertMes:@"请您先同意注册协议"];
        
    }
    
}
/**
 *提示密码设置成功
 */
- (void)passWordAlter{
    //呼叫客服
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:TitleMes message:@"注册成功" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self dismissToRootViewController];
        //用户在注册成功之后，自动登录，此刻需要在个人中心页面提示用户去实名
        //        NSNotification *notification = [[NSNotification alloc] initWithName:@"realNameView" object:nil userInfo:nil];
        //        [[NSNotificationCenter defaultCenter] postNotification:notification];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"realNameView" object:nil];
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UINavigationController *navi = [delegate.leveyTabBarController.viewControllers lastObject];
        [navi popToRootViewControllerAnimated:YES];
        [delegate.leveyTabBarController hidesTabBar:NO animated:YES];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
#pragma mark - cellForRowAtIndexPath
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *reuse = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuse];
        
    }
    
    NSArray *iconArr = @[@"NewSign_验证码", @"NewSign_密码", @"NewSign_邀请好友"];
    NSArray *placeArr = @[@"请输入短信验证码", @"请设置登录密码(6位-16位)", @"请输入邀请人或者手机号(选填)"];
    UIImageView *imgView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconArr[indexPath.row]]];
    [cell addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(70*m6Scale);
        make.size.mas_equalTo(CGSizeMake(40*m6Scale, 40*m6Scale));
        make.centerY.mas_equalTo(cell.mas_centerY);
    }];
    cell.selectionStyle = NO;
    cell.backgroundColor = backGroundColor;
    
    UITextField *textFiled = [[UITextField alloc] init];
    textFiled.tag = 100+indexPath.row;
    textFiled.delegate = self;
    textFiled.userInteractionEnabled = YES;
    textFiled.placeholder = placeArr[indexPath.row];
    if (indexPath.row) {
        
    }else{
        textFiled.keyboardType = UIKeyboardTypeNumberPad;
    }
    //定制的键盘
    KeyBoard *key = [[KeyBoard alloc]init];
    UIView *clip = [key keyBoardview];
    [key.doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
    
    textFiled.inputAccessoryView = clip;
    textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    [cell addSubview:textFiled];
    [textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imgView.mas_right).offset(20*m6Scale);
        make.centerY.mas_equalTo(cell.mas_centerY);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(50*m6Scale);
    }];
    
    if (indexPath.row == 0) {
        //发送验证码按钮
        [cell addSubview:self.verificationCodeButton];
        [self.verificationCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-40*m6Scale);
            make.centerY.mas_equalTo(cell.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(200*m6Scale, 50*m6Scale));
        }];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 114*m6Scale;
    
}
/**
 *   验证码按钮dianj点击事件
 */
- (void)verificationCodeButtonClick{
    
    [self sendVaildPhoneCode];
    
    [TimeOut timeOut:self.verificationCodeButton]; //倒计时
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField.tag == 100) {
        // 短信验证码
        if (range.location >= 6) {
            self.messageAllow = YES;
            
            return NO;
        }else{
            self.messageAllow = NO;
            return YES;
            
        }
    }else if (textField.tag == 101){
        
        if (range.location >= 4) {
            self.pswAllow = YES;
        }else{
                self.pswAllow = NO;
        }
        
        //登录密码
        if (range.location >= 16) {
            
            return NO;
            
        }else{
            
            return YES;
        }
        
    }else{
        
        return YES;
        
    }
    
}

//验证码
- (void)sendVaildPhoneCode
{
    _timerRandom = [TimerRandom timerRandom];
    NSLog(@"888---%@------%@",_timerRandom,self.mobile);
    [DownLoadData postVaildPhoneCode:^(id obj, NSError *error) {
        
        if ([obj[@"result"] isEqualToString:@"fail"]) {
            
            [Factory alertMes:obj[@"messageText"]];
            
        }else{
            
            [Factory alertMes:@"验证码已经发送，请注意查收"];
            _validPhoneExpiredTime = obj[@"validPhoneExpiredTime"];
        }
        
    } andvaildPhoneCode:_timerRandom andmobile:self.mobile andtag:0 stat:@"1"];
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
        self.titleLabel.text = @"注册";
    }
    _click ++;
    
    //设置状态栏颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}
@end
