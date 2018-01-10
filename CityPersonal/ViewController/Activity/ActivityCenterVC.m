//
//  ActivityCenterVC.m
//  CityJinFu
//
//  Created by xxlc on 16/8/23.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "ActivityCenterVC.h"
#import "openShareView.h"
#import "NewSignVC.h"
#import "IntegralShopVC.h"
#import "IphoneVC.h"
#import "MywelfareVC.h"
#import "CalendarVC.h"
#import "InviteFriendVC.h"
#import "VipVC.h"

@interface ActivityCenterVC ()<FactoryDelegate,UIWebViewDelegate>{
    
}

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic ,strong) MBProgressHUD *hud;
@property (nonatomic, strong) UIView *backgroundImage;
@property (nonatomic, strong) Reachability *conn;
@property (nonatomic, strong) UINavigationBar *QYnavBar;//导航设置
@property (nonatomic, strong) NSString *shareURL;//分享的链接

@end

@implementation ActivityCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backGroundColor;
    
    //左边按钮
    UIButton *leftButton = [Factory addLeftbottonToVC:self];//左边的按钮
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    //右边按钮
    UIButton *rightBtn = [Factory addRightbottonToVC:self andImageName:@"分享"];
    [rightBtn addTarget:self action:@selector(rightBtn) forControlEvents:UIControlEventTouchUpInside];
    
    //标题
    if (self.tag == 0) {
        
        [TitleLabelStyle addtitleViewToVC:self withTitle:@"活动中心"];
        rightBtn.hidden = YES;
        
    }else if (self.tag == 1) {
        
        [TitleLabelStyle addtitleViewToVC:self withTitle:@"信息动态"];
        rightBtn.hidden = NO;
    }else if(self.tag == 3){
        [TitleLabelStyle addtitleViewToVC:self withTitle:_urlName];
        rightBtn.hidden = NO;
    }else if(self.tag == 6||self.tag == 2){
        rightBtn.hidden = NO;
        [TitleLabelStyle addtitleViewToVC:self withTitle:_urlName];
    }
    else{
        [TitleLabelStyle addtitleViewToVC:self withTitle:_urlName];
        rightBtn.hidden = YES;
    }
    [self.view addSubview:self.webView];
    [self scroll];//取消右侧，下侧滚动条
    [self loadWebView];
    
    //网络请求实时改变
    Factory *factory = [[Factory alloc]init];
    factory.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkStateChanged) name:kReachabilityChangedNotification object:nil];
    self.conn = [Reachability reachabilityForInternetConnection];
    [self.conn startNotifier];

    NSLog(@"2222++++%@",_strUrl);
}
/**
 *  返回
 */
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  分享
 */
- (void)rightBtn{
    
    openShareView *openShare = [[openShareView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    openShare.isBanner = @"1";
    openShare.urlName = @"汇诚金服";
    openShare.bodyMessage = self.urlName;
    openShare.strUrl = self.shareURL;
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.window addSubview:openShare];
    [delegate.window bringSubviewToFront:openShare];
    
}
- (void)netWorkStateChanged{
    NSInteger state = [Factory checkNetwork];
    //当有网状态下请求数据
    if (state == 1 || state == 2) {
        [self loadWebView];
    }
}
//取消右侧，下侧滚动条，去处上下滚动边界的黑色背景
- (void)scroll
{
    for (UIView *_aView in [_webView subviews])
    {
        if ([_aView isKindOfClass:[UIScrollView class]])
        {
            [(UIScrollView *)_aView setShowsVerticalScrollIndicator:NO];
            //右侧的滚动条
            
            [(UIScrollView *)_aView setShowsHorizontalScrollIndicator:NO];
            //下侧的滚动条
            
            for (UIView *_inScrollview in _aView.subviews)
            {
                if ([_inScrollview isKindOfClass:[UIImageView class]])
                {
                    _inScrollview.hidden = YES;//上下滚动出边界时的黑色的图片
                }
            }
        }
    }
}

- (UIWebView *)webView
{
    if (!_webView) {
        
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-60)];
        _webView.backgroundColor = backGroundColor;
        _webView.opaque = NO;
        _webView.delegate = self;
        
    }
    return _webView;
}
//请求webView
- (void)loadWebView
{
    //网络监听
    NSInteger state = [Factory checkNetwork];
    if (state == 0) {
        [Factory showFasHud];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:TitleMes message:@"操作无法完成，请检查网络设置！" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSURL *url;
        
        if (self.tag == 0) {
            
            url = [NSURL URLWithString:uRL];
            self.shareURL = uRL;
        }else if(_tag == 1){
            
            url = [NSURL URLWithString:uRL];
            self.shareURL = uRL;
        }else if(_tag == 3){
            
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/html/risk.html?userId=%@&token=%@&userToken=%@",Localhost,[user objectForKey:@"userId"], [user stringForKey:@"token"], [user stringForKey:@"userToken"]]];
            self.shareURL = [NSString stringWithFormat:@"%@/html/risk.html?userId=%@&token=%@&userToken=%@",Localhost,[user objectForKey:@"userId"], [user stringForKey:@"token"], [user stringForKey:@"userToken"]];
            NSLog(@"%@", url);
            //和H5交互
            JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
            context[@"scan"] = ^() {
                
                NSArray *args = [JSContext currentArguments];
                for (JSValue *jsVal in args) {
                    NSLog(@"%@", jsVal.toString);
                    if ([jsVal.toString containsString:@"index"]){
                        
                        //与h5做交互  要把UI提示放在主线程  否则会crash
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.navigationController popToRootViewControllerAnimated:NO];
                            
                            //在风险评估页面中，如果用户点击前去投资按钮，则需要跳转到首页中去
                            //                       [self.navigationController popViewControllerAnimated:NO];
                            NSNotification *notification = [[NSNotification alloc] initWithName:@"GoToHome" object:nil userInfo:nil];
                            [[NSNotificationCenter defaultCenter] postNotification:notification];
                        });
                    }
                }
            };
        }else if (_tag == 10){
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?userToken=%@&token=%@&userId=%@",Localhost,_strUrl,[user objectForKey:@"userToken"], [user stringForKey:@"token"], [HCJFNSUser stringForKey:@"userId"]]];
            self.shareURL = [NSString stringWithFormat:@"%@%@?userToken=%@&token=%@&userId=%@",Localhost,_strUrl,[user objectForKey:@"userToken"], [user stringForKey:@"token"], [HCJFNSUser stringForKey:@"userId"]];
        }else if (_tag == 20){//项目合同
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/html/web/viewer.html?file=%@", Localhost,_strUrl]];
            
            self.shareURL = [NSString stringWithFormat:@"%@/html/web/viewer.html?file=%@", Localhost,_strUrl];
            NSLog(@"%@", url);
            
        }else if (_tag == 50){
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?token=%@",Localhost,_strUrl,[user objectForKey:@"token"]]];
            self.shareURL = [NSString stringWithFormat:@"%@%@?token=%@",Localhost,_strUrl,[user objectForKey:@"token"]];
        }else if (_tag == 1500){
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", Localhost, _strUrl]];
            
        }
        else{
            //            url = [NSURL URLWithString:_strUrl];
            if (_tag == 5) {
                url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?userToken=%@&userId=%@",_strUrl,[user objectForKey:@"userToken"], [HCJFNSUser stringForKey:@"userId"]]];
                self.shareURL = [NSString stringWithFormat:@"%@?userToken=%@",_strUrl,[user objectForKey:@"userToken"]];
            }else if (_tag == 7){
                //公司介绍  项目信息  运营数据 新手指引  信息披露
                url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?token=%@",_strUrl,[user objectForKey:@"token"]]];
                self.shareURL = [NSString stringWithFormat:@"%@?token=%@",_strUrl,[user objectForKey:@"token"]];
            }else if (_tag == 2000){
                url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?userToken=%@&token=%@&userId=%@",@"http://activity.hcjinfu.com",_strUrl,[user objectForKey:@"userToken"], [user stringForKey:@"token"], [HCJFNSUser stringForKey:@"userId"]]];
                self.shareURL = [NSString stringWithFormat:@"%@%@?userToken=%@&token=%@",Localhost,_strUrl,[user objectForKey:@"userToken"], [user stringForKey:@"token"]];
            }else if (_tag == 2001){
                url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?userToken=%@&token=%@&userId=%@&isAdd=1",@"http://activity.hcjinfu.com",_strUrl,[user objectForKey:@"userToken"], [user stringForKey:@"token"], [HCJFNSUser stringForKey:@"userId"]]];
                self.shareURL = [NSString stringWithFormat:@"%@%@?userToken=%@&token=%@&isAdd=1",Localhost,_strUrl,[user objectForKey:@"userToken"], [user stringForKey:@"token"]];
            }else if (_tag == 1000){
                url = [NSURL URLWithString:_strUrl];
                self.shareURL = _strUrl;
            }else if(_tag == 1001){
                url = [NSURL URLWithString:[NSString stringWithFormat:@"%@userId=%@", _strUrl, [HCJFNSUser stringForKey:@"userId"]]];
            }else{
                if (_isNeedLogin) {
                    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?userToken=%@&userId=%@",_strUrl,[user objectForKey:@"userToken"], [HCJFNSUser stringForKey:@"userId"]]];
                    self.shareURL = [NSString stringWithFormat:@"%@?userToken=%@&userId=%@",_strUrl,[user objectForKey:@"userToken"], [HCJFNSUser stringForKey:@"userId"]];
                }else{
                    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",_strUrl]];
                    self.shareURL = _strUrl;
                }
            }
            
            //和H5交互
            JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
            context[@"scan"] = ^() {
                /**
                 *
                 1.h5跳App 理财页面 参数：invest
                 2.h5跳App 积分商城 参数：integralShop
                 3.h5跳App 锁投有礼 参数：shop
                 4.h5跳App 我的福利 参数：myWelfare
                 5.h5跳App 投资日历 参数：calendar
                 6.h5跳App 邀请好友 参数：inviteFriend
                 7.h5跳App 会员中心 参数：vipClub
                 8.h5跳App 注册    参数：register
                 9.h5跳App 七鱼聊天 参数：callPhone

                 ios方法名：scan()
                 android方法名：consume.postMessage()
                 */
                NSArray *args = [JSContext currentArguments];
                for (JSValue *jsVal in args) {
                    NSLog(@"%@", jsVal.toString);
                    if([jsVal.toString isEqualToString:@"register"]){//新手指引跳注册页面
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if([defaults objectForKey:@"userId"]){

                                [Factory alertMes:@"您已登录"];

                            }else{
                                NewSignVC *regist = [[NewSignVC alloc]init];
                                [self presentViewController:regist animated:YES completion:nil];
                            }
                        });
                    }else if ([jsVal.toString isEqualToString:@"invest"]){
                        //跳转投资页面
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSNotification *noti = [[NSNotification alloc] initWithName:@"UserGoToInvest" object:nil userInfo:nil];
                            [[NSNotificationCenter defaultCenter] postNotification:noti];

                            [self.navigationController popToRootViewControllerAnimated:NO];
                        });
                    }else if ([jsVal.toString isEqualToString:@"integralShop"]){
                        //跳转积分商城页面(首先判断用户是否登录)
                        if ([HCJFNSUser stringForKey:@"userId"]) {
                            //兑吧免登陆接口
                            [DownLoadData postLogFreeUrl:^(id obj, NSError *error) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    IntegralShopVC *tempVC = [IntegralShopVC new];
                                    tempVC.strUrl = obj[@"ret"];
                                    [self.navigationController pushViewController:tempVC animated:YES];
                                });
                            } userId:[HCJFNSUser stringForKey:@"userId"] redicrect:@""];
                        }else{
                            //与h5做交互  要把UI提示放在主线程  否则会crash 提示用户未登录
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [Factory alertMes:@"请您先登录"];
                            });
                        }
                    }else if ([jsVal.toString isEqualToString:@"shop"]){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //跳转至锁投有礼页面
                            IphoneVC *tempVC = [IphoneVC new];
                            [self.navigationController pushViewController:tempVC animated:YES];
                        });
                    }else if ([jsVal.toString isEqualToString:@"myWelfare"]){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //跳转至我的福利页面
                            if ([HCJFNSUser stringForKey:@"userId"]) {
                                MywelfareVC *tempVC = [MywelfareVC new];
                                [self.navigationController pushViewController:tempVC animated:YES];
                            }else{
                                //与h5做交互  要把UI提示放在主线程  否则会crash 提示用户未登录
                                [Factory alertMes:@"请您先登录"];
                            }
                        });
                    }else if ([jsVal.toString isEqualToString:@"calendar"]){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //跳转至投资日历
                            if ([HCJFNSUser stringForKey:@"userId"]) {
                                CalendarVC *tempVC = [CalendarVC new];
                                [self.navigationController pushViewController:tempVC animated:YES];
                            }else{
                                //与h5做交互  要把UI提示放在主线程  否则会crash 提示用户未登录
                                [Factory alertMes:@"请您先登录"];
                            }
                        });
                    }else if ([jsVal.toString isEqualToString:@"inviteFriend"]){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //跳转至邀请好友
                            if ([HCJFNSUser stringForKey:@"userId"]) {
                                InviteFriendVC *tempVC = [InviteFriendVC new];
                                [self.navigationController pushViewController:tempVC animated:YES];
                            }else{
                                //与h5做交互  要把UI提示放在主线程  否则会crash 提示用户未登录
                                [Factory alertMes:@"请您先登录"];
                            }
                        });
                    }else if ([jsVal.toString isEqualToString:@"vipClub"]){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //跳转至会员
                            if ([HCJFNSUser stringForKey:@"userId"]) {
                                VipVC *tempVC = [VipVC new];
                                [self.navigationController pushViewController:tempVC animated:YES];
                            }else{
                                //与h5做交互  要把UI提示放在主线程  否则会crash 提示用户未登录
                                [Factory alertMes:@"请您先登录"];
                            }
                        });
                    }else if ([jsVal.toString isEqualToString:@"callPhone"]){
                        //跳转至七鱼聊天
                        dispatch_async(dispatch_get_main_queue(), ^{
                            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                            hud.label.text = NSLocalizedString(@"连接中...", @"HUD loading title");
                            //用户个人信息
                            [DownLoadData postUserInformation:^(id obj, NSError *error) {

                                NSLog(@"%@-------",obj);

                                if (obj[@"usableCouponCount"]) {

                                    [HCJFNSUser setValue:obj[@"usableCouponCount"] forKey:@"Red"];
                                }
                                if (obj[@"usableTicketCount"]) {
                                    [HCJFNSUser setValue:obj[@"usableTicketCount"] forKey:@"Ticket"];

                                }
                                if ([obj[@"identifyCard"] isKindOfClass:[NSNull class]] || obj[@"identifyCard"] == nil) {
                                    [HCJFNSUser setValue:@"1" forKey:@"IdNumber"];
                                }else{
                                    [HCJFNSUser setValue:obj[@"identifyCard"] forKey:@"IdNumber"];
                                }
                                NSArray *array = obj[@"accountBankList"];
                                if ([array count] == 0) {
                                    [HCJFNSUser setValue:@"1" forKey:@"cardNo"];
                                }else{

                                    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                        [HCJFNSUser setValue:obj[@"cardNo"] forKey:@"cardNo"];
                                    }];
                                }
                                [HCJFNSUser setValue:[obj[@"accountBankList"] firstObject][@"realname"] forKey:@"realname"];//姓名
                                [HCJFNSUser synchronize];
                                [hud setHidden:YES];
                                //在线客服
                                QYSessionViewController *sessionViewController = [Factory jumpToQY];
                                UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:sessionViewController];
                                if (iOS11) {
                                    self.QYnavBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, kScreenWidth, NavigationBarHeight)];
                                }else{
                                    self.QYnavBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, NavigationBarHeight)];
                                }
                                UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"汇诚金服"];
                                TitleLabelStyle *titleLabel = [[TitleLabelStyle alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
                                [titleLabel titleLabel:@"汇诚金服" color:[UIColor blackColor]];
                                navItem.titleView = titleLabel;
                                UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fanghui"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];

                                left.tintColor = [UIColor blackColor];
                                [self.QYnavBar pushNavigationItem:navItem animated:NO];
                                [navItem setLeftBarButtonItem:left];
                                //    [navItem setRightBarButtonItem:right];
                                [navi.view addSubview:self.QYnavBar];
                                //电池点两条
                                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
                                [self presentViewController:navi animated:YES completion:nil];
                            } userId:[HCJFNSUser objectForKey:@"userId"]];
                        });
                    }else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.navigationController popViewControllerAnimated:YES];
                        });
                    }

                }
            };
        }
        NSData *data = [NSData dataWithContentsOfURL:url];
        if (data == nil) {
            //(121,196)
            _backgroundImage = [[UIView alloc]initWithFrame:CGRectMake((_webView.frame.size.width -130)/2, (_webView.frame.size.height -130)/2, 130, 130)];
            _backgroundImage.backgroundColor = [[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"无数据"]];
            [self.webView addSubview:_backgroundImage];
        } else {
            //NSString* htmlstr = [self.shareURL initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
            if ([self.shareURL hasSuffix:@".png"] || [self.shareURL hasSuffix:@".jpg"]) {
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                [self.webView loadRequest:request];
            }else{
                NSData *data = [[NSData alloc] initWithContentsOfURL:url options:0 error:nil];
                [self.webView loadData:data MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:url];
            }
        }
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    [self labelExample];
    
}
#pragma mark - 网易七鱼返回
- (void)onBack:(UINavigationItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_hud hideAnimated:YES];
    });
    
    CGSize contentSize = _webView.scrollView.contentSize;
    CGSize viewSize = self.view.bounds.size;
    
    float rw = viewSize.width / contentSize.width;
    
    _webView.scrollView.minimumZoomScale = rw;
    _webView.scrollView.maximumZoomScale = rw;
    _webView.scrollView.zoomScale = rw;
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *url = [[request URL] absoluteString];
    NSLog(@"%@",url);
    //根据返回的URL或者scheme来判断
    if ([url containsString:@"personal"]){
        //[self.navigationController popViewControllerAnimated:YES];
    }else if ([url containsString:@"index"]){
        
        [self.navigationController popToRootViewControllerAnimated:NO];
        
        //在风险评估页面中，如果用户点击前去投资按钮，则需要跳转到首页中去
        NSNotification *notification = [[NSNotification alloc] initWithName:@"GoToHome" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        //[self.navigationController popToRootViewControllerAnimated:NO];
    }
    
    return YES;
}

//HUD
- (void)labelExample {
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Set the label text.
    _hud.label.text = NSLocalizedString(@"加载中...", @"HUD loading title");
    // You can also adjust other label properties if needed.
    // hud.label.font = [UIFont italicSystemFontOfSize:16.f];
    
    //    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
    //        sleep(10.);
    //
    //    });
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    //导航栏设置
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = navigationColor;
    [Factory hidentabar];//隐藏
    [Factory navgation:self];//导航
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
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
