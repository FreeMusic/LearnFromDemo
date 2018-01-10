//
//  ActivityVC.m
//  CityJinFu
//
//  Created by xxlc on 16/8/19.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "ActivityVC.h"
#import "InvestResultVC.h"

@interface ActivityVC ()<FactoryDelegate,UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic ,strong) MBProgressHUD *hud;
@property (nonatomic, strong) UIView *backgroundImage;
@property (nonatomic, strong) Reachability *conn;
@property (nonatomic, copy) UIView *navigationView;//导航条

@end

@implementation ActivityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backGroundColor;
    //    //标题
    //    if (self.tag == 0) {
    //        [TitleLabelStyle addtitleViewToVC:self withTitle:_urlName];
    //    }else{
    //        [TitleLabelStyle addtitleViewToVC:self withTitle:_urlName];
    //    }
    //    //左边按钮
    //    UIButton *leftButton = [Factory addLeftbottonToVC:self];//左边的按钮
    //    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    if (_tag == 1) {
        [TitleLabelStyle addtitleViewToVC:self withTitle:@"项目合同"];
        //左边按钮
        UIButton *leftButton = [Factory addLeftbottonToVC:self];//左边的按钮
        [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    }else{
        _navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        NSLog(@"===%@",NSStringFromCGRect(_navigationView.frame));
        _navigationView.backgroundColor = Colorful(252, 140, 1);
        [self.navigationController.view addSubview:_navigationView];
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
        
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
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
        self.backgroundImage.hidden = NO;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:TitleMes message:@"操作无法完成，请检查网络设置！" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {             [self.navigationController popViewControllerAnimated:YES];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        
        //        NSURL *url = [NSURL URLWithString:self.strUrl];
        //        if (self.tag == 0) {
//        if (self.strUrl == nil) {
//            self.backgroundImage.hidden = NO;
//        }else{
            self.backgroundImage.hidden = YES;
            //加载html数据
            self.webView.scalesPageToFit = YES;
            [self.webView loadHTMLString:self.strUrl baseURL:nil];
//        }
        //        }else{
        //            url = [NSURL URLWithString: _strUrl];
        //        }
        //        if (_tag == 3) {
        //            NSString *body = [NSString stringWithFormat: @"userId=%@&bizType=%@", [defaults objectForKey:@"userId"],@"06"];
        //            NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url];
        //            [request setHTTPMethod: @"POST"];
        //            [request setHTTPBody: [body dataUsingEncoding: NSUTF8StringEncoding]];
        //            [self.webView loadRequest: request];
        //        }else{
        //            NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:0.5];
        //            if (request == nil){
        //                //(121,196)
        //                self.backgroundImage.hidden = NO;
        //            } else {
        //                self.backgroundImage.hidden = YES;
        //                [self.webView loadRequest:request];
        //
        //            }
        //        }
    }
}
/**
 *暂无数据背景图片
 */
- (UIView *)backgroundImage{
    if(!_backgroundImage){
        _backgroundImage = [[UIView alloc]initWithFrame:CGRectMake((_webView.frame.size.width -130)/2, (_webView.frame.size.height -260)/2, 130, 130)];
        _backgroundImage.backgroundColor = [[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"无数据"]];
        [self.webView addSubview:_backgroundImage];
    }
    return _backgroundImage;
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    [self labelExample];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *url = [[request URL] absoluteString];
    NSLog(@"%@",url);
    //根据返回的URL或者scheme来判断
    //当 tag为3的时候  说明是从投资页面跳转来的
    if (_tag == 3) {
        if ([url hasPrefix:@"storemanager://api"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }else if([url hasPrefix:@"storemanager://backInvest"]){
            NSArray *array = [url componentsSeparatedByString:@"="];
            NSString *orderId = array[1];
            //投资返回查询投资状态
            InvestResultVC *tempVC = [InvestResultVC new];
            tempVC.orderId = orderId;
            [self.navigationController pushViewController:tempVC animated:YES];
        }
    }else{
        if ([url hasPrefix:@"storemanager://"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }else if ([url containsString:@"redirectReturnUrl"]){
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
    return YES;
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
//HUD
- (void)labelExample {
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Set the label text.
    _hud.label.text = NSLocalizedString(@"加载中...", @"HUD loading title");
    // You can also adjust other label properties if needed.
    // hud.label.font = [UIFont italicSystemFontOfSize:16.f];
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        sleep(10.);
        
    });
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    if (_tag == 1) {
        self.navigationController.navigationBar.hidden = NO;
    }else{
        self.navigationController.navigationBar.hidden = YES;
    }
    
    //    //隐藏导航栏的分割线
    //    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    //    //导航栏颜色
    //    [self.navigationController.navigationBar setColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    //    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
    //                                                         forBarMetrics:UIBarMetricsDefault];
    [Factory hidentabar];
    //    [Factory navgation:self];
    _navigationView.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    _navigationView.hidden = YES;
}

@end
