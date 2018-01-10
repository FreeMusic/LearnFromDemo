//
//  AwardDetailsCell.m
//  CityJinFu
//
//  Created by mic on 2017/6/12.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "AwardDetailsCell.h"

@implementation AwardDetailsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = NO;
        //明细
        _nameLabel = [self CreateLabelLeftDistance:0 andTitle:@"明细" rate:0];
        //金额
        _amountLabel = [self CreateLabelLeftDistance:kScreenWidth/4+80*m6Scale andTitle:@"金额" rate:0];
        //类型
        _typeLabel = [self CreateLabelLeftDistance:(kScreenWidth/4)*2+80*m6Scale-33*m6Scale andTitle:@"类型" rate:1];
        //是否发放
        _provideLabel = [self CreateLabelLeftDistance:(kScreenWidth/4)*3+100*m6Scale-33*m6Scale*2 andTitle:@"是否发放" rate:0];
    }
    return self;
}
- (UILabel *)CreateLabelLeftDistance:(CGFloat)left andTitle:(NSString *)title rate:(NSInteger)rate{
    UILabel *label = [Factory CreateLabelWithTextColor:0.4 andTextFont:28 andText:title addSubView:self.contentView];
    label.textAlignment = NSTextAlignmentCenter;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(left);
        if (left) {
            if (rate) {
                make.width.mas_equalTo(kScreenWidth/4-15*m6Scale);
            }else{
                make.width.mas_equalTo(kScreenWidth/4-33*m6Scale);
            }
        }else{
            make.width.mas_equalTo(kScreenWidth/4+80*m6Scale);
        }
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    return label;
}

- (void)cellForModel:(AwardDetailsModel *)model{
    _nameLabel.text = [NSString stringWithFormat:@"%@(%@)", model.name, model.type];//明细
    _amountLabel.text = [NSString stringWithFormat:@"%@", model.amount];//奖励金额
    _typeLabel.text = [Factory stdTimeyyyyMMddFromNumer:model.addtime andtag:53];//shijian时间
    _provideLabel.text = [NSString stringWithFormat:@"%@", model.isSend];//是否发放
}
@end
