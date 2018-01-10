//
//  HCJFTextField.m
//  CityJinFu
//
//  Created by xxlc on 16/8/28.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "HCJFTextField.h"

@implementation HCJFTextField

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

+ (UITextField *)textStr:(NSString *)textPlaceholder andTag:(NSInteger)tag andFont:(NSInteger)font
{
    UITextField *textField = [[UITextField alloc]init];
    textField.font = [UIFont systemFontOfSize:28*m6Scale];//输入的文字字体的大小
    textField.textColor = textFieldColor;//字体颜色
    textField.tintColor = textFieldColor;//光标颜色
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:textPlaceholder attributes:@{NSForegroundColorAttributeName: textFieldColor}];//阴影字体的颜色
    [textField setValue:[UIFont fontWithName:@"STHeitiSC-Light" size:font] forKeyPath:@"_placeholderLabel.font"];//placeholder字体的大小
    textField.tag = tag;

    return textField;
}

@end
