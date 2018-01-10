//
//  Factory.h
//  xiao2chedai
//
//  Created by mic on 16/4/25.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AFAppDotNetAPIClient.h"//token
#import "QYSessionViewController.h"

@protocol FactoryDelegate <NSObject>

/**
 * 当网络状态发生改变的时候触发， 前提是必须是添加网络状态监听
 */
- (void)netWorkStateChanged;

@end

@interface Factory : NSObject
@property (nonatomic, weak) id<FactoryDelegate>delegate;
//左边的按钮
+ (UIButton *)addLeftbottonToVC:(UIViewController *)vc;
//左边的按钮(灰色)
+ (UIButton *)addBlackLeftbottonToVC:(UIViewController *)vc;
//左边的按钮(透明度)
+ (UIButton *)addLeftbottonToVC:(UIViewController *)vc andAlpha:(CGFloat)alpha;
//有边框的按钮
+ (UIButton *)addButtonWithTextColorRed:(CGFloat)red Green:(CGFloat)green Blue:(CGFloat)blue andTitle:(NSString *)title addSubView:(UIView *)subView;
/**
 中间字体颜色的改变
 */
+ (void)NSMutableAttributedStringWithString:(NSString *)string andChangeColorString:(NSString *)str andLabel:(UILabel *)label;
/**
 中间字体颜色的改变
 */
+ (void)ChangeColorString:(NSString *)str andLabel:(UILabel *)label andColor:(UIColor *)color;
/**
 同一个label改变字体大小
 */
+ (void)ChangeSize:(NSString *)str andLabel:(UILabel *)label size:(CGFloat)size;
/**
 同一个label改变字体大小  和  颜色
 */
+ (void)ChangeSizeAndColor:(NSString *)str otherStr:(NSString *)otherStr andLabel:(UILabel *)label size:(CGFloat)size color:(UIColor *)color;
/**
 中间字体颜色的改变(因为有可能会有一个lable中改变多处字体大小)
 */
+ (void)ChangeColorStringArray:(NSArray *)array andLabel:(UILabel *)label andColor:(UIColor *)color;
/**
 同一个label改变字体大小(可自定义改变字体大小)
 */
+ (NSMutableAttributedString *)MutableString:(NSString *)string andLeftRange:(NSRange)leftrange leftFont:(CGFloat)leftFont;
//左边的按钮(灰色)
+ (UIButton *)addBlackLeftbottonToVC:(UIViewController *)vc WithImgName:(NSString *)name;
//侧滑按钮
+ (UIButton *)addLeftbottonWithCeHuaToVC:(UIViewController *)vc andImageName:(NSString *)ImageName;
//右边的按钮
+ (UIButton *)addRightbottonToVC:(UIViewController *)vc andrightStr:(NSString *)rightStr;
//右边的按钮(靠右)
+ (UIButton *)addRightbottonToVC:(UIViewController *)vc andNextToRightStr:(NSString *)rightStr;
//右边图片按钮
+ (UIButton *)addRightbottonToVC:(UIViewController *)vc;
//右边图片按钮
+ (UIButton *)addRightbottonToVC:(UIViewController *)vc andImageName:(NSString *)ImageName;
//长条文字按钮
+ (UIButton *)addCenterButtonWithTitle:(NSString *)title andTitleColor:(CGFloat)textColor andButtonbackGroundColorRed:(CGFloat)red Green:(CGFloat)green Blue:(CGFloat)blue andCornerRadius:(CGFloat)radius addSubView:(UIView *)subView;
//长条文字按钮
+ (UIButton *)addCenterButtonWithTitle:(NSString *)title andTitleColor:(UIColor *)textColor andButtonBackGroundColor:(UIColor *)buttonBackGroundColor andCornerRadius:(CGFloat)radius addSubView:(UIView *)subView;
//背景图片的封装
+ (UIImageView *)imageView:(NSString *)imageName;
//带逗号的金额处理
+ (NSString *)exchangeStrWithNumber:(NSNumber *)number;
+ (NSString *)countNumAndChangeformat:(NSString *)num;
+ (NSString *)countNumAndChange:(NSString *)num;
//判断手机号码格式是否正确
+ (BOOL)valiMobile:(NSString *)mobile;
//时间戳转换日期
+ (NSString *)translateDateWithStr:(NSString *)dateStr;
//时间戳转换年月日
+ (NSString *)translateYearDateWithStr:(NSString *)dateStr;
//时间戳转换年月日时分秒
+ (NSString *)transClipDateWithStr:(NSString *)dateStr;
//时间戳转换周
+ (NSString *)translateWeekDayWithStr:(NSString *)dateStr;
//时间
+ (NSString *)stdTimeyyyyMMddFromNumer:(NSNumber *)num andtag:(NSInteger)tag;
//百分号的处理
+ (NSMutableAttributedString *)attributedString:(NSString *)initWithString andRangL:(NSRange)range andlabel:(UILabel *)label andtag:(NSInteger)tag;
//添加暂无数据图片
+ (void)addNoDataToView:(UIViewController*)View;

+ (void)showFasHud;
+ (void)showNoDataHud;
/**
 *  监测网络
 */
+ (NSInteger)checkNetwork;
//封装简易的alert（title提示，确定 无跳转）
+ (void)addAlertToVC:(UIViewController *)vc withMessage:(NSString *)message;
//自定义alter
+ (void)addAlertToVC:(UIViewController *)vc withMessage:(NSString *)message title:(NSString *)title;
//隐藏tabar
+ (void)hidentabar;
//显示tabar
+ (void)showTabar;
//导航的处理
+ (void)navgation:(UIViewController *)viewController;
/**
 token
 */
+ (AFAppDotNetAPIClient *)userToken;//登录token
+ (AFAppDotNetAPIClient *)accessToken;//普通token
/**
 *  网易七鱼
 */
+ (QYSessionViewController *)jumpToQY;
/**
 提示框
 */
+ (void)alertMes:(NSString *)mes;
/**
 app版本检测
 */
+ (void)updateApp:(UIViewController *)VC;
/**
 app版本显示
 */
+ (UILabel *)version:(NSString *)version;
/**
 我的总资产、待收金额、累计收益
 */
+ (UILabel *)myTypeLab:(NSString *)text;
/**
 生成Label，字体为灰色
 */
+ (UILabel *)CreateLabelWithTextColor:(CGFloat)color andTextFont:(CGFloat)font andText:(NSString *)text addSubView:(UIView *)view;
/**
 生成Label，字体为彩色
 */
+ (UILabel *)CreateLabelWithTextRedColor:(CGFloat)red GreenColor:(CGFloat)green BlueColor:(CGFloat)blue andTextFont:(CGFloat)font andText:(NSString *)text addSubView:(UIView *)view;
/**
 生成Label，颜色自定义
 */
+ (UILabel *)CreateLabelWithColor:(UIColor *)color andTextFont:(CGFloat)font andText:(NSString *)text addSubView:(UIView *)view;
/**
 获取某年某个月 该月有多少天
 */
+ (NSInteger)howManyDaysInThisYear:(NSInteger)year withMonth:(NSInteger)month;
/**
 获得时间期限单位
 */
+ (NSString *)dataUnitByItemCycleUnit:(NSNumber *)cycleunit;
/**
 客户电话
 */
+ (void)resgisterInViewController:(UIViewController *)vc;
/**
 *取消html中的标签
 */
+(NSString *)flattenHTML:(NSString *)html;
/**
 *获取未登录时候个人中心页面的头部背景图
 */
+(UIImageView *)getPersonHeaderView;
//校验身份证号
+ (BOOL)CheckIsIdentityCard: (NSString *)identityCard;
/**
 *银行卡正则校验
 */
+ (BOOL) IsBankCard:(NSString *)cardNumber;
//右边的按钮
+ (UIButton *)addRightbottonToVC:(UIViewController *)vc andrightStr:(NSString *)rightStr andTextColor:(UIColor *)color;
//颜色转图片 
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
//删掉字符串最后一个字符
+(NSString*) removeLastOneChar:(NSString*)origin;
//输入交易金额 带小数点数字处理
+ (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
//将小数点后的最后一位小数舍掉的方法
+ (NSString *)stringByNotRounding:(double)price afterPoint:(int)position;
/**
 *  6.判断一个月有多少天
 *
 *  @param date 日期
 *
 *  @return
 */
+(NSInteger)NSStringIntTeger:(NSInteger)teger andYear:(NSInteger)year;
/**
 * 因为在项目中要遇到一些后台返回的字符串或者其他空值 要做特殊处理 校验这个值是否为空
 */
+ (BOOL)theidTypeIsNull:(id)type;
/**
 *改变行间距
 */
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space;
/**
 *创建Button  带有点击事件
 */
+ (UIButton *)ButtonWithTitle:(NSString *)title andTitleColor:(UIColor *)textColor andButtonbackGroundColor:(UIColor *)buttonBackGroundColor andCornerRadius:(CGFloat)radius addTarget:(UIViewController *)viewController action:(NSString *)action;
/**
 *创建Button  带有点击事件 带subView
 */
+ (UIButton *)ButtonWithTitle:(NSString *)title andTitleColor:(UIColor *)textColor andButtonbackGroundColor:(UIColor *)buttonBackGroundColor andCornerRadius:(CGFloat)radius addTarget:(UIViewController *)viewController action:(NSString *)action addSubView:(UIView *)subView;

+ (UIImage *)navgationImage;
@end
