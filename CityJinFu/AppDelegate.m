//
//  AppDelegate.m
//  CityJinFu
//
//  Created by xxlc on 16/8/8.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "AppDelegate.h"
#import "CityViewController.h"
#import "GuidePageViewController.h"
#import <Bugrpt/NTESCrashReporter.h>//云捕
#import "FingerLockView.h"
#import "LockTestView.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "XHLaunchAd.h"
//微信SDK头文件
#import "WXApi.h"
#import "WXApiManager.h"

#import "ActivityCenterVC.h"
#import <AdSupport/AdSupport.h>
#import "AdvertiseView.h"//广告页
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#import "NewSignVC.h"
#import "ForceUpdateView.h"

#endif
@interface AppDelegate ()<WeiboSDKDelegate,UIAlertViewDelegate,UNUserNotificationCenterDelegate,XHLaunchAdDelegate,XHLaunchAdDownloadDelegate>
@property (nonatomic, strong) NSString *deviceToken;
@property (nonatomic, strong) FingerLockView *fingerView; //指纹解锁界面
@property (nonatomic, strong) UIImageView *lockImageView; //手势解锁界面
@property (nonatomic, strong) LockTestView *lockTestView;
@property (nonatomic, copy) NSString *uuid;//唯一标识
@property (nonatomic, copy) NSString *activityURL; //活动链接
@property (nonatomic, strong) UIApplication *application;
@property (nonatomic, copy) NSDictionary *launchOptions;
@property (nonatomic, strong) id obj;
@property (nonatomic, strong) NSArray *tabBarArr;

@property (nonatomic, strong) UIImage *normalImageName;

@property (nonatomic, strong) UIImage *highlightImageName;

@property (nonatomic, strong) ForceUpdateView *view;//强更视图

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    //控制器
    [self inintBarDataSource];
    //获取udid
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    _uuid = [[UIDevice currentDevice].identifierForVendor UUIDString];//uuid
    [self appTocken];//token
    self.launchOptions = launchOptions;
    self.application = application;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setValue:idfa forKey:@"idfa"];
    [user synchronize];
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = navigationColor;
    _navigation = [[UINavigationController alloc]initWithRootViewController:[CityViewController new]];
    [self.window makeKeyWindow];
    //导航栏颜色
    [[UINavigationBar appearance] setBarTintColor:navigationColor];
    
    //NSArray *imgArr = [XNFactory getTabImageArrWithTabNameArr:self.tabBarArray];
    
    //后台定时执行
    [[UIApplication sharedApplication] setKeepAliveTimeout:4 handler:^{
        
    }];
    
    [self judgeProtectSafe];
    // [self judgeActivity];//老版启动页活动
    //判断是否第一次进入app
    if ([user objectForKey:@"firstLogin"]) {
        
        self.window.rootViewController = self.leveyTabBarController;
        
    }else {
        
        GuidePageViewController *guideVC = [[GuidePageViewController alloc] init];
        
        self.window.rootViewController = guideVC;
    }
    
    //网易七鱼
    [[QYSDK sharedSDK] registerAppId:WYAppId appName:@"汇诚金服"];
    //openShare
    //    [OpenShare connectQQWithAppId:@"1103194207"];
    //    [OpenShare connectWeiboWithAppKey:@"402180334"];
    //    [OpenShare connectWeixinWithAppId:@"wxd930ea5d5a258f4f"];
    //    [OpenShare connectRenrenWithAppId:@"228525" AndAppKey:@"1dd8cba4215d4d4ab96a49d3058c1d7f"];
    //    [OpenShare connectAlipay];//支付宝参数都是服务器端生成的，这里不需要key.
    //微博登录
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:@"1427892513"];
    //向微信注册第三方登录
    [WXApi registerApp:@"wxe288f2e30492370f"];
    //云捕
    [[NTESCrashReporter sharedInstance] initWithAppId:APPId];
    /**
     *  通过appId、AppKey、AppSecret启动个推，并完成APNS注册及APNS的透传消息
     */
    [[UIApplication sharedApplication]cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;//小红点
    [self startGePush];
    //    [NSThread sleepForTimeInterval:4.0];//启动页延迟
    //统计
    [TalkingData sessionStarted:TakingAppId withChannelId:@"AppStore"];
    [self shareSdk];//分享
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] < 10.0){
        //当应用被杀死，通过本地通知进入后调这里
        NSDictionary *noticeDic = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
        if (noticeDic) {
            [self performSelector:@selector(pushComingViewController) withObject:nil afterDelay:2.0f];//要用延时方法跳转
        }
    }
    
    [self launchImage];//新版启动广告图
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getIcon) name:@"getIcon" object:nil];
    //保证多次点击只触发一个点击事件
    [[UIButton appearance] setExclusiveTouch:YES];
    
    return YES;
}

- (void)getIcon{
    
    NSMutableArray *arr = [NSMutableArray array];
    
    for (int i = 0; i < self.tabBarArray.count; i++)
    {
        NSString *imageName = self.tabBarArray[i];
        NSDictionary *imgDict = [XNFactory getTabImageDictForName:imageName];
        [arr addObject:imgDict];
    }
    
    self.tabBarArr = arr;
    
    [_leveyTabBarController initWithImgArr: self.tabBarArr];
    
}
- (void)getTabImageArrWithTabNameArr:(NSArray*)tabNameArr
{
    
    [DownLoadData postGetBottonIcon:^(id obj, NSError *error) {
        
        NSMutableArray *arr = [NSMutableArray array];
        
        NSMutableArray *textArr = [NSMutableArray array];
        
        self.tabBarArr = obj;
        
        if (self.tabBarArr.count) {
            
            if ([self.tabBarArr isKindOfClass:[NSArray class]]) {
                //假如有网络
                for (int i = 0; i < self.tabBarArr.count; i++) {
                    
                    NSDictionary *dic = self.tabBarArr[i];
                    
                    NSString *url = dic[@"picturePath"];
                    
                    NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:url]];
                    
                    UIImage *image = [UIImage imageWithData:data];
                    
                    NSString *pictureName = [NSString stringWithFormat:@"%@", dic[@"pictureName"]];
                    
                    [textArr addObject:pictureName];
                    
                    if ([pictureName containsString:@"首页"]) {
                        
                        if ([pictureName containsString:@"未选中"]) {
                            
                            _normalImageName = image;
                            
                        }else{
                            
                            _highlightImageName = image;
                            
                        }
                        
                    }else if ([pictureName containsString:@"理财"]){
                        
                        if ([pictureName containsString:@"未选中"]) {
                            
                            _normalImageName = image;
                            
                        }else{
                            
                            _highlightImageName = image;
                            
                        }
                        
                    }else if ([pictureName containsString:@"发现"]){
                        
                        if ([pictureName containsString:@"未选中"]) {
                            
                            _normalImageName = image;
                            
                        }else{
                            
                            _highlightImageName = image;
                            
                        }
                        
                    }else{
                        
                        if ([pictureName containsString:@"未选中"]) {
                            
                            _normalImageName = image;
                            
                        }else{
                            
                            _highlightImageName = image;
                            
                        }
                    }
                    
                    if (i == 1 || i == 3 || i == 5 || i == 7) {
                        
                        NSMutableDictionary *imgDic = [NSMutableDictionary dictionaryWithCapacity:0];
                        
                        [imgDic setValue:_normalImageName forKey:@"Default"];
                        
                        [imgDic setValue:_highlightImageName forKey:@"Seleted"];
                        
                        [arr addObject:imgDic];
                        
                    }
                }
                
                self.tabBarArr = arr;
                
                static dispatch_once_t onceToken;
                dispatch_once(&onceToken, ^{
                    
                    [_leveyTabBarController initWithImgArr: self.tabBarArr];
                    
                });
            }else{
                for (int i = 0; i < tabNameArr.count; i++)
                {
                    NSString *imageName = tabNameArr[i];
                    NSDictionary *imgDict = [XNFactory getTabImageDictForName:imageName];
                    [arr addObject:imgDict];
                }
                
                self.tabBarArr = arr;
                
                [_leveyTabBarController initWithImgArr: self.tabBarArr];
            }
            
        }else{
            
            
            for (int i = 0; i < tabNameArr.count; i++)
            {
                NSString *imageName = tabNameArr[i];
                NSDictionary *imgDict = [XNFactory getTabImageDictForName:imageName];
                [arr addObject:imgDict];
            }
            
            self.tabBarArr = arr;
            
            [_leveyTabBarController initWithImgArr: self.tabBarArr];
            
        }
        
    }];
}
#pragma mark ====版本更新
/**
 *检测App更新（后台控制，可强更）
 */
- (void)appUpDate{
    [DownLoadData postAppVersionUpdate:^(id obj, NSError *error) {
        if (obj) {
            //2先获取当前工程项目版本号
            NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
            NSString *currentVersion=infoDic[@"CFBundleShortVersionString"];
            //打印版本号
            currentVersion = [currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
            if (currentVersion.length==2) {
                currentVersion  = [currentVersion stringByAppendingString:@"0"];
            }else if (currentVersion.length==1){
                currentVersion  = [currentVersion stringByAppendingString:@"00"];
            }
            NSString *appStoreVersion  = obj[@"iosVersion"];
            appStoreVersion = [appStoreVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
            if (appStoreVersion.length==2) {
                appStoreVersion  = [appStoreVersion stringByAppendingString:@"0"];
            }else if (appStoreVersion.length==1){
                appStoreVersion  = [appStoreVersion stringByAppendingString:@"00"];
            }
            //4当前版本号小于商店版本号,就更新
            if([currentVersion floatValue] < [appStoreVersion floatValue] && [obj[@"iosFlag"] integerValue] == 0)
            {
                //初始化AlertView
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"版本有更新"
                                                                message:[NSString stringWithFormat:@"检测到新版本(%@),是否更新?",obj[@"iosVersion"]]
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"更新",nil];
                alert.tag = 201;
                [alert show];
                
            }//强制更新
            else if ([currentVersion floatValue] < [appStoreVersion floatValue] && [obj[@"flag"] integerValue] == 1){
                
                if (!_view) {
                   _view = [[ForceUpdateView alloc] initWithFrame:CGRectMake(0, 0, kscreenWidth, kscreenHeight)];
                    [self.window addSubview:_view];
                    [_view.upDateBtn sd_setImageWithURL:[NSURL URLWithString:obj[@"iosPicture"][@"picturePath"]]];
                }
                
                
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"版本有更新"
//                                                                message:[NSString stringWithFormat:@"检测到新版本(%@),去更新",obj[@"iosVersion"]]
//                                                               delegate:self
//                                                      cancelButtonTitle:nil
//                                                      otherButtonTitles:@"更新",nil];
//                alert.tag = 200;
//                [alert show];
                
            }
            else{
                NSLog(@"版本号好像比商店大噢!检测到不需要更新");
            }
            
            
        }
    }];
}
//应用商店控制更新（无法强更）
- (void)updateApp{
    //2先获取当前工程项目版本号
    /*  NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
     NSString *currentVersion=infoDic[@"CFBundleShortVersionString"];*/
    
    //3从网络获取appStore版本号
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil]];
    //POST必须上传的字段
    NSDictionary *dict = @{@"id":STOREAPPID};//此处的Apple ID
    [manager POST:@"https://itunes.apple.com/lookup" parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *array = responseObject[@"results"];
        if (array.count == 0 || array == nil) {
            NSLog(@"还没上线");
        }else{
            NSDictionary *dic = array[0];
            NSString *appStoreVersion = dic[@"version"];
            //2先获取当前工程项目版本号
            NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
            NSString *currentVersion=infoDic[@"CFBundleShortVersionString"];
            //设置版本号
            currentVersion = [currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
            if (currentVersion.length==2) {
                currentVersion  = [currentVersion stringByAppendingString:@"0"];
            }else if (currentVersion.length==1){
                currentVersion  = [currentVersion stringByAppendingString:@"00"];
            }
            appStoreVersion = [appStoreVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
            if (appStoreVersion.length==2) {
                appStoreVersion  = [appStoreVersion stringByAppendingString:@"0"];
            }else if (appStoreVersion.length==1){
                appStoreVersion  = [appStoreVersion stringByAppendingString:@"00"];
            }
            
            //4当前版本号小于商店版本号,就更新
            if([currentVersion floatValue] < [appStoreVersion floatValue])
            {
                //初始化AlertView
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"版本有更新"
                                                                message:[NSString stringWithFormat:@"检测到新版本(%@),是否更新?",dic[@"version"]]
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"更新",nil];
                [alert show];
                
            }else{
                NSLog(@"版本号好像比商店大噢!检测到不需要更新");
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}
#pragma mark === 新版launch广告图
/**
 新的launch图设置
 */
- (void)launchImage{
    //2.自定义配置初始化
    XHLaunchImageAdConfiguration *imageAdconfiguration = [XHLaunchImageAdConfiguration new];
    //广告停留时间
    imageAdconfiguration.duration = 3;
    //广告frame
    imageAdconfiguration.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    
    //网络图片缓存机制(只对网络图片有效)
    imageAdconfiguration.imageOption = XHLaunchAdImageCacheInBackground;//先缓存
    //图片填充模式
    imageAdconfiguration.contentMode = UIViewContentModeScaleToFill;
    
    //广告显示完成动画
    imageAdconfiguration.showFinishAnimate =ShowFinishAnimateFadein;
    //广告显示完成动画时间
    imageAdconfiguration.showFinishAnimateTime = 0.8;
    //跳过按钮类型
    imageAdconfiguration.skipButtonType = SkipTypeTimeText;
    //后台返回时,是否显示广告
    imageAdconfiguration.showEnterForeground = NO;
    [XHLaunchAd setWaitDataDuration:3];//请求广告URL前,必须设置,否则会先进入window的RootVC
    
    [DownLoadData postActivityScreen:^(id obj, NSError *error) {
        if(error){
            
        }else{
            NSString *picturePath = [NSString stringWithFormat:@"%@", obj[@"picturePath"]];
            if (picturePath == nil || [picturePath isEqualToString:@""]) {
                
                
            }else {
                [defaults setValue:obj[@"pictureName"] forKey:@"pictureName"];
                [defaults setValue:obj[@"pictureUrl"] forKey:@"pictureUrl"];
                //广告图片URLString/或本地图片名(.jpg/.gif请带上后缀)
                imageAdconfiguration.imageNameOrURLString = obj[@"picturePath"];
                //广告点击打开链接
                imageAdconfiguration.openURLString = obj[@"pictureUrl"];
                //显示图片开屏广告
                [XHLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
            }
        }
    }];
    
    //设置要添加的子视图(可选)
    //imageAdconfiguration.subViews = ...
    
}
#pragma mark ===新版 xhLaunchAd delegate方法

/**
 点击广告图事件
 */
- (void)xhLaunchAd:(XHLaunchAd *)launchAd clickAndOpenURLString:(NSString *)openURLString
{
    NSLog(@"点击了");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushtoad" object:nil userInfo:nil];
}

/**
 广告加载完事件
 */
- (void)xhLaunchShowFinish:(XHLaunchAd *)launchAd{
    
}
#pragma mark ==以上部分是启动广告图的设置
#pragma mark ==从通知栏进入app调用该方法
- (void)pushComingViewController
{
    self.leveyTabBarController.selectedIndex = 1;
}
#pragma mark ==分享设置
/**
 分享
 */
- (void)shareSdk{
    //分享
    [ShareSDK registerApp:@"17fdd00329c45"
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
                 
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"1427892513"
                                           appSecret:@"b7b7f1be2a24771ec4465b3c7bb91189"
                                         redirectUri:@"https://api.weibo.com/oauth2/default.html"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wxe288f2e30492370f"
                                       appSecret:@"c39195e79d9197ba6079a9f2892d8f87"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1105689249"
                                      appKey:@"VEd0bhzbY7KnrqYD"
                                    authType:SSDKAuthTypeBoth];
                 break;
                 
             default:
                 break;
         }
     }];
}
#pragma mark ==ios10本地通知
//收到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    NSLog(@"我收到了ios10本地通知=%@",userInfo);
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {//应用在前台
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"通知" message:@"您预约的标开启时间到了" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 101;
        [alert show];
        completionHandler(UNNotificationPresentationOptionSound);
    }
    else if([UIApplication sharedApplication].applicationState == UIApplicationStateInactive){//应用在后台，点通知进入
        self.leveyTabBarController.selectedIndex = 1;
        completionHandler(UNNotificationPresentationOptionAlert|UNNotificationPresentationOptionSound);
    }else{
        completionHandler(UNNotificationPresentationOptionAlert|UNNotificationPresentationOptionSound);
    }
    [center removeDeliveredNotificationsWithIdentifiers:@[notification.request.identifier]];
}
// 通知的点击事件 ios 10
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"iOS10 收到远程通知:");
        completionHandler(UNNotificationPresentationOptionAlert|UNNotificationPresentationOptionSound);
    }
    else
    {
        [self performSelector:@selector(pushComingViewController) withObject:nil afterDelay:2.0f];//要用延时方法跳转
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\\nbody:%@，\\ntitle:%@,\\nsubtitle:%@,\\nbadge：%@，\\nsound：%@，\\nuserInfo：%@\\n}",body,title,subtitle,badge,sound,userInfo);
        [center removeDeliveredNotificationsWithIdentifiers:@[response.notification.request.identifier]];
        // [center removeDeliveredNotificationsWithIdentifiers:<#(nonnull NSArray<NSString *> *)#>];
    }
    // 系统要求执行这个方法
    completionHandler();
}
#pragma mark ===ios10以下本地通知
/**
 收到本地推送以后处理事件，应用没被杀死
 */
- (void)application:(UIApplication *)application didReceiveLocalNotification:(nonnull UILocalNotification *)notification
{
    NSLog(@"我收到了本地通知");
    if (application.applicationState == UIApplicationStateActive) {//应用在前台
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"通知" message:@"您预约的标开启时间到了" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 100;
        [alert show];
    }
    else if(application.applicationState == UIApplicationStateInactive){//应用在后台，点通知进入
        self.leveyTabBarController.selectedIndex = 1;
    }
    //清除已经推送的消息
    [[UIApplication sharedApplication] cancelLocalNotification:notification];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100||alertView.tag == 101) {
        if (buttonIndex == 1) {//收到通知
            self.leveyTabBarController.selectedIndex = 1;
        }
    }
    else if (alertView.tag == 200) {
        if (buttonIndex == 0) {
            //强制更新
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@?ls=1&mt=8", STOREAPPID]];
            [[UIApplication sharedApplication] openURL:url];
        }
        
    }
    else if (alertView.tag == 201) {
        if (buttonIndex == 1) {
            //更新
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@?ls=1&mt=8", STOREAPPID]];
            [[UIApplication sharedApplication] openURL:url];
        }
        
    }
}
/**
 token
 */
- (void)appTocken{
    
    NSArray *ctrlArr = [XNFactory getTabNavArrWithTabNameArr:self.tabBarArray];
    
    _leveyTabBarController = [[LeveyTabBarController alloc] initWithViewControllers:ctrlArr];
    
    NSInteger state = [Factory checkNetwork];
    
    if (state) {
        [DownLoadData postappToken:^(id obj, NSError *error) {

                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                [user setValue:obj[@"token"] forKey:@"token"];
                [user synchronize];
                //检测App更新
                // [self updateApp];
                [self appUpDate];
            
            
                [self getTabImageArrWithTabNameArr:self.tabBarArray];
        } andMykey:TokenKey andUUID:_uuid];
    }else{
        
        NSMutableArray *arr = [NSMutableArray array];
        
        for (int i = 0; i < self.tabBarArray.count; i++)
        {
            NSString *imageName = self.tabBarArray[i];
            NSDictionary *imgDict = [XNFactory getTabImageDictForName:imageName];
            [arr addObject:imgDict];
        }
        
        self.tabBarArr = arr;
        
        [_leveyTabBarController initWithImgArr: self.tabBarArr];
        
    }
}
/**
 *  判断是否有活动
 */
- (void)judgeActivity {
    
    if (![NSStringFromClass([self.window.rootViewController class]) isEqualToString:@"GuidePageViewController"]) {
        
        
        [DownLoadData postActivityScreen:^(id obj, NSError *error) {
            if (error) {
                NSLog(@"错误码=%@",error.userInfo);
                if ([error.userInfo[@"NSLocalizedDescription"]isEqualToString:@"Request failed: not found (404)"]) {
                    UIImageView *image = [UIImageView new];
                    image.frame = CGRectMake(0, 0, kscreenWidth, kscreenHeight);
                    [image sd_setImageWithURL:[NSURL URLWithString:@"https://omfiq5ifs.qnssl.com/weihu.png"]];
                    [self.window.rootViewController.view addSubview:image];
                }
                return ;
            }
            //            _obj = obj;
            if (obj[@"picturePath"]) {
                
                //                // 1.判断沙盒中是否存在广告图片，如果存在，直接显示
                //                NSString *filePath = [self getFilePathWithImageName:[kUserDefaults valueForKey:adImageName]];
                [defaults setValue:obj[@"pictureName"] forKey:@"pictureName"];
                [defaults setValue:obj[@"pictureUrl"] forKey:@"pictureUrl"];
                //                BOOL isExist = [self isFileExistWithFilePath:filePath];
                // if (isExist) {// 图片存在
                
                AdvertiseView *advertiseView = [[AdvertiseView alloc] initWithFrame:self.window.bounds];
                advertiseView.filePath = obj[@"picturePath"];
                [advertiseView show];
                // }
                // 2.无论沙盒中是否存在广告图片，都需要重新调用广告接口，判断广告是否更新
                // [self getAdvertisingImage];
                
            }else {
                [self judgeProtectSafe];
            }
            
        }];
    }
}
///**
// *  判断文件是否存在
// */
//- (BOOL)isFileExistWithFilePath:(NSString *)filePath
//{
//
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    BOOL isDirectory = FALSE;
//    return [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
//}
//
///**
// *  初始化广告页面
// */
//- (void)getAdvertisingImage
//{
//    // TODO 请求广告接口
//
//    NSArray *imageArray = @[[NSString stringWithFormat:@"%@",_obj[@"picturePath"]]];
//    NSString *imageUrl = imageArray[arc4random() % imageArray.count];
//
//    // 获取图片名:43-130P5122Z60-50.jpg
//    NSArray *stringArr = [imageUrl componentsSeparatedByString:@"/"];
//    NSString *imageName = stringArr.lastObject;
//
//    // 拼接沙盒路径
//    NSString *filePath = [self getFilePathWithImageName:imageName];
//    BOOL isExist = [self isFileExistWithFilePath:filePath];
//    if (!isExist){// 如果该图片不存在，则删除老图片，下载新图片
//
//        [self downloadAdImageWithUrl:imageUrl imageName:imageName];
//    }
//}
//
///**
// *  下载新图片
// */
//- (void)downloadAdImageWithUrl:(NSString *)imageUrl imageName:(NSString *)imageName
//{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//
//        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
//        UIImage *image = [UIImage imageWithData:data];
//
//        NSString *filePath = [self getFilePathWithImageName:imageName]; // 保存文件的名称
//
//        if ([UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES]) {// 保存成功
//            NSLog(@"保存成功");
//            [self deleteOldImage];
//            [kUserDefaults setValue:imageName forKey:adImageName];
//            [kUserDefaults synchronize];
//            // 如果有广告链接，将广告链接也保存下来
//        }else{
//            NSLog(@"保存失败");
//        }
//
//    });
//}
//
///**
// *  删除旧图片
// */
//- (void)deleteOldImage
//{
//    NSString *imageName = [kUserDefaults valueForKey:adImageName];
//    if (imageName) {
//        NSString *filePath = [self getFilePathWithImageName:imageName];
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        [fileManager removeItemAtPath:filePath error:nil];
//    }
//}
//
///**
// *  根据图片名拼接文件路径
// */
//- (NSString *)getFilePathWithImageName:(NSString *)imageName
//{
//    if (imageName) {
//
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
//        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];
//
//        return filePath;
//    }
//
//    return nil;
//}

/**
 *  判断是否开启账号保护
 */
- (void)judgeProtectSafe {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([user objectForKey:@"userId"]) {
        NSMutableDictionary*dic = [[NSMutableDictionary alloc]init];
        [dic setValue:[user objectForKey:@"userId"] forKey:@"userId"];
        
        [DownLoadData postWithSystem:^(id obj, NSError *error) {
            if (![obj[@"messageCode"] isEqualToString:@"sys.error"]) {
                NSString *gestureLock = [NSString stringWithFormat:@"%@",obj[@"whetherPatternLock"]];
                
                if ([[user objectForKey:@"fingerSwitch"] isEqualToString:@"YES"]) {//指纹的状态不能存在服务器，所以从本地拿
                    
                    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
                    
                    [self.window.rootViewController.view addSubview:self.fingerView];
                    
                    
                    LAContext *clip = [[LAContext alloc] init];
                    NSError *hi = nil;
                    NSString *hihihihi = @"通过验证指纹解锁";
                    
                    //TouchID是否存在
                    if ([clip canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&hi]) {
                        
                        //TouchID开始运作
                        [clip evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:hihihihi reply:^(BOOL success, NSError *error)
                         {
                             if (success) {
                                 
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     
                                     //验证通过
                                     self.fingerView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
                                     
                                     CATransition *clip = [[CATransition alloc] init];
                                     clip.type = @"fade";
                                     clip.duration = 0.3;
                                     [self.fingerView.layer addAnimation:clip forKey:nil];
                                     
                                 });
                             }else {
                                 
                                 if (error.code == LAErrorUserFallback) {
                                     
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         
                                         //验证通过
                                         self.fingerView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
                                         
                                         CATransition *clip = [[CATransition alloc] init];
                                         clip.type = @"fade";
                                         clip.duration = 0.3;
                                         [self.fingerView.layer addAnimation:clip forKey:nil];
                                         
                                     });
                                     //退出登录操作
                                     NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                                     [user removeObjectForKey:@"result"];
                                     [user synchronize];
                                     [user removeObjectForKey:@"userId"];
                                     [user synchronize];
                                     [user removeObjectForKey:@"switchGesture"];
                                     [user removeObjectForKey:@"userIcon"];
                                     [user synchronize];
                                     [user removeObjectForKey:@"gesturePassword"];
                                     [user synchronize];
                                     [user removeObjectForKey:@"fingerSwitch"];
                                     [user synchronize];
                                     [user removeObjectForKey:@"gestureLock"];
                                     [user removeObjectForKey:@"sxyRealName"];
                                     UserDefaults(@"fail", @"sxyRealName");
                                     [user synchronize];
                                     
                                     
                                     [self.leveyTabBarController.tabBar tabBarButtonClickedWithTag:3];
                                     
                                     
                                 }
                                 
                             }
                         }];
                    }
                    
                }
                
                else if ([gestureLock isEqualToString:@"1"]) {
                    
                    //显示手势密码验证界面
                    [self.window.rootViewController.view addSubview:self.lockImageView];
                    
                    _lockTestView.clipTag = @"0";
                    
                }
                
            }
            
        } userId:dic andtag:0];
    }else{
        
    }
}

- (void)hideFinerViewAction {
    
    //验证通过
    self.fingerView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
}

- (void)hideGestureViewAction {
    
    self.lockImageView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
    
    CATransition *clip = [[CATransition alloc] init];
    clip.type = @"fade";
    clip.duration = 0.3;
    [self.lockImageView.layer addAnimation:clip forKey:nil];
}

- (FingerLockView *)fingerView {
    
    if (_fingerView == nil) {
        
        _fingerView = [[FingerLockView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        
        _fingerView.backgroundColor = [UIColor whiteColor];
    }
    
    return _fingerView;
}
- (UIImageView *)lockImageView {
    
    if (_lockImageView == nil) {
        
        _lockImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _lockImageView.userInteractionEnabled = YES;
        _lockImageView.image = [UIImage imageNamed:@"gestureLock"];
        _lockImageView.backgroundColor = [UIColor grayColor];
        
        _lockTestView = [[LockTestView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _lockTestView.backgroundColor = [UIColor clearColor];
        _lockTestView.clipTag = @"0";
        _lockTestView.accessTag = 2;
        [_lockImageView addSubview:_lockTestView];
    }
    
    return _lockImageView;
}

/**
 *  tabar
 */
- (void)inintBarDataSource{
    
    self.tabBarArray = @[kTab_Home,kTab_Wallet,KTab_Activity, kTab_Product];
}

/**
 *  引导页到主页
 */
- (void)qieHuan {

    self.window.rootViewController = self.leveyTabBarController;
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    [user setValue:@"YES" forKey:@"firstLogin"];
    [user synchronize];
}
#pragma mark 个推
//推送功能
- (void)startGePush
{
    //是否要启动推送
    NSUserDefaults *user = HCJFNSUser;
    NSString *start = [user objectForKey:@"systemNoti"];
    if (start && [start integerValue] == 1)
    {
        [self startSdkWith:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret];
        //[2]:注册APNS
        [self registerUserNotification];
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        
    }else if(start == nil){
        
        [self startSdkWith:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret];
        //[2]:注册APNS
        [self registerUserNotification];
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }else{
        
    }
}
/**
 *  注册APNS
 */
- (void)registerUserNotification{
    
    //#ifdef __IPHONE_8_0
    //    // 定义用户通知类型(Remote.远程 - Badge.标记 Alert.提示 Sound.声音)
    //    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
    //        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
    //        // 定义用户通知设置
    //        UIUserNotificationSettings *settings;
    //        settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    //        [[UIApplication sharedApplication] registerForRemoteNotifications];
    //        // 注册用户通知 - 根据用户通知设置
    //        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    //    } else {// iOS8.0 以前远程推送设置方式
    //        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge);
    //        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    //    }
    //#else
    //    UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert |
    //                                                                   UIRemoteNotificationTypeSound |
    //                                                                   UIRemoteNotificationTypeBadge);
    //    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    //#endif
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0 // Xcode 8编译会调用
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
            if (!error) {
                NSLog(@"request authorization succeeded!");
            }
        }];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
#else // Xcode 7编译会调用
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert |
                                                                       UIRemoteNotificationTypeSound |
                                                                       UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
    
}
////AppId、 appKey 、appSecret
- (void)startSdkWith:(NSString *)appID appKey:(NSString *)appKey appSecret:(NSString *)appSecret
{
    NSError *error = nil;
    //[1-1]:通过 AppId、 appKey 、appSecret 启动SDK
    [GeTuiSdk startSdkWithAppId:appID appKey:appKey appSecret:appSecret delegate:self];
    //设置是否后台运行开关
    [GeTuiSdk runBackgroundEnable:YES];
    //设置电子围栏功能，开启LBS地位服务和是否允许SDK 弹出用户定位请求
    // [GeTuiSdk lbsLocationEnable:YES andUserVerify:YES];
    if (error) {
        NSLog(@"推送失败%@",error);
    }
}
//SDK启动成功返回CID
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId
{
    //clientId存入本地
    NSUserDefaults *user = HCJFNSUser;
    [user setValue:clientId forKey:@"clientId"];
    [user synchronize];
    //个推SDK已注册，返回clientId
    NSLog(@"\n>>>[GeTuiSdk RegisterClient]:%@\n\n",clientId);
    if (_deviceToken) {
        
        [GeTuiSdk registerDeviceToken:_deviceToken];
        
    }
    
}
//SDK收到透传消息回调，在线则直接透传，离线则透过苹果APNs消息
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId
{
    //收到个推消息
    NSString *payloadMsg = nil;
    if (payloadData) {
        payloadMsg = [[NSString alloc]initWithBytes:payloadData.bytes length:payloadData.length encoding:NSUTF8StringEncoding];
    }
    NSString *msg = [NSString stringWithFormat:@"taskId = %@,messageId:%@,payloadMsg:%@%@",taskId,msgId,payloadMsg,offLine ? @"<离线消息>" : @""];
    NSLog(@"\n>>>[GexinSdk ReceivePayload]:%@\n\n",msg);
    NSString *record = [NSString stringWithFormat:@"%@",payloadMsg];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([record containsString:@"在另一台设备上登录"]) {
        
        if ([user objectForKey:@"userId"]) {
            
            [user removeObjectForKey:@"result"];
            [user synchronize];
            [user removeObjectForKey:@"userId"];
            [user synchronize];
            [user removeObjectForKey:@"switchGesture"];
            [user removeObjectForKey:@"userIcon"];
            [user synchronize];
            [user removeObjectForKey:@"gesturePassword"];
            [user synchronize];
            [user removeObjectForKey:@"fingerSwitch"];
            [user synchronize];
            [user removeObjectForKey:@"gestureLock"];
            [user synchronize];
            [user removeObjectForKey:@"userToken"];
            [user synchronize];
            
            //退出登录，需要注销网易七鱼
            [[QYSDK sharedSDK] logout:nil];
            
            if (self.leveyTabBarController.selectedIndex == 2) {
                
                UINavigationController *navi = [self.leveyTabBarController.viewControllers objectAtIndex:self.leveyTabBarController.selectedIndex];
                
                [navi popToRootViewControllerAnimated:YES];
                
                self.leveyTabBarController.selectedIndex = 0;
            }
            
            UINavigationController *navi = [self.leveyTabBarController.viewControllers objectAtIndex:self.leveyTabBarController.selectedIndex];
            
            [navi popToRootViewControllerAnimated:YES];
            
            UIViewController *vc = [navi.viewControllers lastObject];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:record preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                NewSignVC *signVC = [[NewSignVC alloc] init];
                
                signVC.presentTag = @"3";
                
                [vc presentViewController:signVC animated:YES completion:nil];
                
            }]];
            
            [vc presentViewController:alert animated:YES completion:nil];
            
        }
        
    }else {
        
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:record delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
    
    
    /**
     *
     */
    //[GeTuiSdk sendFeedbackMessage:90001 andTaskId:taskId andMsgId:msgId];
}
//远程通知注册成功委托
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    //网易七鱼把APNs Token传给SDK(目前不知道有什么用)
    [[QYSDK sharedSDK] updateApnsToken:deviceToken];
    NSLog(@"网易七鱼deviceToken %@",deviceToken);
    
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    _deviceToken = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"\n>>>[DeviceToken Success]:%@\n\n ",token);
    
    //向个推服务注册deviceToken
    [GeTuiSdk registerDeviceToken:_deviceToken];
}
//支持app后台刷新数据
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    // Background Fetch 恢复SDK 运行
    [GeTuiSdk resume];
    completionHandler(UIBackgroundFetchResultNewData);
}

//SDK遇到错误回调
- (void)GeTuiSdkDidOccurError:(NSError *)error
{
    //个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知
    NSLog(@"\n>>>[GexinSdk error]:%@\n\n",[error localizedDescription]);
}

//app已经接收到“远程”通知（推送） - 透传推送消息
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    
    //    // [4-EXT]:处理APN
    //    NSString *payloadMsg = [userInfo objectForKey:@"payload"];
    //
    //    NSDictionary *aps = [userInfo objectForKey:@"aps"];
    //    NSNumber *contentAvailable = aps == nil ? nil : [aps objectForKeyedSubscript:@"content-available"];
    
    [GeTuiSdk resume];
    
    //处理APNs代码，通过userInfo可以取到推送的信息（包括内容，角标，自定义参数等）。如果需要弹窗等其他操作，则需要自行编码。
    NSLog(@"\n>>>[Receive RemoteNotification - Background Fetch]:%@\n\n",userInfo);
    completionHandler(UIBackgroundFetchResultNewData);
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    //如果APNS注册失败，通知个推服务器
    [GeTuiSdk registerDeviceToken:@""];
    NSLog(@"44444+++++%@",error.description);
//    if (error.description) {
//        NSMutableArray *arr = [NSMutableArray array];
//        
//        for (int i = 0; i < self.tabBarArray.count; i++)
//        {
//            NSString *imageName = self.tabBarArray[i];
//            NSDictionary *imgDict = [XNFactory getTabImageDictForName:imageName];
//            [arr addObject:imgDict];
//        }
//        
//        self.tabBarArr = arr;
//        
//        [_leveyTabBarController initWithImgArr: self.tabBarArr];
//    }
}
- (void)setDeviceToken:(NSString *)aToken
{
    [GeTuiSdk registerDeviceToken:aToken];
}
//对用户设置具体别名，可以针对具体别名进行推送
- (void)bindAlias:(NSString *)aAlias {
    
    [GeTuiSdk bindAlias:aAlias andSequenceNum:aAlias];
}

- (void)unbindAlias:(NSString *)aAlias {
    
    [GeTuiSdk unbindAlias:aAlias andSequenceNum:aAlias];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    // [EXT] 重新上线
    NSUserDefaults *user = HCJFNSUser;
    NSString *start = [user objectForKey:@"systemNoti"];
    if (start&&[start integerValue] == 1){
        // [EXT] 重新上线
        [self startSdkWith:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret];
    }
    //通知进入app
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didBecomeActive" object:nil];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    
    if ([TencentOAuth HandleOpenURL:url]) {
        
        return [TencentOAuth HandleOpenURL:url];
        
    }else if ([WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]]) {
        
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
        
    }
    
    else {
        
        return [WeiboSDK handleOpenURL:url delegate:self];
        
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    //如果OpenShare能处理这个回调，就调用block中的方法，如果不能处理，就交给其他（比如支付宝）。
    if ([OpenShare handleOpenURL:url]) {
        return [TencentOAuth HandleOpenURL:url];
    }else if ([WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]]) {
        
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
        
    }else if ([WeiboSDK handleOpenURL:url delegate:self]) {
        
        return [WeiboSDK handleOpenURL:url delegate:self];
        
    }else {
        return [TencentOAuth HandleOpenURL:url];
    }
    
}

//微信第三方登录相关
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    if ([TencentOAuth HandleOpenURL:url]) {
        
        return [TencentOAuth HandleOpenURL:url];
    }else if ([WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]]) {
        
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
        
    }else {
        
        return [WeiboSDK handleOpenURL:url delegate:self];
        
    }
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    
    NSLog(@"%@",request);
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    
    NSLog(@"%@,%@,%li",response.userInfo,NSStringFromClass([response class]),response.statusCode);
    
    if ([response isKindOfClass:[WBAuthorizeResponse class]] && response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
        
        NSDictionary *dic = @{
                              @"uid" : response.userInfo[@"uid"],
                              @"access_token" : response.userInfo[@"access_token"]
                              };
        
        [WBHttpRequest requestWithURL:@"https://api.weibo.com/2/users/show.json" httpMethod:@"GET" params:dic delegate:self withTag:@"clip"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"weiboOpenId" object:nil userInfo:@{@"openId" : response.userInfo[@"uid"]}];
    }
    
}

- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result {
    
    NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    if (![user objectForKey:@"userIcon"]) {
        
        NSURL *url = [NSURL URLWithString:dic[@"avatar_large"]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        [user setValue:data forKey:@"userIcon"];
        [user synchronize];
        
    }
    
    [user setValue:@{@"type" : @"weibo",
                      @"nickname" : dic[@"name"]} forKey:@"thirdMessage"];
    [user synchronize];
}

//网易七鱼消息未读处理
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSInteger count = [[[QYSDK sharedSDK] conversationManager] allUnreadCount];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:count];
    
    UIApplication *app = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });
    //通知进入后台
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didEnterBackground" object:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
    //通知进入后台
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didEnterBackground" object:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
//强制使用系统键盘
- (BOOL)application:(UIApplication *)application

shouldAllowExtensionPointIdentifier:(NSString *)extensionPointIdentifier

{
    
    if ([extensionPointIdentifier isEqualToString:@"com.apple.keyboard-service"]) {
        
        return NO;
        
    }
    
    return YES;
    
}
@end
