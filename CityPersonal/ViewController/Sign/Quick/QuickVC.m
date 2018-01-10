//
//  QuickVC.m
//  CityJinFu
//
//  Created by xxlc on 16/8/25.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "QuickVC.h"
#import "QuickView.h"
#import "RegisterViewController.h"

@interface QuickVC ()
@property (nonatomic, weak) XFDialogFrame *dialogView;//弹出框
@property (nonatomic, strong) QuickView *quick;
@property (nonatomic, copy) NSString *validPhoneExpiredTime;//验证码时间戳
@property (nonatomic, copy) NSString *timerRandom;//验证码
@property (nonatomic, assign) NSInteger click;

@end

@implementation QuickVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //背景图片
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:self.view.bounds];
    imageview.image = [UIImage imageNamed:@"overlay"];
    [self.view addSubview:imageview];
    //标题
    [TitleLabelStyle addtitleViewToVC:self withTitle:@"快捷登录"];
    //左边按钮
    UIButton *leftButton = [Factory addLeftbottonToVC:self];//左边的按钮
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    
    _quick = [[QuickView alloc]initWithFrame:self.view.bounds];

    [self.view addSubview:_quick];
    
    //登录
    [self.quick.nextButton addTarget:self action:@selector(startQuickSureBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    //验证码
    [self.quick.verificationCodeButton addTarget:self action:@selector(verificationCodeButton:) forControlEvents:UIControlEventTouchUpInside];
}
/**
 *  返回
 */
- (void)onClickLeftItem
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//防止连续点击
- (void)startQuickSureBtnClicked:(id)sender
{
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(nextButton:)object:sender];
    [self performSelector:@selector(nextButton:)withObject:sender afterDelay:1.5];
}
/**
 *  登录
 */
- (void)nextButton:(UIButton *)sender
{
    if (self.quick.userTextFiled.text.length == 0 || self.quick.userTextFiled.text.length < 11) {
        if (self.quick.userTextFiled.text.length == 0) {
//            [self dialogWithTitle:@"温馨提示!" message:@"手机号为空!" nsTag:0];
            [Factory alertMes:@"手机号为空"];
        }else{
            [Factory alertMes:@"手机号位数错误"];
//            [self dialogWithTitle:@"温馨提示!" message:@"手机号位数错误!" nsTag:0];
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
            else if (self.quick.verificationCodeTextFiled.text.intValue != _timerRandom.intValue){
//                [self dialogWithTitle:@"温馨提示!" message:@"验证码错误!" nsTag:0];
                if (_timerRandom.integerValue) {
                    [Factory alertMes:@"验证码错误"];
                }else{
                    [Factory alertMes:@"请您先发送验证码"];
                }
            }
            else{
                
                [self serverData];//服务器
            }
        }else{
//            [self dialogWithTitle:@"温馨提示!" message:@"手机号非法!" nsTag:0];//提示框
            [Factory alertMes:@"手机号非法"];
        }
    }
}
/**
 *  服务器
 */
- (void)serverData{
    NSUserDefaults *user = HCJFNSUser;
    [DownLoadData postQuickSign:^(id obj, NSError *error) {
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NSLog(@"%@",obj);
        if ([obj[@"result"] isEqualToString:@"success"]) {
            
            //用户ID存入本地
            NSUserDefaults *user = HCJFNSUser;
            [user setValue:[NSString stringWithFormat:@"%@",obj[@"userId"]] forKey:@"userId"];
            [user setValue:obj[@"result"] forKey:@"result"];
            [user setValue:obj[@"userToken"] forKey:@"userToken"];//userToken
            [user synchronize];

            //点击我的弹出
            if ([self.presentTag isEqualToString:@"0"]) {
                
                [self dismissToRootViewController];
                
                
            }
            //账户设置弹出
            else if ([self.presentTag isEqualToString:@"1"]) {
                
                [self dismissToRootViewController];
                
                UINavigationController *navi = [delegate.leveyTabBarController.viewControllers lastObject];
                [navi popToRootViewControllerAnimated:YES];
                [delegate.leveyTabBarController hidesTabBar:NO animated:YES];
            }
            //立即投资弹出
            else if ([self.presentTag isEqualToString:@"2"]) {
                //                UINavigationController *navi = [delegate.leveyTabBarController.viewControllers firstObject];
                //                [navi popViewControllerAnimated:YES];
                [self dismissToRootViewController];
            }
        }else
        {
            if ([obj[@"messageCode"] isEqualToString:@"sys.error"]) {
//                [self dialogWithTitle:@"温馨提示!" message:Message nsTag:0];
                [Factory alertMes:Message];
            }else{
//                [self dialogWithTitle:@"温馨提示!" message:obj[@"messageText"] nsTag:0];
                [Factory alertMes:obj[@"messageText"]];
            }
        }
       
    } andmobile:self.quick.userTextFiled.text andinputCode:self.quick.verificationCodeTextFiled.text andjsCode:_timerRandom andvalidPhoneExpiredTime:_validPhoneExpiredTime andclientId:[user objectForKey:@"clientId"]];
}
/**
 *  验证码
 */
- (void)verificationCodeButton:(UIButton *)sender
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
            //判断用户是否存在
            [DownLoadData postUsername:^(id obj, NSError *error) {
                
                NSLog(@"%@",obj[@"messageText"]);
                if ([obj[@"result"] isEqualToString:@"fail"]) {//手机号存在
                    
                    [self sendVaildPhoneCode];//验证码
                    [TimeOut timeOut:self.quick.verificationCodeButton]; //倒计时
                    
                }else{
                    
                    if ([obj[@"messageCode"] isEqualToString:@"sys.error"]) {
//                        [self dialogWithTitle:@"温馨提示!" message:Message nsTag:0];
                        [Factory alertMes:Message];
                        
                    }else{
                        [self dialogWithTitle:TitleMes message:@"用户名不存在,请先注册!" nsTag:1];
                    }
                }
            } andusername:self.quick.userTextFiled.text];
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
    NSLog(@"888---%@------%@",_timerRandom,self.quick.userTextFiled.text);
    [DownLoadData postVaildPhoneCode:^(id obj, NSError *error) {
        NSString *validPhoneExpiredTime = obj[@"validPhoneExpiredTime"];
        
        NSLog(@"oooo----%@",validPhoneExpiredTime);
        
        _validPhoneExpiredTime = obj[@"validPhoneExpiredTime"];
        
    } andvaildPhoneCode:_timerRandom andmobile:self.quick.userTextFiled.text andtag:1 stat:@"1"];
}

/**
 *  提示框
 */
- (void)dialogWithTitle:(NSString *)dialogWithTitle message:(NSString *)message nsTag:(NSInteger)tag{
    self.dialogView =
    [[XFDialogNotice dialogWithTitle:dialogWithTitle
                            messages:message attrs:@{//头部颜色
                                                     XFDialogTitleViewBackgroundColor : TitleViewBackgroundColor,//分割线颜色
                                                     XFDialogLineColor : LineColor,
                                                     
                                                     }
                      commitCallBack:^(NSString *inputText) {
                          NSLog(@"%@",inputText);
                          if ([inputText isEqualToString:@"commit"] && tag == 1) {
                              NSLog(@"222");//跳到注册
                              RegisterViewController *registerVC = [RegisterViewController new];
                              registerVC.hidesBottomBarWhenPushed = YES;
                              [self.navigationController pushViewController:registerVC animated:YES];
                          }
                          else if ([inputText isEqualToString:@"commit"] && tag == 2)
                          {
                              
                          }
                          else if(tag == 2){
                              
                              NSLog(@"333");
                          }
                          [self.dialogView hideWithAnimationBlock:nil];
                      }] showWithAnimationBlock:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (_click == 0) {
        
        //创建一个导航栏
        UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, NavigationBarHeight)];
        [navBar setColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
        //隐藏导航栏的分割线
        [navBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        navBar.shadowImage = [[UIImage alloc] init];
        //创建一个导航栏集合
        UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"快捷登录"];
        TitleLabelStyle *titleLabel = [[TitleLabelStyle alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
        [titleLabel titleLabel:@"快捷登录" color:[UIColor blackColor]];
        navItem.titleView = titleLabel;
        //在这个集合Item中添加标题，按钮
        //style:设置按钮的风格，一共有三种选择
        //action：@selector:设置按钮的点击事件
        
        //创建一个左边按钮
        UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Back-Arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickLeftItem)];
        left.tintColor = [UIColor whiteColor];
        
        
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
