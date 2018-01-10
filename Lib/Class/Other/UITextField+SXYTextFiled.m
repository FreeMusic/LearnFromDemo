//
//  UITextField+SXYTextFiled.m
//  CityJinFu
//
//  Created by mic on 2017/7/18.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "UITextField+SXYTextFiled.h"

@implementation UITextField (SXYTextFiled)

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    //修改占位符文字颜色
    [self setValue:UIColorFromRGB(0xB1B0B0) forKeyPath:@"placeholderLaber.textColor"];
}

@end
