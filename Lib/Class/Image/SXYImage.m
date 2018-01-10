//
//  SXYImage.m
//  CityJinFu
//
//  Created by mic on 2017/12/19.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "SXYImage.h"
#import <objc/runtime.h>

//iPhoneX的高度
static CGFloat iPhoneXHeight = 812;

@implementation SXYImage
///**
// *   在引导页中或其他页面中 因为图片是全屏的 为了适配iPhone X 和 其他手机 利用runtime 实现方法互换 达到切换图片的功能
// */
//+ (UIImage *)SXY_imageNamed:(NSString *)imageName{
//
//    if (kScreenHeight == iPhoneXHeight) {
//        imageName = [NSString stringWithFormat:@"%@_iPhoneX", imageName];
//    }
//
//    return [SXYImage SXY_imageNamed:imageName];
//}

+ (UIImage *)imageNamed:(NSString *)name{
    if (kScreenHeight == iPhoneXHeight) {
        name = [NSString stringWithFormat:@"%@_iPhoneX", name];
    }
    return [UIImage imageNamed:name];
}

//+ (void)load{
//    //找到系统的方法
//    Method sysMethod = class_getClassMethod([SXYImage class], @selector(imageNamed:));
//    //找到要替换系统的方法
//    Method sxyMethod = class_getClassMethod([SXYImage class], @selector(SXY_imageNamed:));
//    //runtime实现方法的交换
//    method_exchangeImplementations(sysMethod, sxyMethod);
//
//}

@end
