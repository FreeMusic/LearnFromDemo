//
//  PasswordTextField.m
//  xiao2chedai
//
//  Created by xxlc on 16/5/19.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "PasswordTextField.h"

@implementation PasswordTextField

//控制placeHolder的位置，左右缩20
-(CGRect)placeholderRectForBounds:(CGRect)bounds
{
    if (iPhone5) {
        CGRect inset = CGRectMake(bounds.origin.x+30, bounds.origin.y+2, bounds.size.width -10, bounds.size.height);//更好理解些
        return inset;
    } else {
        CGRect inset = CGRectMake(bounds.origin.x+30, bounds.origin.y, bounds.size.width -10, bounds.size.height);//更好理解些
        return inset;
    }
    
    //return CGRectInset(bounds, 20, 0);
}
//控制显示文本的位置
-(CGRect)textRectForBounds:(CGRect)bounds
{
    //return CGRectInset(bounds, 50, 0);
    if (iPhone5) {
        CGRect inset = CGRectMake(bounds.origin.x+30, bounds.origin.y+2, bounds.size.width -10, bounds.size.height);//更好理解些
        return inset;
    } else {
        CGRect inset = CGRectMake(bounds.origin.x+30, bounds.origin.y, bounds.size.width -10, bounds.size.height);//更好理解些
        return inset;
    }
    
}
//控制编辑文本的位置
-(CGRect)editingRectForBounds:(CGRect)bounds
{
    //return CGRectInset( bounds, 10 , 0 );
    
    if (iPhone5) {
        CGRect inset = CGRectMake(bounds.origin.x+30, bounds.origin.y+2, bounds.size.width -10, bounds.size.height);//更好理解些
        return inset;
    } else {
        CGRect inset = CGRectMake(bounds.origin.x+30, bounds.origin.y, bounds.size.width -10, bounds.size.height);//更好理解些
        return inset;
    }
}

@end
