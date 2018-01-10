//
//  UIButton+Category.h
//  CityJinFu
//
//  Created by mic on 2017/12/12.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>
//枚举有线框  无线框的按钮
typedef NS_ENUM(NSUInteger, ButtonShapeType){
    ButtonShapeTypeWithLine,//有边线的按钮
    ButtonShapeTypeWithSolid//无边线 的按钮
};
//枚举 按钮 能够点击  半透明状态不能点击 灰色状态不能点击 三种状态 (适用于监听输入框的值 来确定按钮是否能点击)
typedef NS_ENUM(NSUInteger, ButtonWhetherClick){
    ButtonCanClick,
    ButtonCanNotClickWithHalfAlpha,
    ButtonCanNotClickWithGray
};
//按钮的点击事件 block
typedef void(^ButtonActionBlock)(UIButton *button);

@interface UIButton (Category)

@property (nonatomic, assign) ButtonShapeType buttonShapeType;

@property (nonatomic, assign) ButtonWhetherClick buttonWhetherClick;
/**
 *  适用于 有背景颜色 有圆角 的按钮 点击事件可以在block回调中处理
 */
+ (UIButton *)ButtonWithTitle:(NSString *)title TitleColor:(UIColor *)textColor ButtonbackGroundColor:(UIColor *)buttonBackGroundColor CornerRadius:(CGFloat)radius addSubView:(UIView *)subView buttonActionBlock:(ButtonActionBlock)buttonActionBlock;
/**
 *  适用于 背景图的Button
 */
+ (UIButton *)ButtonWithImageName:(NSString *)imageName addSubView:(UIView *)subView buttonActionBlock:(ButtonActionBlock)buttonActionBlock;

@end
