//
//  UILabel+Category.m
//  CityJinFu
//
//  Created by mic on 2018/1/4.
//  Copyright © 2018年 yunfu. All rights reserved.
//

#import "UILabel+Category.h"

const char UILabelTapKey;

@implementation UILabel (Category)

+ (UILabel *)labelWithTextColor:(UIColor *)color andTextFont:(CGFloat)font andText:(NSString *)text addSubView:(UIView *)view tapBlock:(tapBlock)block{
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:font*m6Scale];
    label.text = text;
    [view addSubview:label];
    
    if (block) {
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:label action:@selector(tapAction)];
        [label addGestureRecognizer:tap];
        objc_setAssociatedObject(label, &UILabelTapKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    
    return label;
}

- (void)tapAction{
    
    tapBlock block = objc_getAssociatedObject(self, &UILabelTapKey);
    
    if (block) {
        block(self);
    }
    
}

@end
