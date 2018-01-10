//
//  AscertainView.m
//  CityJinFu
//
//  Created by mic on 2017/10/10.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "AscertainView.h"

@implementation AscertainView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //确定按钮
        [self addSubview:self.button];
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(596*m6Scale, 86*m6Scale));
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(0);
        }];
    }
    return self;
}
- (void)setIconType:(IconType)iconType{
    _iconType = iconType;
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom).offset(-3*m6Scale);
    }];
    if (iconType == IconType_Voice) {
        //语音验证标签
        self.label.userInteractionEnabled = YES;
        self.label.text = @"收不到验证码，点击获取语音验证码";
        self.label.textColor = UIColorFromRGB(0xff5933);
        [Factory ChangeColorString:@"收不到验证码，点击获取" andLabel:self.label andColor:UIColorFromRGB(0x8f8f8f)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(voiceVerification)];
        [self.label addGestureRecognizer:tap];
        //语音小图标
        self.imageView.image = [UIImage imageNamed:@"NewSign_语音"];
        [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.label.mas_left).offset(-10*m6Scale);
            make.bottom.equalTo(self.mas_bottom).offset(-3*m6Scale);
            make.size.mas_equalTo(CGSizeMake(19*m6Scale, 29*m6Scale));
        }];
    }else if (iconType == IconType_Safe){
        //文字
        self.label.userInteractionEnabled = NO;
        self.label.textColor = [UIColor lightGrayColor];
        self.label.text = @"汇诚金服全面接入民泰银行存管系统";
        //盾牌
        self.imageView.image = [UIImage imageNamed:@"NewSign_账户安全"];
        [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.label.mas_left).offset(-10*m6Scale);
            make.bottom.equalTo(self.mas_bottom).offset(-3*m6Scale);
            make.size.mas_equalTo(CGSizeMake(30*m6Scale, 30*m6Scale));
        }];
    }
}
/**
 *  小图标
 */
- (UIImageView *)imageView{
    if(!_imageView){
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
    }
    return _imageView;
}
/**
 *  label
 */
- (UILabel *)label{
    if(!_label){
        _label = [[UILabel alloc] init];
        [self addSubview:_label];
        _label.font = [UIFont systemFontOfSize:26*m6Scale];
    }
    return _label;
}
/**
 *  确定按钮
 */
- (UIButton *)button{
    if(!_button){
        _button = [UIButton buttonWithType:0];
        [_button setTitle:@"确定" forState:0];
        [_button setTitleColor:[UIColor whiteColor] forState:0];
        
        _button.layer.cornerRadius = 10*m6Scale;
        _button.layer.masksToBounds = YES;
        _button.buttonWhetherClick = ButtonCanNotClickWithHalfAlpha;
    }
    return _button;
}
/**
 *  获取语音验证码
 */
- (void)voiceVerification{
    if (self.getVoiceCodeBlock) {
        self.getVoiceCodeBlock(_iconType, self.label, self.button);
    }
}
@end
