//
//  UINavigationBar+Other.h
//  CityJinFu
//
//  Created by 姜姜敏 on 16/9/12.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (Other)

/**
 *  自定义导航栏上的view
 */
@property (nonatomic,strong) UIView * alphaView;

/**
 *  给外界一个方法，来改变颜色
 */
//-(void)alphaNavigationBarView:(UIColor *)color;

- (void)setColor:(UIColor *)color;

@end
