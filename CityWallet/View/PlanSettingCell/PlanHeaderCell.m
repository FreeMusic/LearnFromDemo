//
//  PlanHeaderCell.m
//  CityJinFu
//
//  Created by mic on 2017/7/13.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "PlanHeaderCell.h"

@implementation PlanHeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = ButtonColor;
        self.selectionStyle = NO;
        //利率标签
        _rateLabel = [Factory CreateLabelWithTextColor:1 andTextFont:100 andText:@"10.8%" addSubView:self.contentView];
        _rateLabel.textColor = UIColorFromRGB(0xffffff);
        [_rateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(45*m6Scale);
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
        }];
        //往期年化
        _yearLabel = [Factory CreateLabelWithTextColor:1 andTextFont:30 andText:@"往期年化" addSubView:self.contentView];
        _yearLabel.textColor = UIColorFromRGB(0xFFF0CF);
        [_yearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_rateLabel.mas_bottom).offset(13*m6Scale);
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
        }];
        //到期自动退出  锁投期限
        _cycleLabel = [Factory CreateLabelWithTextColor:1 andTextFont:26 andText:@"到期自动退出  |  锁投期限 3个月" addSubView:self.contentView];
        [_cycleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-54*m6Scale);
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
        }];
        //加息标签
        _addLabel = [Factory CreateLabelWithTextColor:1 andTextFont:30 andText:@"+1.0%" addSubView:self.contentView];
        _addLabel.textColor = [UIColor colorWithRed:106/255.0 green:75.0/255.0 blue:19.0/255.0 alpha:1.0];
        [_addLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_rateLabel.mas_right).offset(-10*m6Scale);
            make.bottom.mas_equalTo(_rateLabel.mas_top).offset(20*m6Scale);
        }];
    }
    
    return self;
}

- (void)setModel:(PlanSetModel *)model{
    //利率
    _rateLabel.text = [NSString stringWithFormat:@"%.1f%@", model.planRate.floatValue, @"%"];
    [Factory ChangeSize:@"%" andLabel:_rateLabel size:48];
    //期限
    NSString *date = @"";
    switch (model.planCycle.integerValue) {
        case 90:
            date = @"3个月";
            break;
        case 180:
            date = @"6个月";
            break;
        case 360:
            date = @"12个月";
            break;
            
        default:
            date = @"3个月";
            break;
    }
    _cycleLabel.text = [NSString stringWithFormat:@"到期自动退出  |  锁投期限 %@", date];
    //加息标签
    if (model.planAddRate.integerValue) {
        _addLabel.hidden = NO;
        _addLabel.text = [NSString stringWithFormat:@"+%.1f%@", model.planAddRate.floatValue, @"%"];
    }else{
        _addLabel.hidden = YES;
    }
}

@end
