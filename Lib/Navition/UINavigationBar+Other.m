//
//  UINavigationBar+Other.m
//  CityJinFu
//
//  Created by 姜姜敏 on 16/9/12.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "UINavigationBar+Other.h"
#import <objc/runtime.h>


@implementation UINavigationBar (Other)

static const char alView;

/**
 *  set方法
 */
-(void)setAlphaView:(UIView *)alphaView{
    objc_setAssociatedObject(self, &alView, alphaView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
/**
 *  get方法
 */
-(UIView *)alphaView{
    return objc_getAssociatedObject(self, &alView);
}

- (void)setColor:(UIColor *)color {
    
    if (!self.alphaView) {
        //设置背景图片
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        //创建
        self.alphaView = [[UIView alloc ]initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, 64)];
        //插入到navigationbar
        
        [self insertSubview:self.alphaView atIndex:0];
        
    }
    
    [self.alphaView setBackgroundColor:color];
    
    //    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, - 20, self.bounds.size.width, 64)];
    //    view.backgroundColor = color;
    //
    //    [self setValue:view forKey:@"backgroundView"];
    
}

@end
