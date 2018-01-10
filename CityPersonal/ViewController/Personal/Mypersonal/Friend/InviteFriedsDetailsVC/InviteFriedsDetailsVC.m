//
//  InviteFriedsDetailsVC.m
//  CityJinFu
//
//  Created by mic on 2017/6/27.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "InviteFriedsDetailsVC.h"
#import "InviteFriendVC.h"
#import "CodeView.h"
#import "InviteFriendModel.h"
#import "AwardAndInviteVC.h"

@interface InviteFriedsDetailsVC ()<FactoryDelegate, UIWebViewDelegate>

@property (nonatomic ,strong) MBProgressHUD *hud;
@property (nonatomic, strong) UIView *backgroundImage;
@property (nonatomic, strong) Reachability *conn;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIButton *shareBtn;//二维码分享按钮
@property (nonatomic, strong) UIButton *inviteBtn;//分享邀请
@property (nonatomic, strong) UIImage *imgName;//二维码
@property (nonatomic, strong) CodeView *codeview;
@property (nonatomic, strong) InviteFriendModel *inviteFriendModel;
@property (nonatomic, strong) NSString *realName;//用户的名字

@end

@implementation InviteFriedsDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];;
    [TitleLabelStyle addtitleViewToVC:self withTitle:@"邀请好友" andTextColor:0];
    //左边按钮
    UIButton *leftButton = [Factory addLeftbottonToVC:self];//左边的按钮
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    
    //网络请求实时改变
    Factory *factory = [[Factory alloc]init];
    factory.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkStateChanged) name:kReachabilityChangedNotification object:nil];
    self.conn = [Reachability reachabilityForInternetConnection];
    [self.conn startNotifier];
    
    //二维码分享按钮
    [self.view addSubview:self.shareBtn];
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(336*m6Scale, 89*m6Scale));
        make.bottom.mas_equalTo(-KSafeBarHeight);
        make.left.mas_equalTo(20*m6Scale);
    }];
    //分享邀请
    [self.view addSubview:self.inviteBtn];
    [self.inviteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(336*m6Scale, 89*m6Scale));
        make.bottom.mas_equalTo(-KSafeBarHeight);
        make.right.mas_equalTo(-20*m6Scale);
    }];
    [self loadWebView];//H5页面
    //请求数据
    [self getData];
}
/**
 *请求数据
 */
- (void)getData{
    //获取二维码
    [DownLoadData postGetUserQrCode:^(id obj, NSError *error) {
        _imgName = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:obj[@"qrCode"]]]];
    } userId:[HCJFNSUser stringForKey:@"userId"]];
    
        //邀请好友首页
        [DownLoadData postInviteFriendByUserId:^(id obj, NSError *error) {
            _inviteFriendModel = [[InviteFriendModel alloc] initWithDictionary:obj];
        } userId:[HCJFNSUser stringForKey:@"userId"]];
    
    [DownLoadData postInviteUserMessage:^(id obj, NSError *error) {
        
        
        _realName = [NSString stringWithFormat:@"%@", obj[@"realname"]];
        NSLog(@"%@", _realName);
        if (![_realName isEqual:[NSNull null]] && ![_realName isEqualToString:@""] && _realName != nil && ![_realName isEqualToString:@"<null>"]) {
            
            _realName = [_realName stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"*"];
            
            
        }else {
            
            
        }
        
    } userId:[HCJFNSUser objectForKey:@"userId"]];
}
/**
 *  返回
 */
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *网络情况的实时监控
 */
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
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kScreenHeight-NavigationBarHeight-89*m6Scale-15*m6Scale-KSafeBarHeight)];
        _webView.delegate = self;
        _webView.scrollView.scrollEnabled = YES;
    }
    
    return _webView;
}
/**
 * 二维码分享按钮
 */
- (UIButton *)shareBtn{
    if(!_shareBtn){
        _shareBtn = [UIButton buttonWithType:0];
        [_shareBtn addTarget:self action:@selector(shareButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_shareBtn setImage:[UIImage imageNamed:@"inviteFried_二维码分享"] forState:0];
    }
    return _shareBtn;
}
/**
 * 分享邀请
 */
- (UIButton *)inviteBtn{
    if(!_inviteBtn){
        _inviteBtn = [UIButton buttonWithType:0];
        [_inviteBtn addTarget:self action:@selector(inviteFriedButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_inviteBtn setImage:[UIImage imageNamed:@"inviteFried_分享邀请"] forState:0];
    }
    return _inviteBtn;
}
/**
 *  二维码分享按钮点击事件
 */
- (void)shareButtonClick{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _codeview = [[CodeView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _codeview.img = _imgName;
    UITapGestureRecognizer *clipTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didCancelActivityAction:)];
    [self.codeview addGestureRecognizer:clipTap];
    [delegate.window addSubview:_codeview];
    _codeview.codeImage.image = _imgName;
    //_codeview.codeImage.image = [UIImage qrCodeImageWithContent:@""
    //                                                      codeImageSize:200
    //                                                               logo:_imgName
    //                                                          logoFrame:CGRectMake(75, 75, 500, 500)
    //                                                                red:253.0/255.0
    //                                                              green:182.0/255.0
    //                                                               blue:21/225.0];
}
//点击取消按钮
- (void)didCancelActivityAction:(UIGestureRecognizer *)tap {

    [UIView animateWithDuration:1 animations:^{

        self.codeview.alpha = 0.0;

    } completion:^(BOOL finished) {

        if (finished) {

            self.codeview.hidden = YES;
        }
    }];
    //做图片放大的效果
    [UIView beginAnimations:@"Animations_4" context:nil];
    [UIView setAnimationDuration:1];
    self.codeview.transform = CGAffineTransformScale(self.codeview.transform, 3, 3);
    [UIView commitAnimations];

}
/**
 * 分享邀请按钮点击事件
 */
- (void)inviteFriedButtonClick{
    openShareView *openShare = [[openShareView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    openShare.isBanner = @"1";
    NSString *name;
    NSString *url;
    if (![_realName isEqual:[NSNull null]] && ![_realName isEqualToString:@""] && _realName != nil && ![_realName isEqualToString:@"<null>"]) {
        name = [NSString stringWithFormat:@"%@推荐你使用汇诚金服，还送万元体验金+388元红包", _realName];
        url =  [NSString stringWithFormat:@"https://www.hcjinfu.com/html/invitationRegister.html?invite=%@&name=%@",[NSString stringWithFormat:@"%@", _inviteFriendModel.inviteCode], _realName];
    }else {
        url =  [NSString stringWithFormat:@"https://www.hcjinfu.com/html/invitationRegister.html?invite=%@&name=%@",[NSString stringWithFormat:@"%@", _inviteFriendModel.inviteCode], @""];
        name = [NSString stringWithFormat:@"推荐你使用汇诚金服，还送万元体验金+388元红包"];
    }
    //在分享的过程中。假如分享的字符串中带有汉子的话，必须要转成UTF8格式，否则会造成乱码
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    openShare.bodyMessage = [NSString stringWithFormat:@"注册即得388元红包+10000元体验金！来银行资金存管平台，安全放心。"];
    openShare.strUrl = url;
    openShare.urlName = name;
    [delegate.window addSubview:openShare];
    [delegate.window bringSubviewToFront:openShare];
}
//请求webView
- (void)loadWebView
{
    //网络监听
    NSInteger state = [Factory checkNetwork];
    if (state == 0) {
        [Factory showFasHud];
        
    } else {
        //确定url网址
        NSURL *url = [NSURL URLWithString:self.url];
        
        //和H5交互
        JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        context[@"scan"] = ^() {
            
            NSArray *args = [JSContext currentArguments];
            for (JSValue *jsVal in args) {
                NSLog(@"%@", jsVal.toString);
                if ([jsVal.toString containsString:@"inviteReward"]){
                    
                    //与h5做交互  要把UI提示放在主线程  否则会crash
                    dispatch_async(dispatch_get_main_queue(), ^{
                        AwardAndInviteVC *tempVC = [AwardAndInviteVC new];
                        tempVC.type = @"1";
                        [self.navigationController pushViewController:tempVC animated:YES];
                    });
                }
            }
        };
        
        NSData *data = [NSData dataWithContentsOfURL:url];
        if (data == nil) {
            //(121,196)
            _backgroundImage = [[UIView alloc] init];
            _backgroundImage.backgroundColor = [[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"无数据"]];
            [self.webView addSubview:_backgroundImage];
            [_backgroundImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.webView.mas_centerX);
                make.centerY.mas_equalTo(self.webView.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(244*m6Scale, 244*m6Scale));
            }];
        } else {
            [_backgroundImage removeFromSuperview];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view addSubview:self.webView];//加载webview
    _webView.backgroundColor = backGroundColor;
    [self.view bringSubviewToFront:self.shareBtn];
    [self.view bringSubviewToFront:self.inviteBtn];
    
    [Factory hidentabar];//隐藏tabar
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.barTintColor = navigationColor;
    //navigationBar延展性并设置透明
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    //隐藏导航栏的分割线
    UIImage *colorImage = [Factory imageWithColor:[UIColor clearColor] size:CGSizeMake(self.view.frame.size.width, 0.001)];
    [self.navigationController.navigationBar setBackgroundImage:colorImage forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setShadowImage:[Factory imageWithColor:[UIColor clearColor] size:CGSizeMake(self.view.frame.size.width, 0.001)]];
    [Factory navgation:self];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}


@end
