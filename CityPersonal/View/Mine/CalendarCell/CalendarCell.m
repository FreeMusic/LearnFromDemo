//
//  CalendarCell.m
//  CityJinFu
//
//  Created by mic on 2017/9/27.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "CalendarCell.h"

@interface CalendarCell ()

@property (nonatomic, strong) UIView *backView;//白色view
@property (nonatomic, strong) UILabel *titleLabel;//标题
@property (nonatomic, strong) UILabel *statusLabel;//状态
@property (nonatomic, strong) UILabel *amountLabel;//总金额
@property (nonatomic, strong) UILabel *incomeLabel;//收益
@property (nonatomic, strong) UILabel *timeLabel;//时间

@end

@implementation CalendarCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = backGroundColor;
        self.selectionStyle = NO;
        
        //空白View
        [self.contentView addSubview:self.backView];
        
        //中间灰线
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 66*m6Scale, kScreenWidth, 1)];
        line.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.3];
        [self.contentView addSubview:line];
        
        //标题
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(19*m6Scale);
            make.left.mas_equalTo(20*m6Scale);
        }];
        
        //状态
        [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20*m6Scale);
            make.right.mas_equalTo(-20*m6Scale);
        }];
        
        CGFloat width = kScreenWidth/3;//三分屏幕
        NSArray *array = @[@"投资本金(元)", @"预期收益(元)", @"投资时间"];
        
        for (int i = 0; i < array.count; i++) {
            ////固定文字
            UILabel *label = [Factory CreateLabelWithTextColor:1 andTextFont:26 andText:array[i] addSubView:self.backView];
            label.textColor = UIColorFromRGB(0x969696);
            label.tag = i+1000;
            label.textAlignment = NSTextAlignmentCenter;
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(width*i);
                make.width.mas_equalTo(width);
                make.bottom.mas_equalTo(-20*m6Scale);
            }];
            
            if (i == 0) {
                //本金
                [self layoutLabel:self.amountLabel index:i referLabel:label];
            }else if (i == 1){
                //收益
                [self layoutLabel:self.incomeLabel index:i referLabel:label];
            }else{
                //时间
                [self layoutLabel:self.timeLabel index:i referLabel:label];
            }
        }
    }
    
    return self;
}
/**
 * backView的懒加载
 */
- (UIView *)backView{
    if(!_backView){
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 192*m6Scale)];
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}
/**
 * 标题
 */
- (UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [Factory CreateLabelWithTextColor:1 andTextFont:28 andText:@"分天秤" addSubView:self.backView];
        _titleLabel.textColor = UIColorFromRGB(0x3e3e3e);
    }
    return _titleLabel;
}
/**
 *  投资或回款的状态
 */
- (UILabel *)statusLabel{
    if(!_statusLabel){
        _statusLabel = [Factory CreateLabelWithTextColor:0 andTextFont:26 andText:@"投资成功" addSubView:self.backView];
    }
    return _statusLabel;
}
/**
 *  本金
 */
- (UILabel *)amountLabel{
    if(!_amountLabel){
        _amountLabel = [self makeCommonLabel];
    }
    return _amountLabel;
}
/**
 *  收益
 */
- (UILabel *)incomeLabel{
    if(!_incomeLabel){
        _incomeLabel = [self makeCommonLabel];
    }
    return _incomeLabel;
}
/**
 *  时间
 */
- (UILabel *)timeLabel{
    if(!_timeLabel){
        _timeLabel = [self makeCommonLabel];
    }
    return _timeLabel;
}
/**
 *  创建Label的公共方法
 */
- (UILabel *)makeCommonLabel{
    UILabel *label = [Factory CreateLabelWithTextColor:1 andTextFont:28 andText:@"1000" addSubView:self.backView];
    label.textColor = UIColorFromRGB(0x474747);
    label.textAlignment = NSTextAlignmentCenter;
    
    return label;
}
/**
 *  约束标签
 */
- (void)layoutLabel:(UILabel *)label index:(int)index referLabel:(UILabel *)referLabel{
    CGFloat width = kScreenWidth/3;//三分屏幕
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(width*index);
        make.width.mas_equalTo(width);
        make.bottom.mas_equalTo(referLabel.mas_top).offset(-15*m6Scale);
    }];
}

- (void)cellForModel:(CalendarListModel *)model{
    //标题
    _titleLabel.text = [NSString stringWithFormat:@"%@", model.itemName];
    
    //获取状态
    [self getStatus:model.itemStatus.integerValue type:model.type];
    
    //金额
    _amountLabel.text = [NSString stringWithFormat:@"%.2f", model.amount.doubleValue];
    
    //预期收益
    _incomeLabel.text = [NSString stringWithFormat:@"%.2f", model.futureIncome.doubleValue];
    
    //时间
    _timeLabel.text = [Factory stdTimeyyyyMMddFromNumer:model.addtime andtag:0];
    
    //修改投资和回款类型
    [self changeType:model.type];
}
/**
 *  修改投资和回款类型
 */
- (void)changeType:(NSString *)type{
    
    NSArray *array;
    if ([type isEqualToString:@"投资"]) {
        array = @[@"投资本金(元)", @"预期收益(元)", @"投资时间"];
    }else{
        array = @[@"回款本金(元)", @"回款收益(元)", @"还款时间"];
    }
    
    for (int i = 0; i < array.count; i++) {
        UILabel *label = (UILabel *)[self.contentView viewWithTag:1000+i];
        label.text = array[i];
    }
}
/**
 *  状态（投资状态：0-投资成功 1复审通过 2失败 3-投资已还款） 回款状态（0 还款中 1还款成功）
 */
- (void)getStatus:(NSInteger)status type:(NSString *)type{
    NSString *itemStatus;
    if ([type isEqualToString:@"投资"]) {
        switch (status) {
            case 0:{
                itemStatus = @"投资成功";
            }
                break;
            case 1:{
                itemStatus = @"还款中";
            }
                break;
            case 2:{
                itemStatus = @"投资失败";
            }
                break;
            case 3:{
                itemStatus = @"投资成功";
            }
                break;
                
            default:
                itemStatus = @"投资成功";
                break;
        }
    }
    else{
        switch (status) {
            case 0:{
                _status = Status_Repayment;
                itemStatus = @"还款中";
            }
                break;
            case 1:{
                _status = Status_RepaymentSuccess;
                itemStatus = @"还款成功";
            }
                break;
                
            default:
                _status = Status_Repayment;
                itemStatus = @"还款中";
                break;
        }
    }
    
    if ([itemStatus isEqualToString:@"还款中"] || [itemStatus isEqualToString:@"还款成功"]) {
        _statusLabel.textColor = UIColorFromRGB(0x4aa2fc);
    }else{
        _statusLabel.textColor = UIColorFromRGB(0xff5933);
    }
    _statusLabel.text = itemStatus;
}

@end
