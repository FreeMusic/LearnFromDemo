//
//  UIImageView+Category.m
//  CityJinFu
//
//  Created by mic on 2018/1/4.
//  Copyright © 2018年 yunfu. All rights reserved.
//

#import "UIImageView+Category.h"

const char UIImageViewTapKey;

@implementation UIImageView (Category)

+ (UIImageView *)image:(UIImage *)image subView:(UIView *)subView tapBlock:(UIImageViewTapBlock)block{
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [subView addSubview:imageView];
    if (block) {
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:imageView action:@selector(tapClick)];
        [imageView addGestureRecognizer:tap];
        objc_setAssociatedObject(imageView, &UIImageViewTapKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    
    return imageView;
}

- (void)tapClick{
    
    UIImageViewTapBlock block = objc_getAssociatedObject(self, &UIImageViewTapKey);
    
    if (block) {
        block(self);
    }
}

@end
