//
//  AssetsVC.m
//  CityJinFu
//
//  Created by xxlc on 16/8/24.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "AssetsVC.h"

@interface AssetsVC ()<FactoryDelegate,UIWebViewDelegate>{
    
}
@property (nonatomic ,strong) MBProgressHUD *hud;
@property (nonatomic, strong) UIView *backgroundImage;
@property (nonatomic, strong) Reachability *conn;
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation AssetsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backGroundColor;
    //标题
    [TitleLabelStyle addtitleViewToVC:self withTitle:@"资产明细"];
    //导航设置
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = navigationColor;
    //左边按钮
    UIButton *leftButton = [Factory addLeftbottonToVC:self];//左边的按钮
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.webView];//加载webview
    
    _webView.backgroundColor = backGroundColor;
    [self loadWebView];//H5页面
    //网络请求实时改变
    Factory *factory = [[Factory alloc]init];
    factory.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkStateChanged) name:kReachabilityChangedNotification object:nil];
    self.conn = [Reachability reachabilityForInternetConnection];
    [self.conn startNotifier];
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
- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-NavigationBarHeight)];
        [_webView sizeToFit];
        _webView.opaque = NO;
        _webView.delegate = self;
        _webView.scrollView.scrollEnabled = YES;
        
    }
    
    return _webView;
}
//请求webView
- (void)loadWebView
{
    NSUserDefaults *user = HCJFNSUser;
    
    //网络监听
    NSInteger state = [Factory checkNetwork];
    if (state == 0) {
        [Factory showFasHud];
        UIAlertView *alert1 = [[UIAlertView alloc]initWithTitle:TitleMes message:@"操作无法完成，请检查网络设置！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [alert1 show];
    } else {
       NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/html/property.html?%@?%@?%@",Localhost,[user objectForKey:@"userId"],[user objectForKey:@"userToken"],[user objectForKey:@"token"]]];//链接,token添加
        NSData *data = [NSData dataWithContentsOfURL:url];
        if (data == nil) {
            //(121,196)
            _backgroundImage = [[UIView alloc]initWithFrame:CGRectMake((_webView.frame.size.width -130)/2, (_webView.frame.size.height -130)/2, 130, 130)];
            _backgroundImage.backgroundColor = [[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"无数据"]];
            [self.webView addSubview:_backgroundImage];
        } else {
            NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
            [self.webView loadRequest:request];
        }
    }
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self labelExample];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_hud hideAnimated:YES];
    });
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
    [super viewWillAppear:animated];
    [Factory hidentabar];//隐藏
    [Factory navgation:self];//导航
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
