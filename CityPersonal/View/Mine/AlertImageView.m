//
//  AlertImageView.m
//  CityJinFu
//
//  Created by xxlc on 17/8/22.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "AlertImageView.h"

@interface AlertImageView ()
@property(nonatomic , strong) UIImageView *topImage;
@property(nonatomic , strong) UIButton *comfireBtn;
@property(nonatomic , strong) UIView *alertView;
@end

@implementation AlertImageView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.8];
        [self layout];
    }
    return self;
}
- (void)layout{
    //背景
    [self addSubview:self.alertView];
    [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self).offset(70*m6Scale);
        make.right.mas_equalTo(self).offset(-70*m6Scale);
    }];
    UILabel *title = [Factory CreateLabelWithTextColor:0.5 andTextFont:32 andText:@"规则说明" addSubView:self];
    title.textColor = [UIColor blackColor];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.alertView);
        make.top.mas_equalTo(self.alertView).offset(30*m6Scale);
    }];
    [self addSubview:self.topImage];
    [self.topImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(title.mas_bottom).offset(20*m6Scale);
        make.centerX.mas_equalTo(self.alertView);
        make.size.offset(CGSizeMake(540*m6Scale, 560*m6Scale));
    }];
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.alertView);
        make.right.mas_equalTo(self.alertView);
        make.top.mas_equalTo(self.topImage.mas_bottom).offset(10*m6Scale);
        make.height.mas_offset(0.5);
    }];
    [self addSubview:self.comfireBtn];
    [self.comfireBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.alertView);
        make.right.mas_equalTo(self.alertView);
        make.top.mas_equalTo(self.topImage.mas_bottom).offset(20*m6Scale);
        make.height.mas_offset(80*m6Scale);
    }];
    [self.alertView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.comfireBtn.mas_bottom);
        make.center.mas_equalTo(self);
    }];
}
/**
 背景视图
 */
- (UIView *)alertView{
    if (!_alertView) {
        _alertView = [UIView new];
        _alertView.backgroundColor = [UIColor whiteColor];
        _alertView.layer.cornerRadius = 5;
        _alertView.layer.masksToBounds =YES;
    }
    return _alertView;
}

- (UIButton *)comfireBtn{
    if (!_comfireBtn) {
        _comfireBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_comfireBtn setTitle:@"确定" forState:0];
        [_comfireBtn setTitleColor:UIColorFromRGB(0xff5933) forState:0];
        _comfireBtn.tag = 0;
        [_comfireBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _comfireBtn;
}
- (UIImageView *)topImage{
    if (!_topImage) {
        _topImage = [UIImageView new];
        _topImage.image = [UIImage imageNamed:@"alertImage"];
    }
    return _topImage;
}
/**
 点击事件
 */
- (void)btnClick:(UIButton *)btn{
    if (self.buttonAction) {
        self.buttonAction(btn.tag);
    }
}

@end
