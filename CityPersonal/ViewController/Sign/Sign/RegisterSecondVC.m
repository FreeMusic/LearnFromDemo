//
//  RegisterSecondVC.m
//  CityJinFu
//
//  Created by xxlc on 16/8/17.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "RegisterSecondVC.h"
#import "ProtectSafeViewController.h"
#import "AppDelegate.h"
#import "RegisterSecondView.h"

@interface RegisterSecondVC ()<UITextFieldDelegate>

@property (nonatomic, weak) XFDialogFrame *dialogView;//弹出框
@property (nonatomic, assign) NSInteger click;
@property (nonatomic, strong) RegisterSecondView *registerView;
@property (nonatomic, strong) UIImageView *cubeImageView;//立方体
@property (nonatomic, strong) UITextField *passwordTextFiled;//密码
@property (nonatomic, strong) UIImageView *passWordImageView;//密码图片
@property (nonatomic, strong) UIButton *sureButton;//下一步按钮
@property (nonatomic, strong) UIButton *passwordbutton;//密码的显示和隐藏


@end

@implementation RegisterSecondVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //监听键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShownAction:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHiddenAction:) name:UIKeyboardWillHideNotification object:nil];
//    //标题
//    [TitleLabelStyle addtitleViewToVC:self withTitle:@"注册"];

    self.registerView = [[RegisterSecondView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    
    [self.registerView.sureButton addTarget:self action:@selector(startSureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.registerView];
    self.click = 0;
}
//键盘弹出
- (void)keyboardWillShownAction:(NSNotification *)noti {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        
        self.registerView.frame = CGRectMake(0, - 100 * m6Scale, kScreenWidth, kScreenHeight);
    }];
}
//键盘消失
- (void)keyboardWillHiddenAction:(NSNotification *)noti {
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
       self.registerView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    }];
}
/**
 *  返回
 */
- (void)onClickLeftItem
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
/**
 *  导航右边跳过按钮
 */
- (void)onClickRightItem
{
    [self dialogWithTitle:@"恭喜您注册成功" message:@"是否立即开启密码保护?" nsTag:2];
    
//    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        [self dismissToRootViewController];
//        delegate.leveyTabBarController.selectedIndex = 2;
//        
//        UINavigationController *navi = [delegate.leveyTabBarController.viewControllers lastObject];
//        
//        ProtectSafeViewController *safeVC = [[ProtectSafeViewController alloc] init];
//        safeVC.hidesBottomBarWhenPushed = YES;
//        
//        [navi pushViewController:safeVC animated:YES];
}

/**
 *  立方体
 *
 *  @return cubeImageView
 */
- (UIImageView *)cubeImageView
{
    if (!_cubeImageView) {
        _cubeImageView = [Factory imageView:@"thumb"];
    }
    return _cubeImageView;
}
/**
 *  密码
 */
- (UITextField *)passwordTextFiled
{
    if (!_passwordTextFiled) {
        _passwordTextFiled = [HCJFTextField textStr:@"请输入密码(6位~16位)" andTag:10 andFont:30*m6Scale];
        _passwordTextFiled.delegate = self;
        _passwordTextFiled.adjustsFontSizeToFitWidth = YES;
        _passwordTextFiled.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
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
 *  登录按钮
 */
- (UIButton *)sureButton
{
    if (!_sureButton) {
        _sureButton = [SubmitBtn buttonWithType:UIButtonTypeCustom];
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_sureButton addTarget:self action:@selector(startSureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
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

- (void)startSureBtnClick:(UIButton *)sender {
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(sureButton:) object:sender];
    [self performSelector:@selector(sureButton:) withObject:sender afterDelay:1.0];
}
/**
 *  确定
 */
- (void)sureButton:(UIButton *)sender
{
    [self.view endEditing:YES];
    
    if (self.registerView.passwordTextFiled.text.length < 6) {
//        [self dialogWithTitle:@"温馨提示!" message:@"请输入(6位~16位)密码!" nsTag:0];
        [Factory alertMes:@"请输入(6位~16位)密码"];
    }
    else{
        [self serverData];//服务器
    }
}
/**
 *  服务器
 */
- (void)serverData{
    
    [DownLoadData postRegisterSecond:^(id obj, NSError *error) {
        NSLog(@"%@",obj[@"messageText"]);
        if ([obj[@"result"] isEqualToString:@"success"]) {
           // [self dialogWithTitle:TitleMes message:@"密码设置成功!" nsTag:1];
            [self passWordAlter];
        }
        else{
            if ([obj[@"messageCode"] isEqualToString:@"sys.error"]) {
//                [self dialogWithTitle:@"温馨提示!" message:Message nsTag:0];
                [Factory alertMes:Message];
                
            }else{
//                [self dialogWithTitle:@"温馨提示!" message:obj[@"messageText"] nsTag:0];
                [Factory alertMes:obj[@"messageText"]];
            }

        }
    } andmobile:_mobile andpassword:self.registerView.passwordTextFiled.text];
}
/**
 *提示密码设置成功
 */
- (void)passWordAlter{
    //呼叫客服
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:TitleMes message:@"密码设置成功" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self dismissToRootViewController];
        //用户在注册成功之后，自动登录，此刻需要在个人中心页面提示用户去实名
        NSNotification *notification = [[NSNotification alloc] initWithName:@"realNameView" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UINavigationController *navi = [delegate.leveyTabBarController.viewControllers lastObject];
        [navi popToRootViewControllerAnimated:YES];
        [delegate.leveyTabBarController hidesTabBar:NO animated:YES];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

/**
 *  提示框
 */
- (void)dialogWithTitle:(NSString *)dialogWithTitle message:(NSString *)message nsTag:(NSInteger)tag{
    NSLog(@"%ld", tag);
    self.dialogView = [[XFDialogNotice dialogWithTitle:dialogWithTitle
                            messages:message attrs:@{//头部颜色
                                                     XFDialogTitleViewBackgroundColor : TitleViewBackgroundColor,//分割线颜色
                                                     XFDialogLineColor : LineColor,
                                                     
                                                     }
                      commitCallBack:^(NSString *inputText) {
                          NSLog(@"%@",inputText);
                          if ([inputText isEqualToString:@"commit"] && tag == 1) {

                              if ([self.presentTag isEqualToString:@"3"]) {
                                  
                                  [self.presentingViewController.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                                  
                              }else {
                                  
                                  [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                              }
                              
                              NSLog(@"222");
                              
                          }
                          else if ([inputText isEqualToString:@"commit"] && tag == 2)
                          {
                              NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                              
                              [DownLoadData postInstantLogin:^(id obj, NSError *error) {
                                  
                                  NSLog(@"%@",obj);
                                  
                                NSString *result = obj[@"result"];
                                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                                  if ([result isEqualToString:@"success"]) {
                                      
                                      NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                                      [user setValue:obj[@"userId"] forKey:@"userId"];
                                      [user setValue:obj[@"userToken"] forKey:@"userToken"];//userToken
                                      [user synchronize];
                                      
                                      [self dismissToRootViewController];
                                      delegate.leveyTabBarController.selectedIndex = 2;
                                     
                                      UINavigationController *navi = [delegate.leveyTabBarController.viewControllers lastObject];
                                      
                                      ProtectSafeViewController *safeVC = [[ProtectSafeViewController alloc] init];
                                      safeVC.hidesBottomBarWhenPushed = YES;
                                      
                                      [navi pushViewController:safeVC animated:YES];
                                      
                                  }else {
                                      
                                      UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您尚未注册成功，请返回进行注册" preferredStyle:UIAlertControllerStyleAlert];
                                      
                                      [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                          
                                          [self dismissViewControllerAnimated:YES completion:nil];
                                      }]];
                                      
                                      [self presentViewController:alert animated:YES completion:nil];
                                  }
                                  
                                  
                              } mobile:self.mobile clientId:[user objectForKey:@"clientId"]];
                              
                              
                              
                          }else if ([inputText isEqualToString:@"commit"] && tag == 3){
                              
                              [self dismissToRootViewController];
                          }
                          else if(tag == 2){
                              
                              NSLog(@"333");
                          }else if (tag == 1) {
                              NSLog(@"33");
                               [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                          }
                          [self.dialogView hideWithAnimationBlock:nil];
                      }] showWithAnimationBlock:nil];
}
/**
 *  键盘的隐藏
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return [self.registerView.passwordTextFiled resignFirstResponder];
}

/**
 *  用户点击空白区域键盘的隐藏
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.registerView.passwordTextFiled resignFirstResponder];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //隐藏导航栏的分割线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    //导航栏颜色
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    self.navigationController.navigationBar.translucent = YES;
    
    if (_click == 0) {
        
        //创建一个导航栏
        UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, NavigationBarHeight)];
        [navBar setColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
        //隐藏导航栏的分割线
        [navBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        navBar.shadowImage = [[UIImage alloc] init];
        //创建一个导航栏集合
        UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"注册"];
        TitleLabelStyle *titleLabel = [[TitleLabelStyle alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
        [titleLabel titleLabel:@"注册" color:[UIColor blackColor]];
        navItem.titleView = titleLabel;
        //在这个集合Item中添加标题，按钮
        //style:设置按钮的风格，一共有三种选择
        //action：@selector:设置按钮的点击事件
        
        //创建一个左边按钮
        UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Back-Arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickLeftItem)];
        left.tintColor = [UIColor lightGrayColor];
//        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"跳过" style:UIBarButtonItemStylePlain target:self action:@selector(onClickRightItem)];//左边按钮
//        right.tintColor = [UIColor blackColor];//返回按钮的颜色
        //设置导航栏的内容
        //    [navItem setTitle:@"车贷宝"];
        
        //把导航栏集合添加到导航栏中，设置动画关闭
        [navBar pushNavigationItem:navItem animated:NO];
        
        //把左右两个按钮添加到导航栏集合中去
        [navItem setLeftBarButtonItem:left];
        //[navItem setRightBarButtonItem:right];
        
        //将标题栏中的内容全部添加到主视图当中
        [self.view addSubview:navBar];
        [navItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:35 * m6Scale],NSFontAttributeName, nil] forState:UIControlStateNormal];
    }
    _click ++;

}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}

@end
