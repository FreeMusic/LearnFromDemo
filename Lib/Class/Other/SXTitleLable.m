//
//  SXTitleLable.m
//  
//
//  Created by 董 尚先 on 15-1-31.
//  Copyright (c) 2015年 shangxianDante. All rights reserved.
//

#import "SXTitleLable.h"

@implementation SXTitleLable

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont systemFontOfSize:40*m6Scale];
        
        self.scale = 0.0;
        
    }
    return self;
}

/** 通过scale的改变改变多种参数 */
- (void)setScale:(CGFloat)scale
{
    _scale = scale;
//    NSLog(@"scale = %lf",scale);
    //1==0,0,0    0=1,1,1   从1，1，1到0，0，0
    self.textColor = [UIColor colorWithRed:(255.0-180.0*scale)/255.0 green:(255.0-180.0*scale)/255.0 blue:(255.0-180.0*scale)/255.0 alpha:1.0];
    
    CGFloat minScale = 0.85;
    CGFloat trueScale = minScale + (1-minScale)*scale;
    self.transform = CGAffineTransformMakeScale(trueScale, trueScale);
}

@end
