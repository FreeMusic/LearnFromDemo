//
//  UIButton+Category.m
//  CityJinFu
//
//  Created by mic on 2017/12/12.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "UIButton+Category.h"
#import <objc/runtime.h>

@implementation UIButton (Category)
//runtime用键取值 此处定义一个键  键的类型随意 int 什么都可以  但是char类型占用内存最小
static char buttonActionKey;

- (void)setButtonShapeType:(ButtonShapeType)buttonShapeType{
    objc_setAssociatedObject(self, @selector(buttonShapeType), @(buttonShapeType), OBJC_ASSOCIATION_ASSIGN);
    if (buttonShapeType == ButtonShapeTypeWithLine) {
        self.layer.borderWidth = 1;
        self.layer.borderColor = navigationYellowColor.CGColor;
        self.backgroundColor = [UIColor whiteColor];
        [self setTitleColor:navigationYellowColor forState:0];
    }else if(buttonShapeType == ButtonShapeTypeWithSolid){
        self.backgroundColor = navigationYellowColor;
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

- (ButtonShapeType)buttonShapeType{
    
    NSNumber *value = objc_getAssociatedObject(self, @selector(buttonShapeType));
    
    return value.intValue;
}

- (void)setButtonWhetherClick:(ButtonWhetherClick)buttonWhetherClick{
    objc_setAssociatedObject(self, @selector(buttonWhetherClick), @(buttonWhetherClick), OBJC_ASSOCIATION_ASSIGN);
    
    switch (buttonWhetherClick) {
        case ButtonCanClick:{
            self.backgroundColor = navigationYellowColor;
            self.userInteractionEnabled = YES;
        }
            break;
        case ButtonCanNotClickWithGray:{
            self.backgroundColor = UIColorFromRGB(0xdbdbdb);
            self.userInteractionEnabled = NO;
        }
            break;
        case ButtonCanNotClickWithHalfAlpha:{
            self.backgroundColor = UIColorFromRGB(0xffd67e);
            self.userInteractionEnabled = NO;
        }
            break;
            
        default:
            break;
    }
}

- (ButtonWhetherClick)buttonWhetherClick{
    
    NSNumber *value = objc_getAssociatedObject(self, @selector(buttonWhetherClick));
    
    return value.intValue;
}
/**
 *  适用于 有背景颜色 有圆角 的按钮 点击事件可以在block回调中处理
 */
+ (UIButton *)ButtonWithTitle:(NSString *)title TitleColor:(UIColor *)textColor ButtonbackGroundColor:(UIColor *)buttonBackGroundColor CornerRadius:(CGFloat)radius addSubView:(UIView *)subView buttonActionBlock:(ButtonActionBlock)buttonActionBlock{
    UIButton *btn = [UIButton buttonWithType:0];
    [btn setTitle:title forState:0];
    [btn setTitleColor:textColor forState:0];
    btn.backgroundColor = buttonBackGroundColor;
    btn.layer.cornerRadius = radius*m6Scale;
    [btn addTarget:btn action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    //最关键的 步骤  block 既可以作为参数 又可以 作为方法  此处将block作为参数  动态绑定到 button上
    objc_setAssociatedObject(btn, &buttonActionKey, buttonActionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [subView addSubview:btn];
    
    return btn;
}
/**
 *  适用于 背景图的Button
 */
+ (UIButton *)ButtonWithImageName:(NSString *)imageName addSubView:(UIView *)subView buttonActionBlock:(ButtonActionBlock)buttonActionBlock{
    UIButton *btn = [UIButton buttonWithType:0];
    [btn setImage:[UIImage imageNamed:imageName] forState:0];
    [btn addTarget:btn action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    //最关键的 步骤  block 既可以作为参数 又可以 作为方法  此处将block作为参数  动态绑定到 button上
    objc_setAssociatedObject(btn, &buttonActionKey, buttonActionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [subView addSubview:btn];
    
    return btn;
}
/**
 *  button的点击事件
 */
- (void)buttonClick:(UIButton *)sender{
    
    //再用的时候 需要用runtime把button 上的block取出来 执行绑定在button上的block
    ButtonActionBlock block = objc_getAssociatedObject(sender, &buttonActionKey);
    
    if (block) {
        block(sender);
    }
}
@end
