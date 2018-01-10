//
//  ColorSize.h
//  CityJinFu
//
//  Created by xxlc on 16/8/8.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#ifndef ColorSize_h
#define ColorSize_h

//DEBUG  模式下打印日志,当前行 并弹出一个警告
#ifdef DEBUG
#   define ULog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }
#else
#   define ULog(...)
#endif

/**
 *  屏幕尺寸宽和高
 */
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
/**
 *  比例系数适配
 */
#define m6PScale              kScreenWidth/1242.0
#define m6Scale               kScreenWidth/750.0
#define m5Scale               kScreenWidth/640.0

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

//电池栏
#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
//导航栏
#define kNavBarHeight 44.0
//tabbar高度
#define kTabBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)
//导航+电池栏
#define NavigationBarHeight (kStatusBarHeight + kNavBarHeight)
//安全区底部高度
#define KSafeBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?34.0:0)

/**
 *  导航栏颜色
 */
#define navigationColor [UIColor whiteColor]//
#define navigationYellowColor [UIColor colorWithRed:253.0 / 255.0 green:182.0 / 255.0 blue:21.0/255.0 alpha:1.0]
/**
 *  背景颜色
 */
#define backGroundColor [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0/255.0 alpha:1.0]
/**
 *  button颜色
 */
#define buttonColor [UIColor colorWithRed:234.0 / 255.0 green:108.0 / 255.0 blue:47.0/255.0 alpha:1.0]
/**
 *  button颜色
 */
#define ButtonColor [UIColor colorWithRed:253.0 / 255.0 green:182.0 / 255.0 blue:21.0/255.0 alpha:1.0]
/**
 *  字体的颜色
 */
#define titleColor [UIColor colorWithRed:165.0 / 255.0 green:165.0 / 255.0 blue:165.0/255.0 alpha:1.0]
/**
 *  输入框阴影字体的颜色
 */
#define Placeholder [UIColor colorWithRed:255.0 / 255.0 green:255.0 / 255.0 blue:255.0/255.0 alpha:0.8]
/**
 *  红包字体颜色
 */
#define RedColor [UIColor colorWithRed:252.0 / 255.0 green:249.0 / 255.0 blue:249.0/255.0 alpha:1.0]
/**
 *  资产明细
 */
#define IncomColor [UIColor colorWithRed:69.0 / 255.0 green:69.0 / 255.0 blue:69.0/255.0 alpha:1.0]
/**
 *  自定义彩色颜色
 */
#define Colorful(Red,Green,Blue) [UIColor colorWithRed:Red / 255.0 green:Green / 255.0 blue:Blue/255.0 alpha:1.0]
/**
 收益金额颜色
 */
#define Income [UIColor colorWithRed:246 / 255.0 green:143 / 255.0 blue:143 / 255.0 alpha:1]
/**
 登录、注册、找回密码的文本颜色
 */
#define textFieldColor [UIColor colorWithRed:100.0 / 255.0 green:58.0 / 255.0 blue:24.0/255.0 alpha:1.0]//待收利息
/**
 *  弹出框分割线颜色
 */
#define TitleViewBackgroundColor [UIColor whiteColor]
#define LineColor [UIColor colorWithWhite:0.0 alpha:0.05]
/**
 tableview分割线的颜色
 */
#define SeparatorColor [UIColor colorWithRed:227 / 255.0 green:226 / 255.0 blue:226 / 255.0 alpha:1]
//黑色
#define BlackColor [UIColor colorWithWhite:0.0 alpha:0.8]
/**
 *  token
 */
#define TokenKey @"NWE2NTg4YzQtZTVmNy00NWVmLTlkOTAtMmJkYjhiNWIwY2Jl"

/**
 信息动态
 */
#define uRL @"http://mp.weixin.qq.com/mp/homepage?__biz=MzAwNTY5ODA3OA==&hid=1&sn=42aeea95a4a71a6debe2aa7e4eeae8b2#wechat_redirect"
/**
 监测系统版本
 */
#define iOS9 ([[UIDevice currentDevice].systemVersion intValue]>=9?YES:NO)
#define iOS10 ([[UIDevice currentDevice].systemVersion intValue]>=10?YES:NO)
#define iOS11 ([[UIDevice currentDevice].systemVersion intValue]>=11?YES:NO)

//存储到本地
#define UserDefaults(Object, Key)\
[[NSUserDefaults standardUserDefaults] setValue:Object forKey:Key];\

#define defaults [NSUserDefaults standardUserDefaults]

#endif /* ColorSize_h */
