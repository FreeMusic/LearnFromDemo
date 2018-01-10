//
//  MyBackView.m
//  CityJinFu
//
//  Created by xxlc on 17/6/16.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "MyBackView.h"
#import "MyViewController.h"

@implementation MyBackView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.8];
        [self creatView];
    }
    return self;
}
/**
 布局
 */
- (void)creatView{
    [self addSubview:self.imageview];
    [self addSubview:self.primitLab];
    [self addSubview:self.signBtn];
    [self addSubview:self.welfImgView];
    //登录
    [_signBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-30*m6Scale);
        make.left.mas_equalTo(20*m6Scale);
        make.right.mas_equalTo(-20*m6Scale);
        make.height.mas_equalTo(90*m6Scale);
    }];
    //提示label
    [_primitLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_signBtn.mas_top).offset(-10*m6Scale);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    //盾牌
    [_imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40*m6Scale, 40*m6Scale));
        make.right.mas_equalTo(_primitLab.mas_left).offset(-10*m6Scale);
        make.bottom.mas_equalTo(_primitLab.mas_bottom);
    }];
    
    //福利视图
    [self.welfImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(750*m6Scale, 747*m6Scale));
    }];
}
/**
 盾牌
 */
- (UIImageView *)imageview{
    if (!_imageview) {
        _imageview = [UIImageView new];
        _imageview.image = [UIImage imageNamed:@"盾牌"];
    }
    return _imageview;
}
/**
 提示label
 */
- (UILabel *)primitLab{
    if (!_primitLab) {
        _primitLab = [UILabel new];
        _primitLab.text = @"浙江民泰商业银行存管保护资金安全";
        _primitLab.textColor = [UIColor whiteColor];
        _primitLab.font = [UIFont systemFontOfSize:30*m6Scale];
    }
    
    return _primitLab;
}
/**
 登录/注册
 */
- (UIButton *)signBtn{
    if (!_signBtn) {
        _signBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_signBtn setTitle:@"登录/注册" forState:UIControlStateNormal];
        _signBtn.backgroundColor = buttonColor;
        _signBtn.userInteractionEnabled = YES;
        [_signBtn addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        _signBtn.titleLabel.font = [UIFont systemFontOfSize:30*m6Scale];
    }
    return _signBtn;
}
/**
 *   福利弹屏图片
 */
- (UIImageView *)welfImgView{
    if(!_welfImgView){
        _welfImgView = [[UIImageView alloc] init];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonClick)];
        
        _welfImgView.userInteractionEnabled = YES;
        [_welfImgView addGestureRecognizer:tap];
        
    }
    return _welfImgView;
}
/**
 登录/注册按钮点击事件
 */
- (void)buttonClick{
    //发送通知
    NSNotification *notification = [[NSNotification alloc] initWithName:@"HiddenBackView" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}


@end
