//
//  UIView+Category.m
//  CityJinFu
//
//  Created by mic on 2018/1/4.
//  Copyright © 2018年 yunfu. All rights reserved.
//

#import "UIView+Category.h"
#import <objc/runtime.h>

const char tapKey;

@implementation UIView (Category)


+ (UIView *)viewAddSubView:(UIView *)subView tapBlock:(TapBlock)block{
    
    UIView *view = [[UIView alloc] init];
    [subView addSubview:view];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:view action:@selector(tapClick:)];
    [view addGestureRecognizer:tap];
    
    if (block) {
        objc_setAssociatedObject(view, &tapKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    
    return view;
}

- (void)tapClick:(UIView *)view{
    
    TapBlock block = objc_getAssociatedObject(view, &tapKey);
    
    if (block) {
        block();
    }
    
}

@end
