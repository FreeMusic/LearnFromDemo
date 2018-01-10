//
//  CityJinFuAPI.h
//  CityJinFu
//
//  Created by xxlc on 16/8/8.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#ifndef CityJinFuAPI_h
#define CityJinFuAPI_h

#import "DM_Tabbar_Head.h"
#import "XNFactory.h"
#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS
#import "Masonry.h"
#import "TitleLabelStyle.h"
#import "AppDelegate.h"
#import "CustomTextField.h"
#import "MBProgressHUD.h"
#import "GYZCommon.h"
#import "GYZActionSheet.h"
#import "MJRefresh.h"
#import "QYSDK.h"
//弹出框
#import "XFMaskView.h"
#import "XFDialogFrame.h"
#import "XFDialogNotice.h"
#import "UINavigationBar+Other.h"

#import "APNumberPad.h"
//网络
#import "Reachability.h"
#import "SVProgressHUD.h"
#import "DownLoadData.h"
#import "AFNetworking.h"
#import "TimeOut.h"//倒计时
#import "TimerRandom.h"//验证码
#import "UIImageView+WebCache.h"//引入webimage
#define HCJF @"HCJF"//标记
#import "KeyBoard.h"//键盘
#import "HCJFTextField.h"//输入框
#import "VerCodeBtn.h"//验证码按钮
#import "SubmitBtn.h"//页面的提交
#import "OpenShareHeader.h"
#import "UINavigationBar+Awesome.h"//修复导航问题
#import "UIViewController+BackButtonHandler.h"//修复导航问题
#import "AchieveVC.h"
#import "TalkingData.h"//统计
#import "openShareView.h"
#import <JavaScriptCore/JavaScriptCore.h>//和H5交互
#import "UIView+MTExtension.h"
#import "AppDelegate.h"
#import "SXYButton.h"
#import "UIButton+Category.h"
#import "NSArray+ErrorHandle.h"
#import "NSMutableArray+ErrorHandle.h"
#import "UIView+Category.h"
#import "UILabel+Category.h"
#import "UIImageView+Category.h"
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif
#define APPId @"I004274209"//云捕的key值
//个推key值
#define kGtAppId             @"LgnbeyxdsE8Hzynh3pCMY3"
#define kGtAppKey            @"B3dVdD7A036pPJt02iKSI"
#define kGtAppSecret         @"NsMl4e4aOw9yYWD5M9i1u"

#define TakingAppId @"3A14FDE810144891B525480CA17FA369"//TakingData统计
#define WYAppId @"cb83fc6792a4c8f3a2387d3a94f6abfe"//网易七鱼SDK
#define HCJFNSUser [NSUserDefaults standardUserDefaults]
//网络繁忙
#define Message @"网络繁忙!"
//温馨提示
#define TitleMes @"温馨提示"
//1一定要先配置自己项目在商店的APPID
#define STOREAPPID @"1160680698"//1172155942 1160680698

//加密键盘的liscence 1正式   0测试
#if 1
#define KeyboardKey @"UnRoNEZadzJEUmNMZVI0Ty8vZ0JoZWpodnErWnpXZmQyOEJDRi9SSmRiMGd0bHdqUURTdkwrNi9OS3hjQ29qRVBFOHpMa1RoKzlHSksrQldhc1VTNk8wVndLemJkSXBpSU9peUdEeWRuclQyR1B4dnlXdFU3SjYrYUM3WEp4eXBtemZaWFJaNmc0cmRXcHhPNGY3dzU4OVZMa1BpQTYrNTRRY3IwR0dyZzZVPXsiaWQiOjAsInR5cGUiOiJwcm9kdWN0IiwicGFja2FnZSI6WyJjb20ueXVuZnVjbG91ZC5IQ0pGIl0sImFwcGx5bmFtZSI6WyLmsYfor5rph5HmnI0iXSwicGxhdGZvcm0iOjF9"
#else
#define KeyboardKey @"SytZNXZhRnNSSkxMWnhzVU9OMTZTUGFFUWlOdlZKRXllbG1oVk5rSTcyOVN6dUJRVTZLUTJjeUdZeWhpN1BZYlBaU3FYWjhIaW9mMlVwQUFEMFRXUnF4d2JwMzFPRlEvMmZzM2N0MTlYckJUTWkveUhUdlM2K3VnS3duVGVhaGJ4SUNsbDZCcC8rc0pBU3Y1Vit2KzljMjBOZzFKMG9ZOXc2QlNnWG84L2FZPXsiaWQiOjAsInR5cGUiOiJ0ZXN0IiwicGxhdGZvcm0iOjEsIm5vdGJlZm9yZSI6IjIwMTcwNzE5Iiwibm90YWZ0ZXIiOiIyMDE3MTAxOSJ9"
#endif
//扫描身份证用到的AppKey
#define ScanIdAPPKey @"VdB1gDXNPJh6VHbCdU5hbfT1"
//芝麻信用 人脸识别 商户ID
#define MerchantID @"268820000130296912762"

#endif /* CityJinFuAPI_h */
