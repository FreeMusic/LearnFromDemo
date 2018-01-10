//
//  UIImageView+Category.h
//  CityJinFu
//
//  Created by mic on 2018/1/4.
//  Copyright © 2018年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 加载在UIImageView上的手势点击事件
 */
typedef void(^UIImageViewTapBlock)(UIImageView *imageView);

@interface UIImageView (Category)

+ (UIImageView *)image:(UIImage *)image subView:(UIView *)subView tapBlock:(UIImageViewTapBlock)block;

@end
