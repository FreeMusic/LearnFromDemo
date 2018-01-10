//
//  PGIndexBannerSubiew.m
//  NewPagedFlowViewDemo
//
//  Created by Mars on 16/6/18.
//  Copyright © 2016年 Mars. All rights reserved.
//  Designed By PageGuo,
//  QQ:799573715
//  github:https://github.com/PageGuo/NewPagedFlowView

#import "PGIndexBannerSubiew.h"

@interface PGIndexBannerSubiew ()

@property (nonatomic, strong) UIView *progress;//进度条
@property (nonatomic, strong) UILabel *progressLabel;//进度标签

@end

@implementation PGIndexBannerSubiew

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self addSubview:self.mainImageView];
        [self.mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(0*m6Scale);
            make.right.bottom.mas_equalTo(0*m6Scale);
        }];
        [self addSubview:self.coverView];
        [self creatView];
    }
    
    return self;
}
/**
 布局
 */
- (void)creatView{
    [self addSubview:self.iconImageView];
    [self addSubview:self.itemName];
    [self addSubview:self.rateLab];
    [self addSubview:self.rateTitle];
    [self addSubview:self.cycleTime];
    [self addSubview:self.cycleTitle];
    //图标
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top).offset(20*m6Scale);
        make.size.mas_equalTo(CGSizeMake(60*m6Scale, 60*m6Scale));
    }];
    [_iconImageView addSubview:self.invistBtn];
    //项目标题
    [_itemName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImageView.mas_right).offset(20*m6Scale);
        make.top.equalTo(self.mas_top).offset(30*m6Scale);
    }];
    //利率
    [_rateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.centerY.equalTo(self.mas_centerY).offset(-20*m6Scale);
        make.width.mas_equalTo(609*m6Scale/2);
    }];
    //往期年化
    [_rateTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(_rateLab.mas_bottom).offset(10*m6Scale);
        make.width.mas_equalTo(609*m6Scale/2);
    }];
    //期限
    [_cycleTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.centerY.equalTo(_rateLab.mas_centerY);
        make.width.mas_equalTo(609*m6Scale/2);
    }];
    //投资期限
    [_cycleTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.top.equalTo(_cycleTime.mas_bottom).offset(10*m6Scale);
        make.width.mas_equalTo(609*m6Scale/2);
    }];
    //立即投资
    [_invistBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@(80*m6Scale));
    }];
    //灰色背景条
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    backView.layer.cornerRadius = 3*m6Scale;
    backView.layer.masksToBounds = YES;
    [self addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_invistBtn.mas_top).offset(-10*m6Scale);
        make.size.mas_equalTo(CGSizeMake(456*m6Scale, 6*m6Scale));
        make.left.mas_equalTo(60*m6Scale);
    }];
    //主色调进度条
    [backView addSubview:self.progress];
    //进度的百分比标签
    [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(backView.mas_right).offset(20*m6Scale);
        make.bottom.mas_equalTo(backView.mas_bottom).offset(10*m6Scale);
    }];
}
/**
 * 进度的百分比
 */
- (UILabel *)progressLabel{
    if(!_progressLabel){
        _progressLabel = [Factory CreateLabelWithTextColor:0 andTextFont:26 andText:@"" addSubView:self];
        _progressLabel.textColor = UIColorFromRGB(0x969595);
    }
    return _progressLabel;
}
/**
 * 进度条
 */
- (UIView *)progress{
    if(!_progress){
        _progress = [[UIView alloc] init];
        //[UIColor colorWithRed:253.0 / 255.0 green:182.0 / 255.0 blue:21.0/255.0 alpha:scrollView.contentOffset.y / 64]];
        _progress.backgroundColor = Colorful(253.0, 182.0, 21.0);
        _progress.layer.cornerRadius = 3*m6Scale;
        _progress.layer.masksToBounds = YES;
    }
    return _progress;
}
/**
 背景图片
 */
- (UIImageView *)mainImageView {
    
    if (_mainImageView == nil) {
        _mainImageView = [[UIImageView alloc] init];
        _mainImageView.userInteractionEnabled = YES;
        //        _mainImageView.image = [UIImage imageNamed:@"热门推荐"];
        //_mainImageView.backgroundColor = [UIColor whiteColor];
    }
    return _mainImageView;
}

- (UIView *)coverView {
    if (_coverView == nil) {
        _coverView = [[UIView alloc] initWithFrame:self.bounds];
        _coverView.backgroundColor = [UIColor whiteColor];
    }
    return _coverView;
}
/**
 图标
 */
- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
        //        _iconImageView.backgroundColor = [UIColor whiteColor];
    }
    return _iconImageView;
}
/**
 标名
 */
- (UILabel *)itemName{
    if (!_itemName) {
        _itemName = [UILabel new];
        _itemName.text = @"车贷宝 222期";
        _itemName.textColor = BlackColor;
        _itemName.font = [UIFont systemFontOfSize:36*m6Scale];
    }
    return _itemName;
}
/**
 利率
 */
- (UILabel *)rateLab{
    if (!_rateLab) {
        _rateLab = [UILabel new];
        _rateLab.text = @"8.8%";
        _rateLab.textColor = UIColorFromRGB(0xff5933);
        _rateLab.textAlignment = NSTextAlignmentCenter;
        _rateLab.font = [UIFont systemFontOfSize:54*m6Scale];
    }
    return _rateLab;
}
/**
 利率标题
 */
- (UILabel *)rateTitle{
    if (!_rateTitle) {
        _rateTitle = [UILabel new];
        _rateTitle.text = @"往期年化";
        _rateTitle.textAlignment = NSTextAlignmentCenter;
        _rateTitle.textColor = [UIColor lightGrayColor];
        _rateTitle.font = [UIFont systemFontOfSize:26*m6Scale];
    }
    return _rateTitle;
}
/**
 期限
 */
- (UILabel *)cycleTime{
    if (!_cycleTime) {
        _cycleTime = [UILabel new];
        _cycleTime.text = @"30天";
        _cycleTime.textAlignment = NSTextAlignmentCenter;
        _cycleTime.textColor = BlackColor;
        _cycleTime.font = [UIFont systemFontOfSize:54*m6Scale];
    }
    return _cycleTime;
}
/**
 投资期限
 */
- (UILabel *)cycleTitle{
    if (!_cycleTitle) {
        _cycleTitle = [UILabel new];
        _cycleTitle.text = @"投资期限";
        _cycleTitle.textAlignment = NSTextAlignmentCenter;
        _cycleTitle.textColor = [UIColor lightGrayColor];
        _cycleTitle.font = [UIFont systemFontOfSize:26*m6Scale];
    }
    
    return _cycleTitle;
}
/**
 立即投资
 */
- (UILabel *)invistBtn{
    if (!_invistBtn) {
        _invistBtn = [UILabel new];
        _invistBtn.text = @"立即投资";
        _invistBtn.textColor = UIColorFromRGB(0xff5933);
        _invistBtn.font = [UIFont systemFontOfSize:36*m6Scale];
        _invistBtn.textAlignment = NSTextAlignmentCenter;
    }
    return _invistBtn;
}

- (void)viewForModel:(ItemListModel *)model{
    NSLog(@"66++++%ld",(long)model.itemIsrecommend.integerValue);
    //首先判断定向标
    if (model.password == nil) {
        //推荐
        if (model.itemIsrecommend.integerValue == 1) {
            _mainImageView.image = [UIImage imageNamed:@"热门推荐"];
        }else if(model.moveVip.integerValue == 1){
            //App专享
            _mainImageView.image = [UIImage imageNamed:@"APP专享"];
        }else{
            _mainImageView.image = [UIImage imageNamed:@"home_bj"];//正常标
        }
    }else{
        _mainImageView.image = [UIImage imageNamed:@"定向专享"];
    }
    //标题
    _itemName.text = model.itemName;
    //利率
    _rateLab.text = [NSString stringWithFormat:@"%.1f%@", model.itemRate.floatValue, @"%"];
    NSMutableAttributedString *rate = [self MutableString:_rateLab.text andLeftRange:NSMakeRange(_rateLab.text.length-1, 1) leftFont:30];
    _rateLab.attributedText = rate;//利率
    //投资期限
    NSString *dataUnit = nil;
    //确定时间单位
    switch (model.itemCycleUnit.integerValue) {
        case 1:
            dataUnit = @"天";
            break;
        case 2:
            dataUnit = @"月";
            break;
        case 3:
            dataUnit = @"季";
            break;
        case 4:
            dataUnit = @"年";
            break;
            
        default:
            break;
    }
    _cycleTime.text = [NSString stringWithFormat:@"%@%@", model.itemCycle, dataUnit];
    NSMutableAttributedString *cycle = [self MutableString:_cycleTime.text andLeftRange:NSMakeRange(_cycleTime.text.length-1, 1) leftFont:30];
    [self String:cycle andChangeColorString:_cycleTime.text andLabel:_cycleTime];
    NSInteger status = model.itemStatus.integerValue;
    NSLog(@"status = %ld", status);
    if (status == 0 || status == 1 || status == 2) {
        [self setButtonTitle:@"等待开放"];
    }else if (status == 18 || status == 20 || status == 23){
        [self setButtonTitle:@"已满标"];
    }else if(status == 30 || status == 31 || status == 32){
        [self setButtonTitle:@"还款中"];
    }else if(status == 10){
        _invistBtn.text = @"立即投资";
        _invistBtn.textColor = UIColorFromRGB(0xff5933);
    }else if(status == 13 || status == 14){
        [self setButtonTitle:@"流标"];
    }
    //更新用户投资进度
    [self setUpProgress:model.itemScale.integerValue];
    //显示该标的投资百分比
    //水波纹百分比
    self.progressLabel.text = [NSString stringWithFormat:@"%@%@", [Factory stringByNotRounding:model.itemScale.doubleValue afterPoint:0], @"%"];
}
/**
 *更新用户投资进度
 */
- (void)setUpProgress:(NSInteger)progress{
    [self.progress mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(progress*456*m6Scale/100.0);
        make.left.top.bottom.mas_equalTo(0);
    }];
}
/**
 *标签颜色
 */
- (void)setButtonTitle:(NSString *)title{
    _invistBtn.text = title;
    _invistBtn.textColor = [UIColor colorWithWhite:0.7 alpha:1];
}
/**
 同一个label改变字体大小(可自定义改变字体大小)
 */
- (NSMutableAttributedString *)MutableString:(NSString *)string andLeftRange:(NSRange)leftrange leftFont:(CGFloat)leftFont{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    //设置某个范围内的字体大小
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:54*m6Scale] range:NSMakeRange(0, string.length)];
    //设置某个范围内的字体大小
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:leftFont*m6Scale] range:leftrange];
    
    return str;
}
/**
 中间字体颜色的改变(万全)
 */
- (void)String:(NSMutableAttributedString *)string andChangeColorString:(NSString *)str andLabel:(UILabel *)label{
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(str.length-1, 1)];
    label.attributedText = string;
}
@end
