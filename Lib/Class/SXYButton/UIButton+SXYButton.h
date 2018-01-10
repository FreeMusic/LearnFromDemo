//
//  UIButton+SXYButton.h
//  CityJinFu
//
//  Created by mic on 2017/8/14.
//  Copyright © 2017年 yunfu. All rights reserved.
//
/**
 *  为Button添加一个分类 目的是为了防止按钮的重复点击
 */

#import <UIKit/UIKit.h>

@interface UIButton (SXYButton)

/**
 *  为按钮添加点击间隔 eventTimeInterval秒
 */
@property (nonatomic, assign) NSTimeInterval eventTimeInterval;

@end
