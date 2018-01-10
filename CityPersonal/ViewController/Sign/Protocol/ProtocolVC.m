//
//  ProtocolVC.m
//  CityJinFu
//
//  Created by xxlc on 16/9/21.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "ProtocolVC.h"

@interface ProtocolVC ()
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, copy) NSString* htmlPath;
@property (nonatomic, assign) NSInteger click;
@end

@implementation ProtocolVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backGroundColor;
    //导航栏设置
    self.navigationController.navigationBar.translucent = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.navigationController.navigationBar.barTintColor = navigationColor;
    //标题
    //    if (_strTag.intValue == 1) {
    //        [TitleLabelStyle addtitleViewToVC:self withTitle:@"汇诚金服注册协议"];
    //    }else if(_strTag.intValue == 2 || _strTag.intValue == 3){
    //        [TitleLabelStyle addtitleViewToVC:self withTitle:@"自动投标授权书"];
    //    }else{
    //        [TitleLabelStyle addtitleViewToVC:self withTitle:@"汇诚金服注册协议"];
    //    }
    //左边按钮
    UIButton *leftButton = [Factory addLeftbottonToVC:self];
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    [self protocol];
    
    self.click = 0;
}
/**
 *  返回
 */
- (void)onClickLeftItem
{
    if (_strTag.intValue == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
        NSUserDefaults *user = HCJFNSUser;//控制开关的不锁定
        [user setValue:@"1" forKey:@"autoZyy"];
        [user synchronize];
    }
}
/**
 *  webview
 */
- (void)protocol{
    
    if (_strTag.intValue == 1) {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }else{
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, NavigationBarHeight, self.view.frame.size.width, self.view.frame.size.height-NavigationBarHeight)];
    }
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
    
    [self.view addSubview:_webView];
    NSString *str = @"";
    if (_strTag.intValue == 0) {
        str = @"protocol";
    }else if(_strTag.intValue == 2){
        str = @"activity";
    }else if (_strTag.intValue == 4){
        str = @"auto";
    }else if(_strTag.intValue == 3){
        str = @"autoBook";
    }
    
    _htmlPath = [[NSBundle mainBundle] pathForResource:str ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:_htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:_htmlPath];
    [_webView loadHTMLString:appHtml baseURL:baseURL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (_click == 0) {
        //隐藏导航栏的分割线
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
        
        self.navigationController.navigationBar.hidden = YES;
        //标题
        if (_strTag.intValue == 1) {
            self.titleLabel.text = @"汇诚金服注册协议";
        }else if(_strTag.intValue == 2 || _strTag.intValue == 3){
            self.titleLabel.text = @"自动投标授权书";
        }else if (_strTag.intValue == 4){
            self.titleLabel.text = @"锁投加息协议";
        }else if (_strTag.intValue == 5){
            self.titleLabel.text = @"三方存管协议";
        }
        else{
            self.titleLabel.text = @"汇诚金服注册协议";
        }
    }
    _click ++;
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
