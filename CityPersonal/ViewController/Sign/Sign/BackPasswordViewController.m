//
//  BackPasswordViewController.m
//  CityJinFu
//
//  Created by xxlc on 16/8/17.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "BackPasswordViewController.h"
#import "BackPasswordView.h"
#import "AppDelegate.h"

@interface BackPasswordViewController ()
@property (nonatomic, strong) BackPasswordView *backPassword;

@property (nonatomic, copy) NSString *validPhoneExpiredTime; //时间戳
@property (nonatomic, copy) NSString *randomCode; //验证码
//@property (nonatomic, weak) XFDialogFrame *dialogView;//弹出框
@property (nonatomic, assign) NSInteger click;
@property (nonatomic, assign) BOOL flag;

@end

@implementation BackPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //监听键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShownAction:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHiddenAction:) name:UIKeyboardWillHideNotification object:nil];
    
    _backPassword = [[BackPasswordView alloc]initWithFrame:CGRectMake(0, 100, kScreenWidth, kScreenHeight-100)];
    [self.view addSubview:_backPassword];
    
    [_backPassword.verificationCodeButton addTarget:self action:@selector(verificationCodeButton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.click = 0;
    self.flag = YES;
    if (self.flag) {
        self.flag = NO;
        [_backPassword.sureButton addTarget:self action:@selector(makeSureButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
    } else {
        [_backPassword.sureButton addTarget:self action:@selector(startBackPwdClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
}
/**
 *  返回
 */
- (void)onClickLeftItem
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//键盘弹出
- (void)keyboardWillShownAction:(NSNotification *)noti {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.backPassword.frame = CGRectMake(0, -160 * m6Scale+100, kScreenWidth, kScreenHeight-100);
        self.backPassword.cubeImageView.frame = CGRectMake((kScreenWidth / 2) - 71 * m6Scale, 0, 142 * m6Scale, 152 * m6Scale);
        self.backPassword.cubeImageView.alpha = 0;
    }];
    
    
}
//键盘消失
- (void)keyboardWillHiddenAction:(NSNotification *)noti {
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.backPassword.frame = CGRectMake(0, 100, kScreenWidth, kScreenHeight-100);
        self.backPassword.cubeImageView.alpha = 1;
        self.backPassword.cubeImageView.frame = CGRectMake((kScreenWidth / 2) - 71 * m6Scale, 185 * m6Scale, 142 * m6Scale, 152 * m6Scale);
    }];
}
//验证码方法
- (void)verificationCodeButton:(UIButton *)sender {
    
    if (self.backPassword.userTextFiled.text.length == 11) {
        //手机号验证
        if ([Factory valiMobile:self.backPassword.userTextFiled.text]) {
            
            [self sendVaildPhoneCode];
            
            [TimeOut timeOut:sender];
            
        }else {
            
            //            [self dialogWithTitle:@"温馨提示" message:@"请填写有效的手机号码!" nsTag:0];
            [Factory alertMes:@"请填写有效的手机号码"];
        }
    }else {
        
        //        [self dialogWithTitle:@"温馨提示" message:@"手机号码尚未填写完整!" nsTag:0];
        [Factory alertMes:@"手机号码尚未填写完整"];
    }
    
}

//验证码
- (void)sendVaildPhoneCode
{
    
    _randomCode = [TimerRandom timerRandom];
    
    NSLog(@"3-%@",_randomCode);
    
    [DownLoadData postVaildPhoneCode:^(id obj, NSError *error) {
        
        NSString *validPhoneExpiredTime = obj[@"validPhoneExpiredTime"];
        
        self.validPhoneExpiredTime = validPhoneExpiredTime;
        
    } andvaildPhoneCode:_randomCode andmobile:self.backPassword.userTextFiled.text andtag:4 stat:@"1"];
    
}


//防止连续点击
- (void)startBackPwdClicked:(id)sender
{
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(makeSureButtonAction:)object:sender];
    [self performSelector:@selector(makeSureButtonAction:)withObject:sender afterDelay:1.5];
}


- (void)makeSureButtonAction:(UIButton *)button {
    
    [self.view endEditing:YES];
    
    /**
     *  判断信息是否满足条件
     */
    if (self.backPassword.userTextFiled.text.length == 11 && self.backPassword.verificationCodeTextFiled.text.length == 6 && self.backPassword.sureTextField.text.length >= 6 && self.backPassword.userTextFiled.text.length <= 16) {
        //判断用户是否已经发送验证码
        if (_randomCode.integerValue) {
            if ([self.backPassword.verificationCodeTextFiled.text isEqualToString:self.randomCode]) {
                
                [DownLoadData postBackPassword:^(id obj, NSError *error) {
                    
                    NSString *result = obj[@"result"];
                    /**
                     *  判断修改密码是否成功
                     */
                    if ([result isEqualToString:@"fail"]) {
                        
                        if ([obj[@"messageCode"] isEqualToString:@"sys.error"]) {
                            //                        [self dialogWithTitle:@"温馨提示!" message:Message nsTag:0];
                            [Factory alertMes:Message];
                            
                        }else{
                            //                        [self dialogWithTitle:@"温馨提示!" message:obj[@"messageText"] nsTag:0];
                            [Factory alertMes:obj[@"messageText"]];
                        }
                        
                    }else {
                        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                        
                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:delegate.window animated:YES];
                        hud.mode = MBProgressHUDModeCustomView;
                        
                        UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                        
                        hud.customView = [[UIImageView alloc] initWithImage:image];
                        hud.square = YES;
                        
                        hud.label.text = NSLocalizedString(@"修改成功", @"HUD done title");
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            
                            [hud hideAnimated:YES];
                            
                            [self dismissViewControllerAnimated:YES completion:nil];
                        });
                    }
                    
                } mobileStr:self.backPassword.userTextFiled.text vaildPhoneCode:self.backPassword.verificationCodeTextFiled.text JSCode:_randomCode newPassword:self.backPassword.sureTextField.text validPhoneExpiredTime:self.validPhoneExpiredTime];
                
            }else{
                [Factory alertMes:@"请输入正确的验证码"];
            }
        }else {
            [Factory alertMes:@"请发送验证码"];
        }
    }else {
        if (self.backPassword.userTextFiled.text.length == 0) {
            //            [self dialogWithTitle:@"温馨提示" message:@"请先输入手机号!" nsTag:0];
            [Factory alertMes:@"请先输入手机号"];
        }else if (self.backPassword.verificationCodeTextFiled.text.length == 0){
            //            [self dialogWithTitle:@"温馨提示" message:@"请输入验证码!" nsTag:0];
            [Factory alertMes:@"请输入验证码"];
        }else if(self.backPassword.sureTextField.text.length == 0){
            //            [self dialogWithTitle:@"温馨提示" message:@"请输入新密码!" nsTag:0];
            [Factory alertMes:@"请输入新密码"];
        }else{
            //            [self dialogWithTitle:@"温馨提示" message:@"新密码长度小于6位!" nsTag:0];
            [Factory alertMes:@"新密码长度小于6位"];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.titleLabel.text = @"找回密码";
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}


@end
