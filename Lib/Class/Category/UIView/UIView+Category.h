//
//  UIView+Category.h
//  CityJinFu
//
//  Created by mic on 2018/1/4.
//  Copyright © 2018年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 加载在UIView上的手势点击事件
 */
typedef void(^TapBlock)();

@interface UIView (Category)

/**
 创建View 并添加手势点击事件

 @param subView 添加到的父类视图
 @param block 手势点击事件
 @return UIView对象
 */
+ (UIView *)viewAddSubView:(UIView *)subView tapBlock:(TapBlock)block;

@end
