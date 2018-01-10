//
//  ThirdSignView.m
//  CityJinFu
//
//  Created by mic on 2017/10/10.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "ThirdSignView.h"
#import "WXApiRequestHandler.h"
#import "NewSignVC.h"
#import "ThirdPartLoginViewController.h"
#import "WeiboSDK.h"
#import "AppDelegate.h"

@interface ThirdSignView ()



@end

@implementation ThirdSignView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        //微博登录按钮
        _blogButton = [self commonButtonAndNumber:1];
        //微信登录按钮
        _weChatButton = [self commonButtonAndNumber:2];
        //QQ登录
        _qqbutton = [self commonButtonAndNumber:3];
        
        //第三方登录标识
        [self thirdClassSignIdentification];
    }
    
    return self;
}
/**
 *  第三方登录标识
 */
- (void)thirdClassSignIdentification{
    
    //标题
    UILabel *titleLabel = [Factory CreateLabelWithTextColor:0.4 andTextFont:28 andText:@"第三方登录" addSubView:self];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    //左边 右边两条单线
    for (int i = 0; i < 2; i++) {
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = UIColorFromRGB(0xe4e4e4);
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(199*m6Scale, 1));
            make.top.mas_equalTo(13*m6Scale);
            if (i == 0) {
                make.right.mas_equalTo(titleLabel.mas_left).offset(-20*m6Scale);
            }else{
                make.left.mas_equalTo(titleLabel.mas_right).offset(20*m6Scale);
            }
        }];
        
    }
}
/**
 *  commonButton
 */
- (UIButton *)commonButtonAndNumber:(NSInteger)number{
    
    UIButton *button = [UIButton buttonWithType:0];
    button.tag = 100+number;
    [self addSubview:button];
    
    switch (number) {
        case 1:{
            
            [button setImage:[UIImage imageNamed:@"NewSign_微博"] forState:0];
            
        }
            break;
            
        case 2:{
            
            [button setImage:[UIImage imageNamed:@"NewSign_微信"] forState:0];
            
        }
            break;
            
        case 3:{
            
            [button setImage:[UIImage imageNamed:@"NewSign_QQ"] forState:0];
            
        }
            break;
            
        default:
            break;
    }
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80*m6Scale, 80*m6Scale));
        make.bottom.mas_equalTo(-104*m6Scale);
        if (number == 1) {
            make.left.mas_equalTo(150*m6Scale);
        }else if (number == 2){
            make.centerX.mas_equalTo(self.mas_centerX);
        }else{
            make.right.mas_equalTo(-150*m6Scale);
        }
    }];
    
    [button addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
    
}

/**
 *  第三方登录
 */
- (void)button:(UIButton *)sender{
    //    UIViewController *ctr = (UIViewController *)[self ViewController];
    //    ThirdPartyVC *thridParty = [ThirdPartyVC new];
    //    [ctr.navigationController pushViewController:thridParty animated:YES];
    
    //    //构造SendAuthReq结构体
    //    SendAuthReq* req =[[SendAuthReq alloc] init];
    //    req.scope = @"snsapi_userinfo" ;
    //    req.state = @"123" ;
    //    req.openID = @"wxe288f2e30492370f";
    //    //第三方向微信终端发送一个SendAuthReq消息结构
    //    [WXApi sendReq:req];
    //    return [WXApi sendAuthReq:req
    //               viewController:self
    //                     delegate:[WXApiManager sharedManager]];
    //    [ctr presentViewController:thridParty animated:YES completion:nil];
    //qq授权登录
    if (sender.tag == 103) {
        
        self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1105689249" andDelegate:self];
        
        NSArray* permissions = [NSArray arrayWithObjects:
                                kOPEN_PERMISSION_GET_USER_INFO,
                                kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                                kOPEN_PERMISSION_ADD_SHARE,
                                kOPEN_PERMISSION_CHECK_PAGE_FANS,
                                kOPEN_PERMISSION_GET_INFO,
                                kOPEN_PERMISSION_GET_OTHER_INFO,
                                kOPEN_PERMISSION_GET_VIP_INFO,
                                kOPEN_PERMISSION_GET_VIP_RICH_INFO,
                                nil];
        
        [self.tencentOAuth authorize:permissions localAppId:@"1105689249" inSafari:NO];
    }
    //微博授权登录
    else if (sender.tag == 101) {
        
        WBAuthorizeRequest *request = [WBAuthorizeRequest request];
        request.redirectURI = @"https://api.weibo.com/oauth2/default.html";
        request.scope = @"all";
        request.userInfo = @{@"SSO_From": @"NewSignVC",
                             @"Other_Info_1": [NSNumber numberWithInt:123],
                             @"Other_Info_2": @[@"obj1", @"obj2"],
                             @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
        [WeiboSDK sendRequest:request];
        
    }
    //微信授权登录
    else {
        
        [self sendAuthRequest];
        
    }
}
//三方登录微信相关
- (void)sendAuthRequest {
    [WXApiManager sharedManager].delegate = self;
    [WXApiRequestHandler sendAuthRequestScope:@"snsapi_userinfo"
                                        State:@"123"
                                       OpenID:@" "
                             InViewController:[self ViewController]];
}
#pragma mark - WXApiManagerDelegate
- (void)managerDidRecvAuthResponse:(SendAuthResp *)response {
    
    if (response.code.length > 0) {
        
        //获取微信用户openId
        [DownLoadData getWechatMessage:^(id obj, NSError *error) {
            
            if (obj[@"openid"]) {
                
                //获取微信用户头像
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                
                
                
                [DownLoadData getWechatUserInfo:^(id object, NSError *error) {
                    
                    NSLog(@"%@",object[@"headimgurl"]);
                    if (![user objectForKey:@"userIcon"]) {
                        
                        NSURL *url = [NSURL URLWithString:object[@"headimgurl"]];
                        NSData *data = [NSData dataWithContentsOfURL:url];
                        
                        [user setValue:data forKey:@"userIcon"];
                        [user setValue:object[@"nickname"] forKey:@"nickname"];
                        [user synchronize];
                    }
                    
                    [self judgeThirdWithOpenId:obj[@"openid"] type:@"weixin" nickname:object[@"nickname"]];
                    
                } token:obj[@"access_token"] openId:obj[@"openId"]];
            }
            
        } code:response.code];
        
    }
}
#pragma mark - QQ相关
- (void)tencentDidLogin {
    
    NSLog(@"%@,%@",self.tencentOAuth.accessToken,self.tencentOAuth.openId);
    
    [self.tencentOAuth getUserInfo];
    
    
}

//获取qq用户个人信息
- (void)getUserInfoResponse:(APIResponse*)response {
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    if (![user objectForKey:@"userIcon"]) {
        
        NSURL *url = [NSURL URLWithString:response.jsonResponse[@"figureurl_qq_2"]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        [user setValue:data forKey:@"userIcon"];
        [user setValue:response.jsonResponse[@"nickname"] forKey:@"nickname"];
        [user synchronize];
    }
    
    
    
    if (self.tencentOAuth.accessToken.length > 0) {
        
        [self judgeThirdWithOpenId:self.tencentOAuth.openId type:@"qq" nickname:response.jsonResponse[@"nickname"]];
        
    }
}
- (void)tencentDidNotLogin:(BOOL)cancelled {
    if (cancelled) {
        
        NSLog(@"cancel");
    }else {
        
        NSLog(@"other");
    }
}

- (void)tencentDidNotNetWork {
    
    
}

- (void)judgeThirdWithOpenId:(NSString *)openId type:(NSString *)type nickname:(NSString *)nickname {
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    [DownLoadData postLoginWithOtherSelector:^(id obj, NSError *error) {
        
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        NSLog(@"%@",obj);
        
        if ([obj[@"result"] isEqualToString:@"success"]) {
            
            //用户ID存入本地
            [user setValue:[NSString stringWithFormat:@"%@",obj[@"userId"]] forKey:@"userId"];
            [user setValue:obj[@"result"] forKey:@"result"];
            [user setValue:obj[@"userToken"] forKey:@"userToken"];//userToken
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
            
            NewSignVC *signVC = (NewSignVC *)[self ViewController];
            
            [DownLoadData postUserSystemSetting:^(id object, NSError *error) {
                [signVC.hud hideAnimated:YES];
                if ([obj[@"messageCode"] isEqualToString:@"sys.error"]) {
                    
                    //                    [signVC dialogWithTitle:TitleMes message:Message nsTag:0];
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
//                    //点击我的弹出
//                    if ([self.presentTag isEqualToString:@"0"]) {
//                        
//                        [signVC dismissViewControllerAnimated:YES completion:nil];
//                        
//                    }
//                    //账户设置弹出
//                    else if ([self.presentTag isEqualToString:@"1"]) {
//                        
//                        [signVC dismissViewControllerAnimated:YES completion:nil];
//                        
//                        UINavigationController *navi = [delegate.leveyTabBarController.viewControllers lastObject];
//                        [navi popToRootViewControllerAnimated:YES];
//                        [delegate.leveyTabBarController hidesTabBar:NO animated:YES];
//                    }
//                    //立即投资弹出
//                    else if ([self.presentTag isEqualToString:@"2"]) {
//                        //                UINavigationController *navi = [delegate.leveyTabBarController.viewControllers firstObject];
//                        //                [navi popViewControllerAnimated:YES];
//                        [signVC dismissViewControllerAnimated:YES completion:nil];
//                    }else {
//                        
//                        
//                        [signVC dismissViewControllerAnimated:YES completion:nil];
//                    }
                    [signVC dismissToRootViewController];
                    //用户在登录成功之后，发送通知，在个人中心判断用户是否已经实名，假如没有实名，弹窗提示用户去实名
                    NSNotification *notification = [[NSNotification alloc] initWithName:@"loginRealNameView" object:nil userInfo:nil];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                    UserDefaults(@"fail", @"sxyRealName");
                }
            } userId:[user objectForKey:@"userId"]];
            
        }else {
            
            ThirdPartLoginViewController *thirdVC = [[ThirdPartLoginViewController alloc] init];
            
            thirdVC.loginType = type;
            
            thirdVC.openId = openId;
            
            thirdVC.presentTag = self.presentTag;
            
            [[self ViewController] presentViewController:thirdVC animated:YES completion:nil];
            
        }
        
    } openId:openId type:type clientId:[user objectForKey:@"clientId"] nickname:[user objectForKey:@"thirdMessage"][@"nickname"]];
}

@end
