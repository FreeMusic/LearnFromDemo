//
//  NewSignVC.m
//  CityJinFu
//
//  Created by mic on 2017/10/10.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "NewSignVC.h"
#import "NewSignPhoneView.h"
#import "AscertainView.h"
#import "ThirdSignView.h"
#import "UserSignVC.h"
#import "UserRegisterVC.h"
#import "ThirdPartLoginViewController.h"
#import "SXYNavigationBar.h"

@interface NewSignVC ()<UITextFieldDelegate>

@property (nonatomic, assign) NSInteger click;

@property (nonatomic, strong) NewSignPhoneView *phoneView;//输入手机号码视图

@property (nonatomic, strong) AscertainView *ascertainView;//确定按钮视图

@property (nonatomic, strong) ThirdSignView *thirdSignView;//第三方登录视图

@end

@implementation NewSignVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[TitleLabelStyle addtitleViewToVC:self withTitle:@"登录/注册"];
    
    self.view.backgroundColor = backGroundColor;
    
    //左边按钮
//    UIButton *leftButton = [Factory addLeftbottonToVC:self];//左边的按钮
//    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    
    //输入手机号码视图
    [self CreateNewSignPhoneView];
    //确定按钮视图
    [self.view addSubview:self.ascertainView];
    
    [self.ascertainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(_phoneView.mas_bottom).offset(54*m6Scale);
        make.height.mas_equalTo(145*m6Scale);
    }];
    
    //第三方登录视图
    [self.view addSubview:self.thirdSignView];
    
    [self.thirdSignView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(290*m6Scale);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getWeiboOpenIdWithNoti:) name:@"weiboOpenId" object:nil];
}
/**
 *   输入手机号码视图
 */
- (void)CreateNewSignPhoneView{
    _phoneView = [[NewSignPhoneView alloc] initWithFrame:CGRectMake(0, 446*m6Scale, kScreenWidth, 150*m6Scale)];
    _phoneView.phoneFiled.delegate = self;
    _phoneView.phoneFiled.keyboardType = UIKeyboardTypeNumberPad;
    //定制的键盘
    KeyBoard *key = [[KeyBoard alloc]init];
    UIView *clip = [key keyBoardview];
    [key.doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
    
    _phoneView.phoneFiled.inputAccessoryView = clip;
    _phoneView.phoneFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [self.view addSubview:_phoneView];
}
/**
 *   确定按钮视图
 */
- (AscertainView *)ascertainView{
    if(!_ascertainView){
        _ascertainView = [[AscertainView alloc] init];
        
        [_ascertainView.button addTarget:self action:@selector(ascertainViewButtonClick) forControlEvents:UIControlEventTouchUpInside];
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

#pragma mark - - shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (range.location < 10) {
        self.ascertainView.button.buttonWhetherClick = ButtonCanNotClickWithHalfAlpha;
        return YES;
        
    }else if (range.location == 10){
        self.ascertainView.button.buttonWhetherClick = ButtonCanClick;
        return YES;
    }else{
        
        return NO;
        
    }
    
}
/**
 *   确定按钮点击事件
 */
- (void)ascertainViewButtonClick{
    
    if ([Factory valiMobile:self.phoneView.phoneFiled.text]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //查询用户是否已经注册过
        [DownLoadData postUsername:^(id obj, NSError *error) {
            
            [hud setHidden:YES];
            
            if ([obj[@"result"] isEqualToString:@"fail"]) {
                
                //说明用户此时已经注册过了
                UserSignVC *tempVC = [[UserSignVC alloc] init];
                tempVC.mobile = self.phoneView.phoneFiled.text;
                [self presentViewController:tempVC animated:YES completion:nil];
                
            }
            else{
                
                //用户还未注册
                UserRegisterVC *tempVC = [[UserRegisterVC alloc] init];
                tempVC.mobile = self.phoneView.phoneFiled.text;
                [self presentViewController:tempVC animated:YES completion:nil];
                
            }
            
        } andusername:self.phoneView.phoneFiled.text];
    }else{
        [Factory alertMes:@"请输入正确的手机号"];
    }
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
                    
                    //[self dialogWithTitle:TitleMes message:Message nsTag:1];
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
//                    //点击我的弹出
//                    if ([self.presentTag isEqualToString:@"0"]) {
//                        
//                        [self dismissViewControllerAnimated:YES completion:nil];
//                        
//                    }
//                    //账户设置弹出
//                    else if ([self.presentTag isEqualToString:@"1"]) {
//                        
//                        [self dismissViewControllerAnimated:YES completion:nil];
//                        
//                        UINavigationController *navi = [delegate.leveyTabBarController.viewControllers lastObject];
//                        [navi popToRootViewControllerAnimated:YES];
//                        [delegate.leveyTabBarController hidesTabBar:NO animated:YES];
//                    }
//                    //立即投资弹出
//                    else if ([self.presentTag isEqualToString:@"2"]) {
//                        //                UINavigationController *navi = [delegate.leveyTabBarController.viewControllers firstObject];
//                        //                [navi popViewControllerAnimated:YES];
//                        [self dismissViewControllerAnimated:YES completion:nil];
//                    }else {
//                        
//                        [self dismissViewControllerAnimated:YES completion:nil];
//                        
//                    }
                    
                    [self dismissToRootViewController];
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
- (void)onClickLeftItem {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
/**
 *  键盘消失
 */
- (void)doneButton:(UIButton *)button {

    [self.view endEditing:YES];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //隐藏导航栏的分割线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    self.navigationController.navigationBar.hidden = YES;
    
    if (_click == 0) {
        self.titleLabel.text = @"登录/注册";
    }
    _click ++;
    
    //设置状态栏颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];

}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

@end
