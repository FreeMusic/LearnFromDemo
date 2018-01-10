//
//  TitleLabelStyle.h
//  xiao2chedai
//
//  Created by xxlc on 16/4/25.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleLabelStyle : UILabel
- (void)titleLabel:(NSString *)str color:(UIColor *)color;//白色字体
//添加titleView（灰色字体）
+ (void)addtitleViewToVC:(UIViewController *)vc withTitle:(NSString *)title andTextColor:(CGFloat)color;
+ (void)addtitleViewToVC:(UIViewController *)vc withTitle:(NSString *)title;//添加titleView
+ (void)addtitleViewToMyVC:(UIViewController *)vc withTitle:(NSString *)title;//添加titleView
+ (void)addtitleViewToVC:(UIViewController *)vc withTitle:(NSString *)title color:(UIColor *)color;//添加titleView
@end
