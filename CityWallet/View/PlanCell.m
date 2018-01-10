//
//  PlanCell.m
//  CityJinFu
//
//  Created by mic on 2017/7/12.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "PlanCell.h"

@implementation PlanCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = NO;
        //标题标签
//        _typeLabel = [Factory CreateLabelWithTextColor:1 andTextFont:30 andText:@"季度" addSubView:self.contentView];
//        _typeLabel.layer.cornerRadius = 3*m6Scale;
//        _typeLabel.backgroundColor = navigationColor;
//        _typeLabel.textAlignment = NSTextAlignmentCenter;
//        _typeLabel.layer.masksToBounds = YES;
//        [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(34*m6Scale);
//            make.top.mas_equalTo(23*m6Scale);
//            make.size.mas_equalTo(CGSizeMake(72*m6Scale, 36*m6Scale));
//        }];
        //图标
        _titleLabel = [Factory CreateLabelWithTextColor:0 andTextFont:30 andText:@"锁投计划" addSubView:self.contentView];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(34*m6Scale);
            make.top.mas_equalTo(25*m6Scale);
        }];
        //单线
        _line = [[UIView alloc] initWithFrame:CGRectMake(34*m6Scale, 82*m6Scale, kScreenWidth-34*m6Scale, 1)];
        _line.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.3];
        [self.contentView addSubview:_line];
        //重复创建的两个标签
        NSArray *array = @[@"往期年化", @"投资期限", @"起投金额"];
        for (int i = 0; i < array.count; i++) {
            _label = [Factory CreateLabelWithTextColor:0.8 andTextFont:30 andText:array[i] addSubView:self.contentView];
            _label.textColor = [UIColor lightGrayColor];
            if (i == 1) {
                [_label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo(self.contentView.mas_centerX);
                    make.bottom.mas_equalTo(-25*m6Scale);
                }];
                //投资期限
                _dataLabel = [Factory CreateLabelWithTextColor:0.1 andTextFont:54 andText:@"" addSubView:self.contentView];
                _dataLabel.textColor = BlackColor;
                [_dataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo(self.contentView.mas_centerX);
                    make.top.mas_equalTo(_line.mas_bottom).offset(15*m6Scale);
                }];
            }else if(i == 0){
                [_label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(34*m6Scale);
                    make.bottom.mas_equalTo(-25*m6Scale);
                }];
                //往期年化
                _rateLabel = [Factory CreateLabelWithTextColor:1 andTextFont:54 andText:@"" addSubView:self.contentView];
                _rateLabel.textColor = UIColorFromRGB(0xff5933);
                [_rateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(34*m6Scale);
                    make.top.mas_equalTo(_line.mas_bottom).offset(15*m6Scale);
                }];
            }else{
                
                [_label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-34*m6Scale);
                    make.bottom.mas_equalTo(-25*m6Scale);
                }];
                //起投金额
                _amountLabel = [Factory CreateLabelWithTextColor:1 andTextFont:48 andText:@"1000" addSubView:self.contentView];
                _amountLabel.textColor = BlackColor;
                [_amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-34*m6Scale);
                    make.top.mas_equalTo(_line.mas_bottom).offset(15*m6Scale);
                }];
            }
        }
        //波浪视图
        _waveProgressView = [[TYWaveProgressView alloc] initWithFrame:CGRectMake(kScreenWidth-144*m6Scale, 105 * m6Scale, 110 * m6Scale, 110 * m6Scale)];
        _waveProgressView.waveViewMargin = UIEdgeInsetsMake(0, 0, 0, 0);
        _waveProgressView.backgroundImageView.image = [UIImage imageNamed:@"椭圆"];
        _waveProgressView.numberLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:30 * m6Scale];
        _waveProgressView.numberLabel.textColor = [UIColor colorWithRed:220/255.0 green:0.0 blue:0.0 alpha:1.0];
        [self.contentView addSubview:_waveProgressView];
        [_waveProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-34*m6Scale);
            make.top.mas_equalTo(105*m6Scale);
            make.size.mas_equalTo(CGSizeMake(110*m6Scale, 110*m6Scale));
        }];
//        _waveProgressView.numberLabel.text = @"43%";
//        _waveProgressView.percent = 0.43;
        //加在波浪图上的点击按钮
        _btn = [UIButton buttonWithType:0];
        [_waveProgressView addSubview:_btn];
        _btn.userInteractionEnabled = NO;
        [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        //加息利率
        _addRateLabel = [Factory CreateLabelWithTextColor:1 andTextFont:40 andText:@"" addSubView:self.contentView];
        _addRateLabel.textColor = UIColorFromRGB(0xff5933);
        [_addRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_rateLabel.mas_right).offset(0*m6Scale);
            make.top.mas_equalTo(_line.mas_bottom).offset(29*m6Scale);
        }];
//        //等待开抢
//        _buyLabel = [Factory CreateLabelWithTextColor:1 andTextFont:30 andText:@"" addSubView:self.contentView];
//        _buyLabel.textColor = UIColorFromRGB(0xff5857);
//        [_buyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(-68*m6Scale);
//            make.top.mas_equalTo(26*m6Scale);
//        }];
    }
    return self;
}
- (void)cellForModel:(PlanModel *)model{
    NSString *month = @"";
    //季度 半年 年度 自动 标题
    if (model.planCycle.integerValue == 90) {
        //季度
//        _typeLabel.text = @"季度";
        month = @"3个月";
//        _typeLabel.backgroundColor = UIColorFromRGB(0xFFB514);
        _waveProgressView.hidden = YES;
    }else if(model.planCycle.integerValue == 180){
        //半年
//        _typeLabel.text = @"半年";
        month = @"6个月";
//        _typeLabel.backgroundColor = UIColorFromRGB(0x4AA1FF);
        _waveProgressView.hidden = YES;
    }else if (model.planCycle.integerValue == 360){
//        _typeLabel.text = @"年度";
        month = @"12个月";
//        _typeLabel.backgroundColor = UIColorFromRGB(0xFF5857);
        _waveProgressView.hidden = YES;
    }else{
        //自动
//        _typeLabel.text = @"自动";
//        _typeLabel.backgroundColor = UIColorFromRGB(0xFD6C15);
        _waveProgressView.hidden = NO;
    }
    _titleLabel.text = [NSString stringWithFormat:@"%@", model.planName];//标题
    if (model.planCycle.integerValue < 361) {
        //投资期限
        NSMutableAttributedString *mutaString = [self MutableString:month andLeftRange:[month rangeOfString:@"个月"] leftFont:30];//期限
        [self String:mutaString andChangeColorString:month andLabel:_dataLabel];
        _btn.userInteractionEnabled = NO;
        NSString *scale = [NSString stringWithFormat:@"%.2f", model.planBlance.floatValue/model.planAmount.floatValue];
        _waveProgressView.numberLabel.text = [NSString stringWithFormat:@"%.f%@", 100-scale.floatValue*100,@"%"];
        _waveProgressView.percent = 1-scale.floatValue;
        [_waveProgressView startWave];
        //起购按钮
        _amountLabel.text = [NSString stringWithFormat:@"%ld", model.planMinLimit.integerValue];
        //增加利率
        if (model.planAddRate.floatValue) {
            _addRateLabel.text = [NSString stringWithFormat:@"+%.1f%@", model.planAddRate.floatValue, @"%"];
            [Factory ChangeSize:@"%" andLabel:_addRateLabel size:28];
        }
        //利率
        NSString *rateStr = [NSString stringWithFormat:@"%.1f%@", model.planRate.floatValue, @"%"];
        //利率
        _rateLabel.attributedText = [self MutableString:rateStr andLeftRange:[rateStr rangeOfString:@"%"] leftFont:30];//
    }else{
        _label.hidden = YES;
        _amountLabel.hidden = YES;
        _dataLabel.text = @"不限";
        _waveProgressView.numberLabel.text = @"开启";
        _waveProgressView.numberLabel.textColor = UIColorFromRGB(0xFD6C15);
        _btn.userInteractionEnabled = YES;
        //利率
        _rateLabel.text = [NSString stringWithFormat:@"%.1f%@起", model.planRate.floatValue, @"%"];
        //利率
        [Factory ChangeSize:@"%起" andLabel:_rateLabel size:30];
    }
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
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:[str rangeOfString:@"个月"]];
    label.attributedText = string;
}

@end
