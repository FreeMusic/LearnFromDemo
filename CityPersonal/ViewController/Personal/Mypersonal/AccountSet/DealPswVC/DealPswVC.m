//
//  DealPswVC.m
//  CityJinFu
//
//  Created by mic on 2017/7/26.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "DealPswVC.h"
#import "PassGuardCtrl.h"

@interface DealPswVC ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, APNumberPadDelegate>

@property (nonatomic, strong) UITextField *loginNameText;//旧的登录密码
@property (nonatomic, strong) PassGuardTextField *newlyTextpassword;//新的登录密码
@property (nonatomic, strong) UITextField *VerificationCodeText;//验证码
@property (nonatomic, strong) UIButton *getButton;//获取验证码按钮
@property (nonatomic, strong) UIButton *loginButton;//登录按钮
@property (nonatomic, strong) NSString *str;//随机数
@property (nonatomic ,strong) MBProgressHUD *hud;
@property (nonatomic, strong) UIButton *passwordbutton;//密码的显示和隐藏
@property (nonatomic, strong) NSString *mcryptKey;//用户的加密因子
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *placeArr;//占位字符数组
@property (nonatomic, strong) UITextField *IdCardText;//身份证号textFiled

@end

@implementation DealPswVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_setPsw) {
        [TitleLabelStyle addtitleViewToVC:self withTitle:@"设置交易密码"];
    }else{
        [TitleLabelStyle addtitleViewToVC:self withTitle:@"重置交易密码"];
    }
    self.view.backgroundColor = backGroundColor;
    //左边按钮
    UIButton *leftButton = [Factory addLeftbottonToVC:self];//左边的按钮
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.tableView];
    
    self.placeArr = @[@"请输入您的真实姓名", @"请输入您的身份证号", @"请输入您的验证码", @"请输入新的交易密码(6位)"];
    //确认修改按钮
    [self.view addSubview:self.loginButton];//登录按钮
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(420*m6Scale);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth - 60*m6Scale, 90*m6Scale));
    }];
    //getFactor获取用户的加密因子
    [self getFactor];
}
- (void)onClickLeftItem{
    if (_style.integerValue) {
        NSNotification *noti = [[NSNotification alloc] initWithName:@"sxyPushviewDismiss" object:nil userInfo:@{@"result":@"1"}];
        [[NSNotificationCenter defaultCenter] postNotification:noti];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *tableView的懒加载
 */
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20*m6Scale, kScreenWidth, 360*m6Scale) style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}
/**
 *  密码的隐藏和显示
 */
- (UIButton *)passwordbutton
{
    if (!_passwordbutton) {
        _passwordbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        _passwordbutton.backgroundColor = [UIColor whiteColor];
        [_passwordbutton setImage:[UIImage imageNamed:@"显示密码"] forState:UIControlStateSelected];
        [_passwordbutton setImage:[UIImage imageNamed:@"隐藏密码"] forState:UIControlStateNormal];
        [_passwordbutton addTarget:self action:@selector(passwordbutton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _passwordbutton;
}
/**
 * 身份证号textFiled
 */
- (UITextField *)IdCardText{
    if(!_IdCardText){
        _IdCardText = [[UITextField alloc] init];
        _IdCardText.font = [UIFont systemFontOfSize:28*m6Scale];
        _IdCardText.placeholder = @"请输入您的身份证号";
    }
    return _IdCardText;
}
/**
 *  密码显示的切换
 */
- (void)passwordbutton:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.newlyTextpassword setM_mode:true];
    }else{
        [self.newlyTextpassword setM_mode:false];
    }
}
/**
 *获取用户的加密因子
 */
- (void)getFactor{
    //获取用户的加密因子
    [DownLoadData postGetSrandNum:^(id obj, NSError *error) {
        self.mcryptKey = obj[@"mcryptKey"];
        [self.newlyTextpassword setM_strInput1:self.mcryptKey];
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
#pragma mark - cellForRowAtIndexPath
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
    }
    cell.selectionStyle = NO;
    cell.backgroundColor = [UIColor whiteColor];
    if (indexPath.row == 2) {
        [cell addSubview:self.VerificationCodeText];
        [cell addSubview:self.getButton];
        //验证码
        [self.VerificationCodeText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(35*m6Scale);
            make.centerY.mas_equalTo(cell.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(400*m6Scale, 88*m6Scale));
        }];
        //获取验证码按钮
        [self.getButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-30 * m6Scale);
            make.centerY.equalTo(cell.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(150 * m6Scale, 60 * m6Scale));
        }];
    }else if (indexPath.row == 3){
        [cell addSubview:self.newlyTextpassword];
        //新的登录密码
        [self.newlyTextpassword mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(30*m6Scale);
            make.centerY.equalTo(cell.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth - (200 * m6Scale), 88 * m6Scale));
        }];
        
//        [cell addSubview:self.passwordbutton];
//        [self.passwordbutton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(-30*m6Scale);
//            make.centerY.equalTo(cell.mas_centerY);
//            make.size.mas_equalTo(CGSizeMake(120*m6Scale, 88*m6Scale));
//        }];
    }else{
        if (indexPath.row == 0) {
            //姓名输入框
            UITextField *textFiled = [[UITextField alloc] init];
            textFiled.placeholder = self.placeArr[indexPath.row];
            textFiled.font = [UIFont systemFontOfSize:28*m6Scale];
            textFiled.tag = 1000+indexPath.row;
            textFiled.keyboardType = UIKeyboardTypeNamePhonePad;
            [cell addSubview:textFiled];
            [textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(20);
                make.height.mas_equalTo(85*m6Scale);
                make.width.mas_equalTo(kScreenWidth*0.7);
                make.centerY.mas_equalTo(cell.mas_centerY);
            }];
        }else{
            self.IdCardText.delegate = self;
            self.IdCardText.tag = 1000+indexPath.row;
            //_IdCardText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入身份证号" attributes:@{NSForegroundColorAttributeName: titleColor}];
            
            //[_IdCardText setValue:[UIFont boldSystemFontOfSize:32*m6Scale] forKeyPath:@"_placeholderLabel.font"];
            self.IdCardText.keyboardType = UIKeyboardTypeDecimalPad;//键盘样式
            //定制的键盘
            KeyBoard *key = [[KeyBoard alloc]init];
            UIView *clip = [key keyBoardview];
            [key.doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
            
            self.IdCardText.inputAccessoryView = clip;
            self.IdCardText.inputView = ({
                APNumberPad *numberPad = [APNumberPad numberPadWithDelegate:self];
                
                [numberPad.leftFunctionButton setTitle:@"X" forState:UIControlStateNormal];
                numberPad.leftFunctionButton.titleLabel.adjustsFontSizeToFitWidth = YES;
                numberPad;
            });
            
            [cell addSubview:_IdCardText];
            [_IdCardText mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(20);
                make.height.mas_equalTo(85*m6Scale);
                make.width.mas_equalTo(kScreenWidth*0.7);
                make.centerY.mas_equalTo(cell.mas_centerY);
            }];
        }
    }
    
    return cell;
}
/**
 *  键盘消失
 */
- (void)doneButton:(UIButton *)button {
    
    [self.view endEditing:YES];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90*m6Scale;
}

#pragma mark -newlyTextpassword
- (UITextField *)newlyTextpassword
{
    if (!_newlyTextpassword) {
        _newlyTextpassword = [[PassGuardTextField alloc] init];
        //延迟显示
        _newlyTextpassword.m_isDotDelay = false;
        _newlyTextpassword.placeholder = @"请输入新的交易密码(6位)";
        //licence
        [_newlyTextpassword setM_license:KeyboardKey];
        [_newlyTextpassword setM_iMaxLen:6];
        [_newlyTextpassword setM_mode:true];
        _newlyTextpassword.secureTextEntry = NO;
        _newlyTextpassword.textAlignment = NSTextAlignmentLeft;
        _newlyTextpassword.keyboardType = UIKeyboardTypeNumberPad;
        _newlyTextpassword.textColor = UIColorFromRGB(0x363636);
        _newlyTextpassword.font = [UIFont systemFontOfSize:26*m6Scale];
    }
    return _newlyTextpassword;
}
#pragma mark -VerificationCodeText
- (UITextField *)VerificationCodeText
{
    if (!_VerificationCodeText) {
        _VerificationCodeText = [[UITextField alloc]init];
        _VerificationCodeText.placeholder = @"请输入您的验证码";
        _VerificationCodeText.textAlignment = NSTextAlignmentLeft;
        _VerificationCodeText.font = [UIFont systemFontOfSize:28*m6Scale];
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
#pragma mark -loginButton
- (UIButton *)loginButton
{
    if (!_loginButton) {
        _loginButton = [Factory ButtonWithTitle:@"确认修改" andTitleColor:[UIColor whiteColor] andButtonbackGroundColor:ButtonColor andCornerRadius:14 addTarget:self action:@"loginButtonClick:"];
    }
    return _loginButton;
}
/**
 *确认修改按钮点击事件
 */
- (void)loginButtonClick:(UIButton *)sender
{
    //生成加密后的密码
    NSString *passWord = [self.newlyTextpassword getOutput1];
    //真实姓名
    UITextField *nameFiled = (UITextField *)[self.view viewWithTag:1000];
    //身份证号
    UITextField *cardNumFiled = (UITextField *)[self.view viewWithTag:1001];
    if ([nameFiled.text  isEqualToString:@""]) {
        //提示用户输入姓名
        [Factory alertMes:@"真实姓名不能为空"];
    }else{
        //正则校验身份证
        if ([Factory CheckIsIdentityCard:cardNumFiled.text]) {
            //修改交易密码
            [DownLoadData postChangePasswordWithoutOld:^(id obj, NSError *error) {
                NSLog(@"%@", obj[@"messageText"]);
                if ([obj[@"result"] isEqualToString:@"success"]) {
                    //交易密码设置成功
                    [Factory alertMes:@"交易密码重置成功!"];
                    [self.newlyTextpassword resignFirstResponder];
                    //
                    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                        sleep(1.5);
                        //回到主队列
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //发送通知 让设置交易密码弹框 消失
                            NSNotification *noti = [[NSNotification alloc] initWithName:@"sxyPushviewDismiss" object:nil userInfo:@{@"result":@"0"}];
                            [[NSNotificationCenter defaultCenter] postNotification:noti];
                            
                            [self.navigationController popViewControllerAnimated:YES];
                        });
                    });
                }else{
                    //设置失败
                    [Factory addAlertToVC:self withMessage:obj[@"messageText"]];
                }
            } msgBox:self.VerificationCodeText.text newPs:passWord userId:[HCJFNSUser stringForKey:@"userId"] factor:self.mcryptKey cardNo:cardNumFiled.text name:nameFiled.text];
        }else{
            [Factory alertMes:@"请输入正确的身份证号"];
        }
    }
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
    [DownLoadData postApplySMSforChangePassword:^(id obj, NSError *error) {
        if ([obj[@"result"] isEqualToString:@"fail"]) {
            [Factory alertMes:obj[@"errorMsg"]];
        }
    } userId:[HCJFNSUser stringForKey:@"userId"]];
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
    }else if (text2 == textField) {
        if (range.location >= 16) {
            return NO;
        }
        return YES;
        
    }
    else {
        NSLog(@"%@", string);
        if (range.location >= 18) {
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
/**
 *  <APNumberPadDelegate>
 */
- (void)numberPad:(APNumberPad *)numberPad functionButtonAction:(UIButton *)functionButton textInput:(UIResponder<UITextInput> *)textInput{
    //身份证最后一位添加X
    if (self.IdCardText.text.length == 17) {
        [textInput insertText:@"X"];
    }else{
        
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //导航栏颜色
    [self.navigationController.navigationBar setBarTintColor:navigationColor];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.hidden = NO;
    [Factory navgation:self];
    [Factory hidentabar];
}

@end
