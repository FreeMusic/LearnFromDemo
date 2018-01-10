//
//  MyBillRecordCell.m
//  CityJinFu
//
//  Created by mic on 2017/6/7.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "MyBillRecordCell.h"

@implementation MyBillRecordCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle: style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = Colorful(241, 242, 243);
        self.selectionStyle = NO;
        CGFloat width = kScreenWidth/4;
        //期数标签
        _dataLabel = [self CreateLabelWithTitle:@"期数" andDistance:0];
        //时间标签
        _timeLabel = [self CreateLabelWithTitle:@"时间" andDistance:width];
        //本金标签
        _capitalLabel = [self CreateLabelWithTitle:@"本金" andDistance:width*2];
        //利息标签
        _rateLabel = [self CreateLabelWithTitle:@"利息" andDistance:width*3];
    }
    return self;
}

- (UILabel *)CreateLabelWithTitle:(NSString *)title andDistance:(CGFloat)width{
    CGFloat width1 = kScreenWidth/4;
    UILabel *label = [Factory CreateLabelWithTextColor:0.2 andTextFont:26 andText:title addSubView:self.contentView];
    label.textAlignment = NSTextAlignmentCenter;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(width);
        make.width.mas_equalTo(width1);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    return label;
}
- (void)cellForModel:(CollectListModel *)model IndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row > 0) {
        _dataLabel.text = [NSString stringWithFormat:@"%@", model.collectCurrentPeriod];//期数
        _timeLabel.text = [Factory stdTimeyyyyMMddFromNumer:model.collectTime andtag:53];//时间
        _capitalLabel.text = [NSString stringWithFormat:@"%.2f", model.collectPrincipal.floatValue];//本金
        _rateLabel.text = [NSString stringWithFormat:@"%.2f", model.collectInterest.floatValue];//利息
        if (model.collectStatus.integerValue) {
            [self changeLabelColor:UIColorFromRGB(0xaeaeae)];
        }else{
            [self changeLabelColor:UIColorFromRGB(0x3a3a3a)];
        }
    }
}
/**
 *改变字体颜色
 */
- (void)changeLabelColor:(UIColor *)color{
    _dataLabel.textColor = color;//期数
    _timeLabel.textColor = color;//时间
    _capitalLabel.textColor = color;//本金
    _rateLabel.textColor = color;//利息
}

@end
