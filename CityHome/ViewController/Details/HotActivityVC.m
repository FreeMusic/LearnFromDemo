//
//  HotActivityVC.m
//  CityJinFu
//
//  Created by mic on 2017/6/30.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "HotActivityVC.h"

@interface HotActivityVC ()<FactoryDelegate,UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic ,strong) MBProgressHUD *hud;
@property (nonatomic, strong) UIView *backgroundImage;
@property (nonatomic, strong) Reachability *conn;

@end

@implementation HotActivityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [TitleLabelStyle addtitleViewToVC:self withTitle:@"热门活动"];
    
    self.view.backgroundColor = backGroundColor;
    //左边按钮
    UIButton *leftButton = [Factory addLeftbottonToVC:self];//左边的按钮
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.webView];
    
    [self scroll];//取消右侧，下侧滚动条
    [self loadWebView];
    
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
- (void)onClickLeftItem{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    
    [Factory hidentabar];
    [Factory navgation:self];
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
        
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-70)];
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
        
        NSURL *url = [NSURL URLWithString:@"http://mp.weixin.qq.com/mp/homepage?__biz=MzAwNTY5ODA3OA==&hid=1&sn=42aeea95a4a71a6debe2aa7e4eeae8b2#wechat_redirect"];
        
        NSData *data = [NSData dataWithContentsOfURL:url];
        if (data == nil) {
            //(121,196)
            _backgroundImage = [[UIView alloc]initWithFrame:CGRectMake((_webView.frame.size.width -130)/2, (_webView.frame.size.height -130)/2, 130, 130)];
            _backgroundImage.backgroundColor = [[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"暂无内容"]];
            [self.webView addSubview:_backgroundImage];
        } else {
            NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
            [self.webView loadRequest:request];
        }
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    [self labelExample];
    
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


@end
