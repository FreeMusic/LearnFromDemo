//
//  TopWithDrawalCell.m
//  CityJinFu
//
//  Created by xxlc on 16/10/14.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "TopWithDrawalCell.h"


@implementation TopWithDrawalCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifie{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifie]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self creatView];//创建布局
    }
    return self;
}

/**
 创建布局
 */
- (void)creatView{
    //时间
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.text = @"2016-10-14\n12:24:35";
    _timeLabel.textColor = [UIColor lightGrayColor];
    _timeLabel.font = [UIFont systemFontOfSize:30*m6Scale];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20*m6Scale);
        make.bottom.equalTo(-20*m6Scale);
    }];
    //状态
    _statusLabel = [Factory CreateLabelWithTextColor:1.0 andTextFont:28 andText:@"充值成功" addSubView:self.contentView];
    _statusLabel.textAlignment = NSTextAlignmentCenter;
    _statusLabel.textColor = UIColorFromRGB(0x393939);
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(20*m6Scale);
        make.top.equalTo(20*m6Scale);
    }];
    //投资金额
    _moneyLabel = [[UILabel alloc]init];
//    _moneyLabel.text = @"500元";
    _moneyLabel.textColor = UIColorFromRGB(0x393939);
    _moneyLabel.font = [UIFont systemFontOfSize:35*m6Scale];
    [self.contentView addSubview:_moneyLabel];
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(-20*m6Scale);
    }];
}
/**
 *  支付公司的名称
 */
- (UILabel *)typeLabel{
    if(!_typeLabel){
        _typeLabel = [Factory CreateLabelWithColor:UIColorFromRGB(0xA09f9f) andTextFont:26 andText:@"" addSubView:self.contentView];
        [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-20*m6Scale);
            make.right.mas_equalTo(-20*m6Scale);
        }];
    }
    return _typeLabel;
}

- (void)cellForDictionary:(NSDictionary *)dictionary{
    [_moneyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20*m6Scale);
        make.right.mas_equalTo(-20*m6Scale);
    }];
    
    _moneyLabel.text = [NSString stringWithFormat:@"+%@元", [Factory countNumAndChange:[NSString stringWithFormat:@"%d",[dictionary[@"rechargeAmount"] intValue]]]];//金额
    NSString *status;
    if ([dictionary[@"rechargeStatus"] isEqualToNumber:@0]) {
        status = @"充值失败";
    }else if ([dictionary[@"rechargeStatus"] isEqualToNumber:@1]) {
        status = @"充值成功";
    }else {
        status = @"审核中";
    }
    _statusLabel.text = status;//状态
    NSString *time = [NSString stringWithFormat:@"%@",dictionary[@"addtime"]];
    _timeLabel.text = [Factory transClipDateWithStr:time];//时间
    NSString *alias = [NSString stringWithFormat:@"%@", dictionary[@"alias"]];
    if ([Factory theidTypeIsNull:alias]) {
        self.typeLabel.text = @"";
    }else{
        self.typeLabel.text = [NSString stringWithFormat:@"%@", alias];//支付公司的名称
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
