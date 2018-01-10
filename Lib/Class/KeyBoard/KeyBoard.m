//
//  KeyBoard.m
//  CityJinFu
//
//  Created by xxlc on 16/8/28.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "KeyBoard.h"

@implementation KeyBoard


- (UIView *)keyBoardview
{
    
    UIView *clip = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 70 * m6Scale)];
    clip.backgroundColor = ButtonColor;
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.text = @"汇诚金服安全输入";
    textLabel.textColor = [UIColor whiteColor];//字体颜色
    [clip addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(clip.mas_centerX);
        make.centerY.mas_equalTo(clip.mas_centerY);
    }];
    
    _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [_doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [clip addSubview:_doneButton];
    
    [_doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(clip.mas_right).offset(- 30 * m6Scale);
        make.centerY.mas_equalTo(clip.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(120 * m6Scale, 40 * m6Scale));
    }];
    
    return clip;
}

@end
