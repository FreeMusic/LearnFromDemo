//
//  CityWalletCell.m
//  CityJinFu
//
//  Created by mic on 2017/6/8.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "CityWalletCell.h"

@interface CityWalletCell ()

@property (nonatomic, strong) UIImageView *imgView;//标状态图标

@end

@implementation CityWalletCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = backGroundColor;
        self.selectionStyle = NO;
        //白色背景
        _whiteView = [UIView new];
        _whiteView.backgroundColor = [UIColor whiteColor];
        _whiteView.frame = CGRectMake(0, 20*m6Scale, kScreenWidth, 228*m6Scale);
        [self.contentView addSubview:_whiteView];
        //标题标签
        _titleLabel = [Factory CreateLabelWithTextColor:0 andTextFont:30 andText:@"车贷宝  第122期" addSubView:self.whiteView];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(34*m6Scale);
            make.top.mas_equalTo(26*m6Scale);
        }];
        //图标
        _iconImgView = [Factory imageView:@""];
        [self.whiteView addSubview:_iconImgView];
        [_iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_titleLabel.mas_right).offset(10*m6Scale);
            make.centerY.mas_equalTo(_titleLabel.mas_centerY);
        }];
        //单线
        _line = [[UIView alloc] initWithFrame:CGRectMake(34*m6Scale, 82*m6Scale, kScreenWidth-34*m6Scale, 1)];
        _line.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.3];
        [self.whiteView addSubview:_line];
        //重复创建的两个标签
        NSArray *array = @[@"往期年化", @"投资期限"];
        for (int i = 0; i < array.count; i++) {
            _label = [Factory CreateLabelWithTextColor:0.8 andTextFont:30 andText:array[i] addSubView:self.whiteView];
            _label.textColor = [UIColor lightGrayColor];
            if (i) {
                [_label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-136*m6Scale-168*m6Scale);
                    make.bottom.mas_equalTo(-25*m6Scale);
                }];
                //投资期限
                _dataLabel = [Factory CreateLabelWithTextColor:0.1 andTextFont:54 andText:@"" addSubView:self.whiteView];
                _dataLabel.textColor = BlackColor;
                [_dataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-136*m6Scale-168*m6Scale);
                    make.top.mas_equalTo(_line.mas_bottom).offset(15*m6Scale);
                }];
            }else{
                [_label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(34*m6Scale);
                    make.bottom.mas_equalTo(-25*m6Scale);
                }];
                //往期年化
                _rateLabel = [Factory CreateLabelWithTextColor:1 andTextFont:54 andText:@"" addSubView:self.whiteView];
                _rateLabel.textColor = UIColorFromRGB(0xff5933);
                [_rateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(34*m6Scale);
                    make.top.mas_equalTo(_line.mas_bottom).offset(15*m6Scale);
                }];
            }
        }
        //波浪视图
        _waveProgressView = [[TYWaveProgressView alloc] initWithFrame:CGRectMake(kScreenWidth-168*m6Scale, 103 * m6Scale, 114 * m6Scale, 114 * m6Scale)];
        _waveProgressView.waveViewMargin = UIEdgeInsetsMake(0, 0, 0, 0);
        _waveProgressView.backgroundImageView.image = [UIImage imageNamed:@"椭圆"];
        _waveProgressView.numberLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:30 * m6Scale];
        _waveProgressView.numberLabel.textColor = [UIColor colorWithRed:220/255.0 green:0.0 blue:0.0 alpha:1.0];
        [self.whiteView addSubview:_waveProgressView];
        _waveProgressView.numberLabel.text = @"43%";
        _waveProgressView.percent = 0.43;
//        //加息利率背景图
//        _backView = [[UIImageView alloc] init];
//        _backView.image = [UIImage imageNamed:@"jiaxi"];
//        [self.whiteView addSubview:_backView];
//        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(_rateLabel.mas_right).offset(8*m6Scale);
//            make.top.mas_equalTo(_line.mas_bottom).offset(24*m6Scale);
//            make.size.mas_equalTo(CGSizeMake(79*m6Scale, 35*m6Scale));
//        }];
        //加息利率
        _addRateLabel = [Factory CreateLabelWithTextColor:1 andTextFont:40 andText:@"+0.2%" addSubView:self.whiteView];
        _addRateLabel.textColor = UIColorFromRGB(0xff5933);
        [_addRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_rateLabel.mas_bottom);
            make.left.mas_equalTo(_rateLabel.mas_right);
        }];
        //几点开抢
        _buyLabel = [Factory CreateLabelWithTextColor:1 andTextFont:30 andText:@"" addSubView:self.contentView];
        _buyLabel.textColor = UIColorFromRGB(0xff5857);
        [_buyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-30*m6Scale);
            make.top.mas_equalTo(46*m6Scale);
        }];
    }
    return self;
}
/**
 *标状态图标
 */
- (UIImageView *)imgView{
    if(!_imgView){
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-168*m6Scale, 123 * m6Scale, 114 * m6Scale, 114 * m6Scale)];
        [self.contentView addSubview:_imgView];
    }
    
    return _imgView;
}
/**
 *预约按钮
 */
- (UIButton *)appointBtn{
    if(!_appointBtn){
        _appointBtn = [UIButton buttonWithType:0];
        [self.contentView addSubview:_appointBtn];
        _appointBtn.frame = CGRectMake(kScreenWidth-168*m6Scale, 103 * m6Scale, 114 * m6Scale, 114 * m6Scale);
    }
    return _appointBtn;
}
- (void)cellForModel:(MoneyListModel *)model{
    _titleLabel.text = model.itemName;//标题
    //判断标的状态(新手、定向)
    [self JudgeStatusModel:model];
    //利率
    NSString *rateStr = [NSString stringWithFormat:@"%.1f%@", model.itemRate.doubleValue, @"%"];
    _rateLabel.attributedText = [self MutableString:rateStr andLeftRange:NSMakeRange(rateStr.length-1, 1) leftFont:30 andOrigaFont:54];//
    //增加利率
    if (model.itemAddRate.floatValue>0) {
      /*  _rateLabel.text = [NSString stringWithFormat:@"%.1f%@+%.1f%@", model.itemRate.floatValue,@"%", model.itemAddRate.floatValue, @"%"];//年化利率
        NSString *leftStr = [NSString stringWithFormat:@"%@+%.1f%@", @"%",model.itemAddRate.floatValue, @"%"];
        NSMutableAttributedString *string = [self MutableString:_rateLabel.text andLeftRange:NSMakeRange(_rateLabel.text.length-leftStr.length, leftStr.length) leftFont:30];
        _rateLabel.attributedText = string;*/
        _addRateLabel.text = [NSString stringWithFormat:@"+%.1f%@", model.itemAddRate.doubleValue, @"%"];

        NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:_addRateLabel.text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:40*m6Scale]}];
        [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24*m6Scale] range:[_addRateLabel.text rangeOfString:@"%"]];
        _addRateLabel.attributedText = att;

        //_addRateLabel.attributedText = [self MutableString:_addRateLabel.text andLeftRange:[_addRateLabel.text rangeOfString:@"%"] leftFont:24 andOrigaFont:40];//
        [Factory ChangeSize:@"%" andLabel:_addRateLabel size:24];
    }else{
        _addRateLabel.text = @"";
    }
    NSInteger status = model.itemStatus.integerValue;
    //抢购状态
    if (status == 0 || status == 1 || status == 2) {
        //等待开放
    }else if (status == 18 || status == 20 || status == 23){
        //_buyLabel.text = @"已满标";
        _waveProgressView.hidden = YES;
        self.imgView.hidden = NO;
        self.imgView.image = [UIImage imageNamed:@"item_已满标@2x(2)"];
    }else if(status == 30 || status == 31 || status == 32){
        _waveProgressView.hidden = YES;
        self.imgView.hidden = NO;
        self.imgView.image = [UIImage imageNamed:@"还款中1"];
    }else if(status == 10){
        _waveProgressView.hidden = NO;
        self.imgView.hidden = YES;
        self.imgView.image = [UIImage imageNamed:@""];
    }else if(status == 13 || status == 14){
        _waveProgressView.hidden = YES;
        self.imgView.hidden = NO;
        self.imgView.image = [UIImage imageNamed:@"流标1"];
    }
    //判断开抢状态
    if (model.itemStatus.integerValue == 1) {
        if ([model.appointId integerValue] == 0) {
            _waveProgressView.numberLabel.text = @"预约";
        }
        else{
            _waveProgressView.numberLabel.text = @"已预约";
        }
        _waveProgressView.hidden = NO;
        self.imgView.hidden = YES;
        _waveProgressView.numberLabel.textColor = [UIColor colorWithRed:220/255.0 green:0.0 blue:0.0 alpha:1.0];
        _waveProgressView.percent = 0;
        [_waveProgressView startWave];
        //标几点开抢
        _buyLabel.text = [NSString stringWithFormat:@"%@开抢", [Factory stdTimeyyyyMMddFromNumer:model.releaseTime andtag:4]];
        self.appointBtn.hidden = NO;
    }else{
        self.appointBtn.hidden = YES;
        _buyLabel.text = [NSString stringWithFormat:@""];
        if (model.itemScale.integerValue < 70) {
            _waveProgressView.numberLabel.textColor = [UIColor colorWithRed:220/255.0 green:0.0 blue:0.0 alpha:1.0];
        }else{
            _waveProgressView.numberLabel.textColor = [UIColor whiteColor];
        }
        CGFloat scale = model.itemScale.integerValue/100.0;
        NSString *sca = [NSString stringWithFormat:@"%.2f", scale];
        //水波纹百分比
        _waveProgressView.numberLabel.text = [NSString stringWithFormat:@"%@%@", [Factory stringByNotRounding:model.itemScale.doubleValue afterPoint:1], @"%"];
        _waveProgressView.percent = sca.floatValue;
        [_waveProgressView startWave];
    }
    //期限
    //首先确定期限单位
    NSString *dataUnit = @"";
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
            dataUnit = @"天";
            break;
    }
    NSString *dataStr = [NSString stringWithFormat:@"%@%@", model.itemCycle, dataUnit];
    NSMutableAttributedString *mutaString = [self MutableString:dataStr andLeftRange:[dataStr rangeOfString:dataUnit] leftFont:30 andOrigaFont:54];//期限
    [self String:mutaString andChangeColorString:dataStr andLabel:_dataLabel andcolorStr:dataUnit];
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
 同一个label改变字体大小(可自定义改变字体大小)
 */
- (NSMutableAttributedString *)MutableString:(NSString *)string andLeftRange:(NSRange)leftrange leftFont:(CGFloat)leftFont andOrigaFont:(CGFloat)origaFont{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    //设置某个范围内的字体大小
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:origaFont*m6Scale] range:NSMakeRange(0, string.length)];
    //设置某个范围内的字体大小
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:leftFont*m6Scale] range:leftrange];
    
    return str;
}
/**
 中间字体颜色的改变(万全)
 */
- (void)String:(NSMutableAttributedString *)string andChangeColorString:(NSString *)str andLabel:(UILabel *)label andcolorStr:(NSString *)colorStr{
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:[str rangeOfString:colorStr]];
    label.attributedText = string;
}

/**
 *判断标的状态(新手、定向)
 */
- (void)JudgeStatusModel:(MoneyListModel *)model{
    //首先判断新手标
    if (model.itemIsnew.integerValue == 0) {
        //会员标
        if (model.isExclusive.integerValue == 0) {
            //定向标
            if (model.password.integerValue == 0) {
                //推荐
                if (model.itemIsrecommend.integerValue == 0) {
                    if (model.moveVip.integerValue) {
                        //App专享
                        _iconImgView.image = [UIImage imageNamed:@"appZX"];
                    }else{
                        _iconImgView.image = [UIImage imageNamed:@""];
                    }
                }else{
                    _iconImgView.image = [UIImage imageNamed:@"rmtj"];
                }
            }else{
                //定向标
                _iconImgView.image = [UIImage imageNamed:@"dxzx"];
            }
        }else{
            //会员标
            _iconImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"Wallet_v%ld", model.isExclusive.integerValue]];
        }
    }else{
        //新手标
        _iconImgView.image = [UIImage imageNamed:@"xszx"];
    }
}
@end
