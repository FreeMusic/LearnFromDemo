//
//  DetailsVC.m
//  CityJinFu
//
//  Created by xxlc on 16/8/25.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "DetailsVC.h"

@interface DetailsVC ()<FactoryDelegate,UIWebViewDelegate,UIAlertViewDelegate,UIScrollViewDelegate>{
    CGFloat contentOffY;
}
@property (nonatomic ,strong) MBProgressHUD *hud;
@property (nonatomic, strong) UIView *backgroundImage;
@property (nonatomic, strong) Reachability *conn;
@property (nonatomic, strong) NSString *y;
@property (nonatomic, assign) CGFloat lastY;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat lastOffsetY;
@property (nonatomic, assign) NSInteger click;
@end

@implementation DetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [TitleLabelStyle addtitleViewToVC:self withTitle:self.title color:[UIColor whiteColor]];
     
    //网络请求实时改变
    Factory *factory = [[Factory alloc]init];
    factory.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkStateChanged) name:kReachabilityChangedNotification object:nil];
    self.conn = [Reachability reachabilityForInternetConnection];
    [self.conn startNotifier];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(webviewshouldScroll:) name:@"webviewshouldScroll" object:nil];
   
    self.click = 0;
   
    self.lastOffsetY = 0;

    self.lastY = 0;
}

- (void)panGestureWithAction:(UIPanGestureRecognizer *)pan {
    
    NSLog(@"%f,%f",[pan translationInView:self.view].y,self.lastOffsetY);
    
    if (self.lastY <= 0) {
        
        NSLog(@"%f,%f",[pan translationInView:self.view].y,self.lastOffsetY);
        
        if ([pan translationInView:self.view].y) {
            
            if ([pan translationInView:self.view].y < self.lastOffsetY) {
                
                self.sc.scrollEnabled = YES;
                
                for (UIGestureRecognizer *ge in [self.view gestureRecognizers]) {
                    
                    ge.enabled = YES;
                }
                
                [self.sc setContentOffset:CGPointMake(0, - [pan translationInView:self.view].y * 2) animated:YES];
                
            }else {
                
                for (UIGestureRecognizer *ge in [self.view gestureRecognizers]) {
                    
                    ge.enabled = NO;
                }
                
                NSLog(@"%f",[pan translationInView:self.view].y);
                
                if ([pan translationInView:self.view].y > 0 && [pan translationInView:self.view].y > self.lastOffsetY) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"itemScrollViewOffset" object:nil];
                }
                
            }
            
            
            self.lastOffsetY = [pan translationInView:self.view].y;
            
            if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled) {
                
                self.lastOffsetY = 0;
            }
        }
    }
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
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-190*m6Scale-64)];
        _webView.delegate = self;
        
        _webView.scrollView.scrollEnabled = YES;
        
    }
    
    return _webView;
}
//请求webView
- (void)loadWebView
{
    NSUserDefaults *user = HCJFNSUser;
    NSString *ItemId = [user objectForKey:@"zyyItemId"];
    NSLog(@"9999++++%@",ItemId);
    
    //网络监听
    NSInteger state = [Factory checkNetwork];
    if (state == 0) {
        [Factory showFasHud];
        UIAlertView *alert1 = [[UIAlertView alloc]initWithTitle:TitleMes message:@"操作无法完成，请检查网络设置！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [alert1 show];
    } else {
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/html/detail.html?itemId=%@&token=%@",Localhost,ItemId,[user objectForKey:@"token"]]];//链接,token添加
        NSLog(@"%@", url);
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

#pragma mark - UIScrollViewDelegate
//开始滚动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    contentOffY = scrollView.contentOffset.y;
}
/** 正在滚动 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    if (scrollView.contentOffset.y <= 0) {
        
        self.sc.scrollEnabled = NO;
        
        if (self.click == 0) {
            
            UIPanGestureRecognizer *panClip = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureWithAction:)];
            
            [self.view addGestureRecognizer:panClip];
            
        }
        
        self.click ++;
        
        for (UIGestureRecognizer *ge in [self.view gestureRecognizers]) {
            
            ge.enabled = YES;
        }
        
    }

    self.lastY = scrollView.contentOffset.y;
    
    
}

- (void)webviewshouldScroll:(NSNotification*)noti
{
    NSLog(@"%@",noti.object);
    _y = noti.object;
    contentOffY = 0;
    
//    int i = 10;
//    [_sc setContentOffset:CGPointMake(0, i ++) animated:NO];
    _webView.scrollView.scrollEnabled = YES;
    [self scrollViewDidScroll:_sc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //导航设置
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = navigationYellowColor;
    [self.view addSubview:self.webView];//加载webview
    NSArray *array = [NSArray arrayWithArray:[self.webView subviews]];
    _sc = (UIScrollView *)[array objectAtIndex:0];
    _sc.delegate = self;
    _webView.backgroundColor = backGroundColor;
    [self loadWebView];//H5页面
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor whiteColor]};
}


- (void)dealloc
{
    [self.webView removeFromSuperview];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"webviewshouldScroll" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.webView removeFromSuperview];
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
