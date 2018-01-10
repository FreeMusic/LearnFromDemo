//
//  TitleLabelStyle.m
//  xiao2chedai
//
//  Created by xxlc on 16/4/25.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "TitleLabelStyle.h"

@implementation TitleLabelStyle
//白色字体
- (void)titleLabel:(NSString *)str color:(UIColor *)color
{
    //自定义标题视图
    self.font = [UIFont systemFontOfSize:35 * m6Scale];
    self.textColor = color;
    self.textAlignment = NSTextAlignmentCenter;
    self.text = str;
}
//添加titleView
+ (void)addtitleViewToVC:(UIViewController *)vc withTitle:(NSString *)title
{
    TitleLabelStyle *titleLabel = [[TitleLabelStyle alloc]initWithFrame:CGRectMake(0, 0, 120, 44)];
    [titleLabel titleLabel:title color:[UIColor blackColor]];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    vc.navigationItem.titleView = titleLabel;
}
//添加titleView（灰色字体）
+ (void)addtitleViewToVC:(UIViewController *)vc withTitle:(NSString *)title andTextColor:(CGFloat)color{
    TitleLabelStyle *titleLabel = [[TitleLabelStyle alloc]initWithFrame:CGRectMake(0, 0, 120, 44)];
    //自定义标题视图
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textColor = [UIColor colorWithWhite:color alpha:1];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    vc.navigationItem.titleView = titleLabel;
}

+ (void)addtitleViewToMyVC:(UIViewController *)vc withTitle:(NSString *)title{
    TitleLabelStyle *titleLabel = [[TitleLabelStyle alloc]initWithFrame:CGRectMake(0, 0, 120, 44)];
    titleLabel.text = title;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    vc.navigationItem.titleView = titleLabel;
}

+ (void)addtitleViewToVC:(UIViewController *)vc withTitle:(NSString *)title color:(UIColor *)color {
    
    
    TitleLabelStyle *titleLabel = [[TitleLabelStyle alloc]initWithFrame:CGRectMake(0, 0, 120, 44)];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [titleLabel titleLabel:title color:color];
    vc.navigationItem.titleView = titleLabel;
    
}

@end
