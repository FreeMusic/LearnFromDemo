//
//  InstantMessageCell.m
//  CityJinFu
//
//  Created by 姜姜敏 on 16/8/25.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "InstantMessageCell.h"

@interface InstantMessageCell ()

@property(nonatomic, strong) UIView *slider;

@end

@implementation InstantMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //标题标签
        _titleLabel = [Factory CreateLabelWithTextColor:0.6 andTextFont:36 andText:@"往期年化" addSubView:self.contentView];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(30*m6Scale);
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
        }];
        //利率标签
        _rateLabel = [Factory CreateLabelWithTextColor:1 andTextFont:70 andText:@"10.2%" addSubView:self.contentView];
        _rateLabel.textColor = UIColorFromRGB(0xff5933);
        [_rateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_titleLabel.mas_bottom).offset(15*m6Scale);
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
        }];
        _rateLabel.attributedText = [self NSMutableAttributedStringWithString:@"10.2%" andLeftRange:NSMakeRange(0, 0) andRightRange:NSMakeRange(4, 1)];
        //起投金额、还款方式标签
        _styleLabel = [Factory CreateLabelWithTextColor:0.5 andTextFont:36 andText:@"100元起投   一次性还款" addSubView:self.contentView];
        [_styleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_rateLabel.mas_bottom).offset(15*m6Scale);
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
        }];
        //项目期限
        _dataLable = [Factory CreateLabelWithTextColor:0.2 andTextFont:26 andText:@"项目期限：30天" addSubView:self.contentView];
        [_dataLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-36*m6Scale);
            make.left.mas_equalTo(20*m6Scale);
        }];
        //可投金额
        _accountLabel = [Factory CreateLabelWithTextColor:0.2 andTextFont:26 andText:@"可投金额：17380元" addSubView:self.contentView];
        [_accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-36*m6Scale);
            make.right.mas_equalTo(-20*m6Scale);
        }];
        //背景条
        _slider = [[UIView alloc] init];
        _slider.backgroundColor = Colorful(234, 236, 236);
        [self.contentView addSubview:_slider];
        [_slider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20*m6Scale);
            make.top.mas_equalTo(_styleLabel.mas_bottom).offset(60*m6Scale);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth-40*m6Scale, 6*m6Scale));
        }];
        //进度条
        _progress = [[UIView alloc] init];
        _progress.backgroundColor = UIColorFromRGB(0xffb514);
        [_slider addSubview:_progress];
        //进度标签
        _progressLabel = [Factory CreateLabelWithTextColor:1 andTextFont:36 andText:@"" addSubView:self.contentView];
        _progressLabel.textColor = ButtonColor;
        _progressLabel.textAlignment = NSTextAlignmentRight;
    }
    
    return self;
}
/**
 *进度条
 */
- (void)progressWithPercent:(CGFloat)percent{
    [_progress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(6*m6Scale);
        make.width.mas_equalTo((kScreenWidth-40*m6Scale)*percent);
    }];
    //进度标签
    _progressLabel.text = [NSString stringWithFormat:@"%.1f%@", percent*100, @"%"];
    if (percent > 0.13){
        [_progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_progress.mas_right);
            make.bottom.mas_equalTo(_progress.mas_top).offset(-10*m6Scale);
        }];
    }else{
        [_progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20*m6Scale);
            make.bottom.mas_equalTo(_progress.mas_top).offset(-10*m6Scale);
        }];
    }
}
- (NSMutableAttributedString *)NSMutableAttributedStringWithString:(NSString *)string andLeftRange:(NSRange)leftrange andRightRange:(NSRange)rightrange{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    //设置某个范围内的字体大小
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:40*m6Scale] range:leftrange];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:40*m6Scale] range:rightrange];
    
    return str;
}
- (void)cellForModel:(ItemDetailsModel *)model{
    //利率
    _rateLabel.text = [NSString stringWithFormat:@"%.1f%@", model.itemRate.floatValue+model.itemAddRate.floatValue, @"%"];
    _rateLabel.attributedText = [self NSMutableAttributedStringWithString:_rateLabel.text andLeftRange:NSMakeRange(0, 0) andRightRange:NSMakeRange(_rateLabel.text.length-1, 1)];
    //起投金额  还款方式
    //还款方式
    NSString *type = nil;
    switch (model.itemRepayMethod.integerValue) {
        case 1:
            //一次性还款
            type = @"一次性还款";
            break;
        case 2:
            //等额本息
            type = @"等额本息";
            break;
        case 3:
            //先息后本
            type = @"先息后本";
            break;
        case 4:
            //每日付息
            type = @"每日付息";
            break;
            
        default:
            type = @"一次性还款";
            break;
    }
    _styleLabel.text = [NSString stringWithFormat:@"%@元起投  %@", model.itemSingleMinInvestment, type];
    if (model.itemAccount.integerValue) {
        //进度条
        [self progressWithPercent:model.itemOngoingAccount.floatValue/model.itemAccount.floatValue];
    }
    //时间期限
    NSString *dataUnit = nil;
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
    _dataLable.text = [NSString stringWithFormat:@"项目期限：%@%@", model.itemCycle, dataUnit];
    //可投金额
    _accountLabel.text = [NSString stringWithFormat:@"可投金额%ld元", model.itemAccount.integerValue-model.itemOngoingAccount.integerValue];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
