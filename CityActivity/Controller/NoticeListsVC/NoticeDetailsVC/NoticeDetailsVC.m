//
//  NoticeDetailsVC.m
//  CityJinFu
//
//  Created by mic on 2017/6/27.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "NoticeDetailsVC.h"

@interface NoticeDetailsVC ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) UILongPressGestureRecognizer *pressGS;

@end

@implementation NoticeDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"公告详情";
    
    //左边按钮
    UIButton *leftButton = [Factory addLeftbottonToVC:self];
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    
    self.view.backgroundColor = backGroundColor;
    //创建页面
    [self CreateUI];
}
/**
 *  返回
 */
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  长按手势
 */
- (UILongPressGestureRecognizer *)pressGS{
    if(!_pressGS){
        _pressGS = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction)];
        _pressGS.minimumPressDuration = 0.3;
    }
    return _pressGS;
}
/**
 *公告详情页面的创建
 */
- (void)CreateUI{
    //标题
    UILabel *titleLabel = [Factory CreateLabelWithTextColor:1 andTextFont:30 andText:self.titleStr addSubView:self.view];
    titleLabel.textColor = UIColorFromRGB(0x393939);
    titleLabel.numberOfLines = 0;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20*m6Scale);
        make.top.mas_equalTo(34*m6Scale);
        make.width.mas_equalTo(kScreenWidth-40*m6Scale);
    }];
    //时间
    UILabel *timeLabel = [Factory CreateLabelWithTextColor:1 andTextFont:28 andText:self.time addSubView:self.view];
    timeLabel.textColor = UIColorFromRGB(0xA5A5A5);
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20*m6Scale);
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(38*m6Scale);
    }];
    //中间单线
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = UIColorFromRGB(0xA5A5A5);
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(timeLabel.mas_right).offset(20*m6Scale);
        make.top.mas_equalTo(timeLabel.mas_top);
        make.size.mas_equalTo(CGSizeMake(1, 30*m6Scale));
    }];
    //作者
    UILabel *authorLabel = [Factory CreateLabelWithTextColor:1 andTextFont:28 andText:@"汇诚金服" addSubView:self.view];
    authorLabel.textColor = UIColorFromRGB(0xA5A5A5);
    [authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line.mas_right).offset(20*m6Scale);
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(38*m6Scale);
    }];
    //用WebView加载html内容
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.label.text = @"加载中...";
    [self.view addSubview:self.webView];
    //修改HTML代码中的一些图片和文字属性
    NSString *htmls = [NSString stringWithFormat:@"<html> \n"
                       "<head> \n"
                       "<style type=\"text/css\"> \n"
                       "body {font-size:15px;}\n"
                       "</style> \n"
                       "</head> \n"
                       "<body>"
                       "<script type='text/javascript'>"
                       "window.onload = function(){\n"
                       "var $img = document.getElementsByTagName('img');\n"
                       "for(var p in  $img){\n"
                       " $img[p].style.width = '100%%';\n"
                       "$img[p].style.height ='auto'\n"
                       "}\n"
                       "}"
                       "</script>%@"
                       "</body>"
                       "</html>",self.contents];
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '50%'"];
    [self.webView loadHTMLString:htmls baseURL:nil];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0*m6Scale);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(kScreenHeight-150*m6Scale-NavigationBarHeight);
    }];
}
/**
 *  webView
 */
- (UIWebView *)webView{
    if(!_webView){
        _webView = [[UIWebView alloc] init];
        _webView.delegate = self;
        _webView.backgroundColor = backGroundColor;
        _webView.opaque = NO;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
    }
    
    return _webView;
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
    _webView.scalesPageToFit = YES;
    
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout = 'none';"];
    webView.userInteractionEnabled = YES;
    [webView addGestureRecognizer:self.pressGS];
}
/**
 *  长按手势
 */
- (void)longPressAction{
    
}
@end
