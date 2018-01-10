//
//  AchieveVC.m
//  CityJinFu
//
//  Created by xxlc on 16/10/27.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "AchieveVC.h"

@interface AchieveVC ()<FactoryDelegate,UIWebViewDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic ,strong) MBProgressHUD *hud;
@property (nonatomic, strong) UIView *backgroundImage;//无数据背景
@property (nonatomic, strong) Reachability *conn;
@property (nonatomic, strong) NSURLConnection *theConnection;

@end

@implementation AchieveVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backGroundColor;
    //导航栏设置
    self.navigationController.navigationBar.translucent = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.navigationController.navigationBar.barTintColor = navigationColor;
    if (_acTag == 0) {
        [TitleLabelStyle addtitleViewToVC:self withTitle:@"领取红包"];
    }else if (_acTag == 1){
        [TitleLabelStyle addtitleViewToVC:self withTitle:@"充值提现问题"];
    }else if (_acTag == 2){
        [TitleLabelStyle addtitleViewToVC:self withTitle:@"银行卡绑定问题"];
    }else if(_acTag == 3){
        [TitleLabelStyle addtitleViewToVC:self withTitle:@"其他问题"];
    }else if (_acTag == 5){
        [TitleLabelStyle addtitleViewToVC:self withTitle:_titileStr];//合同标题
    }else if (_acTag == 7){
        [TitleLabelStyle addtitleViewToVC:self withTitle:@"银行限额"];
    }else{
        [TitleLabelStyle addtitleViewToVC:self withTitle:@"龙虎榜"];
    }
    //左边按钮
    UIButton *leftButton = [Factory addLeftbottonToVC:self];//左边的按钮
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.webView];
    [self loadWebView];
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
        //取消右侧，下侧滚动条，去处上下滚动边界的黑色背景
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
                        _inScrollview.hidden = YES;  //上下滚动出边界时的黑色的图片
                    }
                }
            }
        }
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
        
        NSURL *url;
        
        if (self.acTag == 0) {
            url = [NSURL URLWithString:_urlStr];
            NSLog(@"5555+++%@",_urlStr);
        }else if(_acTag == 1){
            url = [NSURL URLWithString:@"http://url.cn/40v49eS"];//充值提现问题
        }else if(_acTag == 2){
            
            url = [NSURL URLWithString:@"http://url.cn/40v4AEy"];//银行卡绑定问题
        }else if(_acTag == 3){
            url = [NSURL URLWithString:@"http://url.cn/40vEaGD"];//其他问题链接
        }else if (_acTag == 5){
            NSLog(@"%@",_urlStr);
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/user/getContracts?orderNo=%@",Localhost,_orderNO]];
//            url = [[NSBundle mainBundle] URLForResource:_urlStr withExtension:nil];
//            url = [NSURL URLWithString:path];
            NSLog(@"%@----%@",_urlStr,url);
            
        }else if (_acTag == 7){
            url = [NSURL URLWithString:@"https://cunguanbao.ucfpay.com/mobileTrade/bankListSearch"];
        }else{
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/html/ranking.html",Localhost]];//龙虎榜
        }
        NSData *data = [NSData dataWithContentsOfURL:url];
        if (data == nil) {
            //(121,196)
            _backgroundImage = [[UIView alloc]initWithFrame:CGRectMake((_webView.frame.size.width -130)/2, (_webView.frame.size.height -130)/2, 130, 130)];
            _backgroundImage.backgroundColor = [[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"无数据"]];
            [self.webView addSubview:_backgroundImage];
        } else {
//            if (_acTag == 5) {
//                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                _webView.scalesPageToFit = YES;
//                [self.webView loadRequest:request];
//                
//            }else{
                NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0];
                [self.webView loadRequest:request];
//            }
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
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
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
