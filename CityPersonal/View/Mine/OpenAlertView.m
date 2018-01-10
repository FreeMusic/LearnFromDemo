//
//  OpenAlertView.m
//  CityJinFu
//
//  Created by xxlc on 17/7/14.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "OpenAlertView.h"
#import "PassGuardCtrl.h"

@interface OpenAlertView ()

@property(nonatomic , strong) UIImageView *leftImage;
@property(nonatomic , strong) UIImageView *rightImage;
@property(nonatomic , strong) UIImageView *topImage;
@property(nonatomic , strong) UIView *alertView;

@property(nonatomic , strong) UIButton *closeBtn;// 激活存管
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *welfBtn;//查看福利

@end

@implementation OpenAlertView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.8];
        [self layout];
        
        [self NoRealNameWelfare];
    }
    return self;
}
- (void)layout{
    //背景
    [self addSubview:self.alertView];
    [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self).offset(0*m6Scale);
        make.right.mas_equalTo(self).offset(0*m6Scale);
    }];
    
    //beijing tupian  背景图
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AlterViewBack"]];
    [self.alertView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(692*m6Scale, 653*m6Scale));
        make.centerX.mas_equalTo(self.alertView.mas_centerX);
        make.centerY.mas_equalTo(self.alertView.mas_centerY);
    }];
    
//    UIView *bgView = [UIView new];
//    bgView.layer.backgroundColor = backGroundColor.CGColor;
//    [self.alertView addSubview:bgView];
//    
//    [self addSubview:self.topImage];
//    [self.topImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self.mas_centerX);
//        make.centerY.mas_equalTo(self.alertView.mas_top);
//    }];
    
//    //左边图片
//    [self.alertView addSubview:self.leftImage];
//    [self.leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.alertView).offset(60*m6Scale);
//        make.left.mas_equalTo(self.alertView.mas_left).offset(40*m6Scale);
//        make.size.mas_offset(CGSizeMake(200*m6Scale, 70*m6Scale));
//    }];
//    //右边图片
//    [self.alertView addSubview:self.rightImage];
//    [self.rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.alertView).offset(60*m6Scale);
//        make.right.mas_equalTo(self.alertView.mas_right).offset(-40*m6Scale);
//        make.size.mas_offset(CGSizeMake(200*m6Scale, 70*m6Scale));
//    }];
//    UIView *line = [UIView new];
//    line.backgroundColor = [UIColor lightGrayColor];
//    [self.alertView addSubview:line];
//    [line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.offset(1);
//        make.top.mas_equalTo(self.leftImage).offset(10*m6Scale);
//        make.bottom.mas_equalTo(self.leftImage).offset(-10*m6Scale);
//        make.centerX.mas_equalTo(self.alertView);
//    }];
//    //提示信息
//    UILabel *textLabel = [Factory CreateLabelWithTextColor:0.5 andTextFont:26 andText:@"汇诚金服与民泰银行的资金存管合作现已上线" addSubView:self.alertView];
//    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self);
//        make.top.mas_equalTo(self.rightImage.mas_bottom).offset(20*m6Scale);
//    }];
//    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.top.mas_equalTo(self.alertView);
//        make.bottom.mas_equalTo(textLabel.mas_bottom).offset(30*m6Scale);
//    }];
//    UILabel *titleLabel = [Factory CreateLabelWithTextColor:0.5 andTextFont:30 andText:@"" addSubView:self.alertView];
//    titleLabel.textColor = [UIColor blackColor];
//    titleLabel.numberOfLines = 0;
//    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.alertView.mas_left).offset(28*m6Scale);
//        make.right.mas_equalTo(self.alertView.mas_right).offset(-28*m6Scale);
//        make.top.mas_equalTo(self.alertView.mas_top).offset(220*m6Scale);
//    }];
    _messageLabel = [Factory CreateLabelWithTextColor:0.5 andTextFont:32 andText:@"" addSubView:self];
    _messageLabel.numberOfLines = 0;
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    _messageLabel.textColor = UIColorFromRGB(0x303030);
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.alertView.mas_top).offset(290*m6Scale);
        make.width.mas_equalTo(524*m6Scale);
        make.centerX.mas_equalTo(self.alertView.mas_centerX);
    }];
    //开通
    [self.alertView addSubview:self.openBtn];
    [self.openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(524*m6Scale);
        make.centerX.mas_equalTo(self.alertView.mas_centerX);
        make.top.mas_equalTo(_messageLabel.mas_bottom).offset(66*m6Scale);
        make.height.mas_offset(88*m6Scale);
    }];
    
    //查看福利
    [self.alertView addSubview:self.welfBtn];
    [self.welfBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(524*m6Scale);
        make.centerX.mas_equalTo(self.alertView.mas_centerX);
        make.top.mas_equalTo(self.openBtn.mas_bottom).offset(10*m6Scale);
        make.height.mas_offset(88*m6Scale);
    }];
    
    [self.alertView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.welfBtn.mas_bottom).offset(40*m6Scale);
        make.center.mas_equalTo(self);
    }];
    
    //不开通
    [self addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.alertView.mas_bottom).offset(100*m6Scale);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.size.mas_offset(CGSizeMake(70*m6Scale, 70*m6Scale));
    }];
}
/**
 背景视图
 */
- (UIView *)alertView{
    if (!_alertView) {
        _alertView = [UIView new];
        _alertView.backgroundColor = [UIColor clearColor];
        _alertView.layer.cornerRadius = 5;
        _alertView.layer.masksToBounds =YES;
    }
    return _alertView;
}
/**
 左边图片
 */
- (UIImageView *)topImage{
    if (!_topImage) {
        _topImage = [UIImageView new];
        _topImage.image = [UIImage imageNamed:@"alertTop"];
    }
    return _topImage;
}
/**
 左边图片
 */
- (UIImageView *)leftImage{
    if (!_leftImage) {
        _leftImage = [UIImageView new];
        _leftImage.image = [UIImage imageNamed:@"alertLeft"];
    }
    return _leftImage;
}
/**
 *右边图片
 */
- (UIImageView *)rightImage{
    if (!_rightImage) {
        _rightImage = [UIImageView new];
        _rightImage.image = [UIImage imageNamed:@"alertRight"];
    }
    return _rightImage;
}

/**
 开通
 */
- (UIButton *)openBtn{
    if (!_openBtn) {
        _openBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_openBtn setTitle:@"激活存管" forState:0];
        [_openBtn setTitleColor:[UIColor whiteColor] forState:0];
        _openBtn.layer.backgroundColor = ButtonColor.CGColor;
        _openBtn.layer.cornerRadius = 10*m6Scale;
        _openBtn.tag = 0;
        [_openBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _openBtn;
}
/**
 *  查看福利
 */
- (UIButton *)welfBtn{
    if(!_welfBtn){
        _welfBtn = [UIButton buttonWithType:0];
        [_welfBtn setTitle:@"查看福利" forState:0];
        [_welfBtn setTitleColor:UIColorFromRGB(0x8d8d8d) forState:0];
        _welfBtn.layer.borderColor = UIColorFromRGB(0xd9d9d9).CGColor;
        _welfBtn.layer.cornerRadius = 10*m6Scale;
        _welfBtn.layer.borderWidth = 1;
        _welfBtn.tag = 2;
        [_welfBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _welfBtn;
}
/**
 暂不开通
 */
- (UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"alertCancle"] forState:0];
        [_closeBtn setTitleColor:UIColorFromRGB(0x767676) forState:0];
        _closeBtn.tag = 1;
        [_closeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _closeBtn;
}
/**
 点击事件
*/
- (void)btnClick:(UIButton *)btn{
    if (self.buttonAction) {
        self.buttonAction(btn.tag);
    }
}
/**
 * set方法
 */
- (void)setShowPswView:(BOOL)showPswView{
    _showPswView = showPswView;
    self.closeBtn.hidden = YES;
}
- (void)setShowMyWealf:(BOOL)showMyWealf{
    _showMyWealf = showMyWealf;
    self.welfBtn.hidden = showMyWealf;
}
/**
 *  用户登录  未实名  获取后台福利信息
 */
- (void)NoRealNameWelfare{
    
    [DownLoadData postCountNoviceWelfare:^(id obj, NSError *error) {
        
        _messageLabel.text = [NSString stringWithFormat:@"%ld元红包、%ld元体验金已放入您的账户", [obj[@"coupon"] integerValue], [obj[@"expGold"] integerValue]];
        
        NSString *coupon = [NSString stringWithFormat:@"%@", obj[@"coupon"]];
        
        NSString *expGold = [NSString stringWithFormat:@"%@", obj[@"expGold"]];
        
        [Factory ChangeSizeAndColor:coupon otherStr:expGold andLabel:_messageLabel size:40 color:UIColorFromRGB(0xff5933)];
        
        
    } userId:[HCJFNSUser stringForKey:@"userId"]];
    
}
@end
