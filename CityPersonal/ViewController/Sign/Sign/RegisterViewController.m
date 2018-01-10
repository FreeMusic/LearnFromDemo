//
//  RegisterViewController.m
//  CityJinFu
//
//  Created by xxlc on 16/8/16.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterView.h"
#import "RegisterSecondVC.h"

@interface RegisterViewController ()
@property (nonatomic, strong) RegisterView *registerView;
//@property (nonatomic, weak) XFDialogFrame *dialogView;//弹出框
@property (nonatomic, copy) NSString *validPhoneExpiredTime;//验证码时间戳
@property (nonatomic, copy) NSString *timerRandom;//验证码
@property (nonatomic, assign) NSInteger click;
@property (nonatomic, assign) BOOL flag;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor whiteColor];
    //监听键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShownAction:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHiddenAction:) name:UIKeyboardWillHideNotification object:nil];
//    //标题
//    [TitleLabelStyle addtitleViewToVC:self withTitle:@"注册"];
//    //左边按钮
//    UIButton *leftButton = [Factory addLeftbottonToVC:self];//左边的按钮
//    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];

    _registerView = [[RegisterView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
//    [_registerView.clearUserTF addTarget:self action:@selector(cleUserText) forControlEvents:UIControlEventTouchUpInside];
//    [_registerView.clearPwdTF addTarget:self action:@selector(clearPwdText) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:_registerView];
    //验证码
    [_registerView.verificationCodeButton addTarget:self action:@selector(verificationCodeButton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.click = 0;
    self.flag = YES;
    if (self.flag) {
        self.flag = NO;
        //下一步
        [_registerView.nextButton addTarget:self action:@selector(nextButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        [_registerView.nextButton addTarget:self action:@selector(startNextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}
//键盘弹出
- (void)keyboardWillShownAction:(NSNotification *)noti {
    
   [UIView animateWithDuration:0.3 animations:^{
      
       self.registerView.frame = CGRectMake(0, - 160 * m6Scale, kScreenWidth, kScreenHeight);
       self.registerView.cubeImageView.frame = CGRectMake((kScreenWidth / 2) - 71 * m6Scale, 0, 142 * m6Scale, 152 * m6Scale);
       self.registerView.cubeImageView.alpha = 0;
   }];
    
    
}
//键盘消失
- (void)keyboardWillHiddenAction:(NSNotification *)noti {
    
  
    [UIView animateWithDuration:0.3 animations:^{
       
        self.registerView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.registerView.cubeImageView.alpha = 1;
        self.registerView.cubeImageView.frame = CGRectMake((kScreenWidth / 2) - 71 * m6Scale, 185 * m6Scale, 142 * m6Scale, 152 * m6Scale);
    }];
}

/**
 *  返回
 */
- (void)onClickLeftItem
{
    NSLog(@"%@",self.presentTag);
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if ([self.presentTag isEqualToString:@"3"]) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if ([self.presentTag isEqualToString:@"1"]) {
        
        [self dismissToRootViewController];
        
        UINavigationController *navi = [delegate.leveyTabBarController.viewControllers lastObject];
        [navi popToRootViewControllerAnimated:YES];
        
        [delegate.leveyTabBarController hidesTabBar:NO animated:YES];
        delegate.leveyTabBarController.selectedIndex = 0;
        
        
    }else {
        
        [self dismissToRootViewController];
    }
    
}

- (void) startNextBtnClick: (UIButton *)sender {
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(nextButton:) object:sender];
    [self performSelector:@selector(nextButton:) withObject:sender afterDelay:1.5];
    
}

/**
 *  下一步
 */
- (void)nextButton:(UIButton *)sender
{
    
//    RegisterSecondVC *registerSVC = [RegisterSecondVC new];
//    registerSVC.mobile = self.registerView.userTextFiled.text;//手机号
//    registerSVC.presentTag = self.presentTag;
//    [self presentViewController:registerSVC animated:YES completion:nil];

    [self.view endEditing:YES];
    
    if (self.registerView.selectButton.tag == 1) {
        if (self.registerView.userTextFiled.text.length == 0) {
            
            [Factory alertMes:@"手机号为空"];
        }
        else if (self.registerView.userTextFiled.text.length != 11) {

            [Factory alertMes:@"手机号位数错误"];
        }
        
        else if (self.registerView.verificationCodeTextFiled.text.length == 0) {
            
            [Factory alertMes:@"验证码为空"];
        }
        else if (self.registerView.verificationCodeTextFiled.text.length != 6) {

            [Factory alertMes:@"验证码位数错误"];
        }
        
        else if (self.registerView.verificationCodeTextFiled.text.intValue != _timerRandom.intValue){
            if (_timerRandom.intValue) {
               [Factory alertMes:@"验证码错误"];
            }else{
                [Factory alertMes:@"请您先发送验证码"];
            }
        }
        else{
            [self serverData];
        }
    }else{

        [Factory alertMes:@"请选择注册协议"];
    }
}
/**
 *  服务器
 */
- (void)serverData{
    NSLog(@"8888++++%@",self.registerView.userTextFiled.text);
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.label.text = NSLocalizedString(@"注册中...", @"HUD loading title");
    //注册接口数据
    [DownLoadData postRegister:^(id obj, NSError *error) {
        
        [hud hideAnimated:YES];
        
        NSLog(@"8888++++%@,%@",obj[@"messageText"],obj);
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
            [HCJFNSUser synchronize];
//            提到密码界面
            RegisterSecondVC *registerSVC = [RegisterSecondVC new];
            registerSVC.mobile = self.registerView.userTextFiled.text;//手机号
            registerSVC.presentTag = self.presentTag;
            
            [self presentViewController:registerSVC animated:YES completion:nil];
        }
    } andmobile:self.registerView.userTextFiled.text andpassword:self.registerView.inviteTextFiled.text andinputCode:self.registerView.verificationCodeTextFiled.text andjsCode:_timerRandom andvalidPhoneExpiredTime:_validPhoneExpiredTime openId:self.openId type:self.type andidfa:[[NSUserDefaults standardUserDefaults] objectForKey:@"idfa"]];
}
/**
 *  验证码
 */
- (void)verificationCodeButton:(UIButton *)sender
{
    NSLog(@"8888++++%@",self.registerView.userTextFiled.text);
    if (self.registerView.userTextFiled.text.length == 0) {
        
        [Factory alertMes:@"手机号为空"];
    }
    else if (self.registerView.userTextFiled.text.length != 11) {

        [Factory alertMes:@"手机号位数错误"];
    }
    else {
        //手机号正确则验证
        if ([Factory valiMobile:self.registerView.userTextFiled.text] == YES) {
            //判断用户是否存在
            [DownLoadData postUsername:^(id obj, NSError *error) {
            
                NSLog(@"%@",obj[@"messageText"]);
                if ([obj[@"result"] isEqualToString:@"fail"]) {
                    
                    if ([obj[@"messageCode"] isEqualToString:@"sys.error"]) {

                        [Factory alertMes:Message];
                        
                    } else {

                        [Factory alertMes:obj[@"messageText"]];
                    }
                    
                }else{
                    [self sendVaildPhoneCode];//验证码
                    //倒计时
                    [TimeOut timeOut:self.registerView.verificationCodeButton];
                }
            } andusername:self.registerView.userTextFiled.text];
            
        } else{

            [Factory alertMes:@"手机号非法"];
        }
    }
}
//验证码
- (void)sendVaildPhoneCode
{
    _timerRandom = [TimerRandom timerRandom];
    NSLog(@"_timerRandom = %@",_timerRandom);
     NSLog(@"888---%@------%@",_timerRandom,self.registerView.userTextFiled.text);
    [DownLoadData postVaildPhoneCode:^(id obj, NSError *error) {
        
        _validPhoneExpiredTime = obj[@"validPhoneExpiredTime"];
        
    } andvaildPhoneCode:_timerRandom andmobile:self.registerView.userTextFiled.text andtag:0 stat:@"1"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //隐藏导航栏的分割线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    //导航栏颜色
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    self.navigationController.navigationBar.translucent = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    if (_click == 0) {
        
        //创建一个导航栏
        UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
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

}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
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
