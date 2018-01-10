//
//  UILabel+Category.h
//  CityJinFu
//
//  Created by mic on 2018/1/4.
//  Copyright © 2018年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 加载在UILabel上的手势点击事件
 */
typedef void(^tapBlock)(UILabel *label);

@interface UILabel (Category)

+ (UILabel *)labelWithTextColor:(UIColor *)color andTextFont:(CGFloat)font andText:(NSString *)text addSubView:(UIView *)view tapBlock:(tapBlock)block;

@end
