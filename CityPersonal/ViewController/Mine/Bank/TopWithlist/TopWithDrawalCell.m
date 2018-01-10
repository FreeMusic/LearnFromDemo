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
        self.backgroundColor = backGroundColor;
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
    _timeLabel.numberOfLines = 0;
    _timeLabel.font = [UIFont systemFontOfSize:30*m6Scale];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(kScreenWidth/3.3);
    }];
    //状态
    _statusLabel = [Factory CreateLabelWithTextColor:1.0 andTextFont:28 andText:@"充值成功" addSubView:self.contentView];
    _statusLabel.textAlignment = NSTextAlignmentCenter;
    _statusLabel.layer.cornerRadius = 24*m6Scale;
    _statusLabel.layer.masksToBounds = YES;
    _statusLabel.backgroundColor = ButtonColor;
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-40*m6Scale);
        make.size.mas_equalTo(CGSizeMake(160*m6Scale, 48*m6Scale));
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    //投资金额
    _moneyLabel = [[UILabel alloc]init];
//    _moneyLabel.text = @"500元";
    _moneyLabel.textColor = ButtonColor;
    _moneyLabel.font = [UIFont systemFontOfSize:35*m6Scale];
    _moneyLabel.layer.cornerRadius = 29*m6Scale;
    _moneyLabel.textAlignment = NSTextAlignmentCenter;
    _moneyLabel.layer.masksToBounds = YES;
    _moneyLabel.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_moneyLabel];
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2.3, 58*m6Scale));
    }];
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
