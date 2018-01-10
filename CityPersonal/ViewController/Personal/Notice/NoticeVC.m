//
//  NoticeVC.m
//  CityJinFu
//
//  Created by xxlc on 16/8/22.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "NoticeVC.h"
#import "NoticeView.h"

@interface NoticeVC ()
@property (nonatomic, copy) NSString *whetherAppPush;//推送
@property (nonatomic, copy) NSString *whetherSms;//短信
@property (nonatomic, copy) NSString *whetherSiteMail;//站内信
@property (nonatomic, copy) NoticeView *notice;
@property (nonatomic, assign) NSInteger nstag;

@end

@implementation NoticeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backGroundColor;
    //导航栏设置
    self.navigationController.navigationBar.translucent = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.navigationController.navigationBar.barTintColor = navigationColor;
    //标题
    [TitleLabelStyle addtitleViewToVC:self withTitle:@"通知设置"];
    //左边按钮
    UIButton *leftButton = [Factory addLeftbottonToVC:self];//左边的按钮
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    
    _notice = [[NoticeView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_notice];
    NSLog(@"%ld",(long)_nstag);
    [self serverData];//服务器数据
    //判断系统通知是否开启
    if ([[UIApplication sharedApplication] currentUserNotificationSettings].types  == UIUserNotificationTypeNone) {
            [Factory alertMes:@"系统通知已经关闭,您可以在\n设置>通知>汇诚金服 中手动设置"];
    }
   
}
/**
 *  返回
 */
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  服务器数据
 */
- (void)serverData{
    NSUserDefaults *user = HCJFNSUser;
    NSMutableDictionary *muDiction = [NSMutableDictionary dictionary];
    [muDiction setValue:[user objectForKey:@"userId"] forKey:@"userId"];//用户id
    
    [DownLoadData postWithSystem:^(id obj, NSError *error) {
        
        NSLog(@"%@",obj);
        _whetherSms = [obj[@"whetherSms"] stringValue];//短信
        _whetherSiteMail = [obj[@"whetherSiteMail"] stringValue];//站内信
        _whetherAppPush = [obj[@"whetherAppPush"] stringValue];//推送

        [_notice whetherSms:_whetherSms andwhetherSiteMail:_whetherSiteMail andwhetherAppPush:_whetherAppPush];
        
    } userId:muDiction andtag:0];
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
