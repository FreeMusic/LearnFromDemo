//
//  PlanDetailsCell.m
//  CityJinFu
//
//  Created by mic on 2017/7/16.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "PlanDetailsCell.h"

@implementation PlanDetailsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = NO;
        CGFloat width = kScreenWidth/3;
        NSArray *textArr = @[@"投资本金(元)", @"预期收益(元)", @"投资时间"];
        for (int i = 0; i < textArr.count; i++) {
            //需要循环创建的一个标签
            UILabel *label = [Factory CreateLabelWithTextColor:1 andTextFont:24 andText:textArr[i] addSubView:self.contentView];
            label.tag = 1000+i;
            label.textColor = UIColorFromRGB(0x969696);
            label.textAlignment = NSTextAlignmentCenter;
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(i%3*width);
                make.width.mas_equalTo(width);
                make.bottom.mas_equalTo(-12*m6Scale);
            }];
            if (i == 0) {
                //投资本金
                [self setFrameByLabel:label andOrigialLable:self.amountLabel];
            }else if (i == 1){
                //预期收益
                [self setFrameByLabel:label andOrigialLable:self.incomeLabel];
            }else{
                //投资时间
                [self setFrameByLabel:label andOrigialLable:self.timeLabel];
            }
        }
    }
    return self;
}
/**
 *投资本金
 */
- (UILabel *)amountLabel{
    if(!_amountLabel){
        _amountLabel = [self commonLabel];
    }
    return _amountLabel;
}
/**
 *预期收益
 */
- (UILabel *)incomeLabel{
    if(!_incomeLabel){
        _incomeLabel = [self commonLabel];
    }
    return _incomeLabel;
}
/**
 *投资时间
 */
- (UILabel *)timeLabel{
    if(!_timeLabel){
        _timeLabel = [self commonLabel];
    }
    return _timeLabel;
}
/**
 *位置
 */
- (void)setFrameByLabel:(UILabel *)label andOrigialLable:(UILabel *)origialLable{
    [origialLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label.mas_left);
        make.width.mas_equalTo(kScreenWidth/3);
        make.top.mas_equalTo(12*m6Scale);
    }];
}
/**
 *公共标签
 */
- (UILabel *)commonLabel{
    UILabel *label = [Factory CreateLabelWithTextColor:1 andTextFont:28 andText:@"1000.00" addSubView:self.contentView];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = UIColorFromRGB(0x393939);
    
    return label;
}

@end
