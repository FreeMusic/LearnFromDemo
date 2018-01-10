//
//  PlanDetailsView.m
//  CityJinFu
//
//  Created by mic on 2017/7/16.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "PlanDetailsView.h"

@implementation PlanDetailsView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //布局
        [self layoutView];
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}
/**
 *锁定时间的标签
 */
- (UILabel *)timeLabel{
    if(!_timeLabel){
        _timeLabel = [Factory CreateLabelWithTextColor:1 andTextFont:28 andText:@"10天" addSubView:self];
        _timeLabel.textColor = UIColorFromRGB(0x393939);
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}
/**
 *锁定本金的标签
 */
- (UILabel *)amountLabel{
    if(!_amountLabel){
        _amountLabel = [Factory CreateLabelWithTextColor:1 andTextFont:28 andText:@"6000.00" addSubView:self];
        _amountLabel.textColor = UIColorFromRGB(0x393939);
        _amountLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _amountLabel;
}

/**
 *往期年化的标签
 */
- (UILabel *)rateLabel{
    if(!_rateLabel){
        _rateLabel = [Factory CreateLabelWithTextColor:1 andTextFont:28 andText:@"8.9%" addSubView:self];
        _rateLabel.textColor = UIColorFromRGB(0x393939);
        _rateLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _rateLabel;
}
/**
 *加入时间标签的懒加载
 */
- (UILabel *)joinLabel{
    if(!_joinLabel){
        _joinLabel = [Factory CreateLabelWithTextColor:1 andTextFont:24 andText:@"2017-05-03 加入" addSubView:self];
        _joinLabel.textAlignment = NSTextAlignmentCenter;
        _joinLabel.textColor = UIColorFromRGB(0x9d9d9d);
    }
    return _joinLabel;
}
/**
 *布局
 */
- (void)layoutView{
    //灰色背景
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 76*m6Scale)];
    backView.backgroundColor = backGroundColor;
    [self addSubview:backView];
    CGFloat width = kScreenWidth/3;
    //循环创建三个标签
    NSArray *array = @[@"锁定时间", @"锁定本金", @"往期年化"];
    for (int i = 0; i < array.count; i++) {
        UILabel *label = [Factory CreateLabelWithTextColor:1 andTextFont:26 andText:array[i] addSubView:self];
        label.textColor = UIColorFromRGB(0x9d9d9d);
        label.textAlignment = NSTextAlignmentCenter;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(width*i);
            make.width.mas_equalTo(width);
            make.centerY.mas_equalTo(backView.mas_centerY);
        }];
        if (i == 0) {
            //锁定时间
            [self layoutBottmViewByLabel:label OtherLabel:self.timeLabel];
        }else if (i == 1){
            //锁定本金
            [self layoutBottmViewByLabel:label OtherLabel:self.amountLabel];
        }else{
            //往期年化
            [self layoutBottmViewByLabel:label OtherLabel:self.rateLabel];
        }
    }
    //加入时间
    [self.joinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(-16*m6Scale);
        make.width.mas_equalTo(width);
    }];
}
/**
 *下部View的布局
 */
- (void)layoutBottmViewByLabel:(UILabel *)label OtherLabel:(UILabel *)otherLabel{
    [otherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label.mas_left);
        make.width.mas_equalTo(kScreenWidth/3);
        make.top.mas_equalTo(label.mas_bottom).offset(50*m6Scale);
    }];
}

@end
