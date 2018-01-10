//
//  PersonalPlanCell.m
//  CityJinFu
//
//  Created by mic on 2017/7/14.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "PersonalPlanCell.h"

@interface PersonalPlanCell ()

@property (nonatomic, strong) UILabel *nilLabel;//空白标签

@end

@implementation PersonalPlanCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = NO;
        CGFloat width = kScreenWidth/3;
        NSArray *textArr = @[@"锁定本金", @"锁定期限", @"锁定日期"];
        for (int i = 0; i < textArr.count; i++) {
            //需要循环创建的一个标签
            UILabel *label = [Factory CreateLabelWithTextColor:1 andTextFont:24 andText:textArr[i] addSubView:self.contentView];
            label.tag = 1000+i;
            label.textColor = UIColorFromRGB(0x969696);
            label.textAlignment = NSTextAlignmentCenter;
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(i%3*width);
                make.width.mas_equalTo(width);
                make.bottom.mas_equalTo(-20*m6Scale);
            }];
            if (i == 0) {
                //锁定本金
                [self setFrameByLabel:label andOrigialLable:self.amountLabel];
            }else if (i == 1){
                //锁定期限
                [self setFrameByLabel:label andOrigialLable:self.dateLabel];
            }else{
                [self setFrameByLabel:label andOrigialLable:self.timeLabel];
            }
        }
    }
    [self.nilLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    return self;
}
/**
 *锁定本金
 */
- (UILabel *)amountLabel{
    if(!_amountLabel){
        _amountLabel = [self commonLabel];
    }
    return _amountLabel;
}
/**
 *锁定期限
 */
- (UILabel *)dateLabel{
    if(!_dateLabel){
        _dateLabel = [self commonLabel];
    }
    return _dateLabel;
}
/**
 *锁定日期
 */
- (UILabel *)timeLabel{
    if(!_timeLabel){
        _timeLabel = [self commonLabel];
    }
    return _timeLabel;
}
/**
 *空白标签
 */
- (UILabel *)nilLabel{
    if(!_nilLabel){
        _nilLabel = [Factory CreateLabelWithTextColor:1 andTextFont:24 andText:@"暂无计划" addSubView:self.contentView];
        _nilLabel.textColor = UIColorFromRGB(0x969696);
        _nilLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nilLabel;
}
/**
 *位置
 */
- (void)setFrameByLabel:(UILabel *)label andOrigialLable:(UILabel *)origialLable{
    [origialLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label.mas_left);
        make.width.mas_equalTo(kScreenWidth/3);
        make.top.mas_equalTo(25*m6Scale);
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

- (void)cellForModel:(MyPlanModel *)model{
    if (model == nil) {
        //
        self.nilLabel.hidden = NO;
        self.amountLabel.hidden = YES;
        self.dateLabel.hidden = YES;
        self.timeLabel.hidden = YES;
        for (int i = 0; i < 3; i++) {
            UILabel *label = (UILabel *)[self.contentView viewWithTag:1000+i];
            label.hidden = YES;
        }
    }else{
        self.nilLabel.hidden = YES;
        self.amountLabel.hidden = NO;
        self.dateLabel.hidden = NO;
        self.timeLabel.hidden = NO;
        for (int i = 0; i < 3; i++) {
            UILabel *label = (UILabel *)[self.contentView viewWithTag:1000+i];
            label.hidden = NO;
        }
        //锁定本金
        self.amountLabel.text = [NSString stringWithFormat:@"%@", model.itemAmount];
        //锁定期限
        NSString *date = @"";
        switch (model.itemLockCycle.integerValue) {
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
        self.dateLabel.text = date;
        //锁定期限
        self.timeLabel.text = [Factory stdTimeyyyyMMddFromNumer:model.addtime andtag:53];
    }
}

@end
