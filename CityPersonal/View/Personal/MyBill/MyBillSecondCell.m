//
//  MyBillSecondCell.m
//  CityJinFu
//
//  Created by xxlc on 17/5/25.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "MyBillSecondCell.h"

@implementation MyBillSecondCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatView];
    }
    return self;
}
/**
 布局
 */
- (void)creatView{
    [self.contentView addSubview:self.leftlab];
    [self.contentView addSubview:self.rightlab];
    [self.contentView addSubview:self.balancelab];
    [self.contentView addSubview:self.totallab];
    [self.contentView addSubview:self.incomlab];
    [self.contentView addSubview:self.toplab];
    [self.contentView addSubview:self.withdrawlab];
    //标题
    [_leftlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(20*m6Scale);
        make.top.equalTo(self.contentView.mas_top).offset(20*m6Scale);
        make.width.mas_equalTo(kScreenWidth/2);
    }];
    [_rightlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-20*m6Scale);
        make.top.equalTo(self.contentView.mas_top).offset(20*m6Scale);
        make.width.mas_equalTo(kScreenWidth/2);
    }];
    //灰线
    CALayer *messageLayer = [[CALayer alloc] init];
    messageLayer.frame = CGRectMake(30*m6Scale, 80 * m6Scale, kScreenWidth - 80*m6Scale, 0.5);
    messageLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.contentView.layer addSublayer:messageLayer];
    //余额
    [_balancelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-kScreenWidth/2-20*m6Scale);
        make.top.equalTo(self.contentView.mas_top).offset(80*m6Scale);
        make.height.mas_equalTo(80*m6Scale);
    }];
    //充值
    [_toplab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-20*m6Scale);
        make.top.equalTo(self.contentView.mas_top).offset(80*m6Scale);
        make.height.mas_equalTo(80*m6Scale);
    }];
    //总资产
    [_totallab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-kScreenWidth/2-20*m6Scale);
        make.top.equalTo(_balancelab.mas_bottom);
        make.height.mas_equalTo(80*m6Scale);
    }];
    //提现
    [_withdrawlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-20*m6Scale);
        make.top.equalTo(_toplab.mas_bottom);
        make.height.mas_equalTo(80*m6Scale);
    }];
    //收益
    [_incomlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-kScreenWidth/2-20*m6Scale);
        make.top.equalTo(_totallab.mas_bottom);
        make.height.mas_equalTo(80*m6Scale);
    }];
    //灰线
    CALayer *centerLayer = [[CALayer alloc] init];
    centerLayer.frame = CGRectMake(kScreenWidth/2, 90 * m6Scale, 0.5, 220*m6Scale);
    centerLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.contentView.layer addSublayer:centerLayer];
    NSArray *leftArr = @[@"当前余额", @"当前总额", @"收益总额"];
    for (int i = 0; i < leftArr.count; i++) {
        UILabel *label = [Factory CreateLabelWithTextColor:0 andTextFont:30 andText:leftArr[i] addSubView:self.contentView];
        label.textColor = [UIColor lightGrayColor];
        if (i == 0) {
            [self layOutLabel:label byLabel:_balancelab type:1];
        }else if (i == 1){
            [self layOutLabel:label byLabel:_totallab type:1];
        }else{
            [self layOutLabel:label byLabel:_incomlab type:1];
        }
    }
    NSArray *rightArr = @[@"充值", @"提现"];
    for (int i = 0; i < rightArr.count; i++) {
        UILabel *label = [Factory CreateLabelWithTextColor:0 andTextFont:30 andText:rightArr[i] addSubView:self.contentView];
        label.textColor = [UIColor lightGrayColor];
        if (i == 0) {
            [self layOutLabel:label byLabel:_toplab type:0];
        }else if (i == 1){
            [self layOutLabel:label byLabel:_withdrawlab type:0];
        }
    }
}
/**
 *生成标签
 */
- (void)layOutLabel:(UILabel *)label byLabel:(UILabel *)otherLabel type:(NSInteger)type{
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        if (type) {
            make.left.mas_equalTo(20*m6Scale);
        }else{
            make.left.mas_equalTo(kScreenWidth/2+10*m6Scale);
        }
        make.top.mas_equalTo(otherLabel.mas_top);
        make.height.mas_equalTo(80*m6Scale);
    }];
}
/**
 本月总览
 */
- (UILabel *)leftlab{
    if (!_leftlab) {
        _leftlab = [UILabel new];
        _leftlab.text = @"本月总览";
        _leftlab.textColor = BlackColor;
        _leftlab.textAlignment = NSTextAlignmentCenter;
        _leftlab.font = [UIFont systemFontOfSize:40*m6Scale];
    }
    return _leftlab;
}
/**
 本月充值提现
 */
- (UILabel *)rightlab{
    if (!_rightlab) {
        _rightlab = [UILabel new];
        _rightlab.text = @"本月充值提现";
        _rightlab.textColor = BlackColor;
        _rightlab.textAlignment = NSTextAlignmentCenter;
        _rightlab.font = [UIFont systemFontOfSize:40*m6Scale];
    }
    return _rightlab;
}
/**
 当前余额(元)
 */
- (UILabel *)balancelab{
    if (!_balancelab) {
        _balancelab = [self commitLab:@"当前余额: 100.00"];
        _balancelab.textAlignment = NSTextAlignmentRight;
    }
    return _balancelab;
}
/**
 当前总资产(元)
 */
- (UILabel *)totallab{
    if (!_totallab) {
        _totallab = [self commitLab:@"当前总额: 1000.00"];
        _totallab.textAlignment = NSTextAlignmentRight;
    }
    return _totallab;
}
/**
 累计收益(元)
 */
- (UILabel *)incomlab{
    if (!_incomlab) {
        _incomlab = [self commitLab:@"收益总额: 100.00"];
        _incomlab.textAlignment = NSTextAlignmentRight;
        
    }
    return _incomlab;
}
/**
 充值(元)
 */
- (UILabel *)toplab{
    if (!_toplab) {
        _toplab = [self commitLab:@"充值: 1000.00"];
        _toplab.textAlignment = NSTextAlignmentLeft;
    }
    return _toplab;
}
/**
 提现(元)
 */
- (UILabel *)withdrawlab{
    if (!_withdrawlab) {
        _withdrawlab = [self commitLab:@"提现: 1000.00"];
        _withdrawlab.textAlignment = NSTextAlignmentLeft;
    }
    return _withdrawlab;
}

/**
 公共label
 */
- (UILabel *)commitLab:(NSString *)text{
    UILabel *titleLab = [UILabel new];
    titleLab.text = text;
    titleLab.font = [UIFont systemFontOfSize:30*m6Scale];
    titleLab.textColor = [UIColor lightGrayColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    
    return titleLab;
}
- (void)cellForModel:(BillIndexModel *)model{
    _balancelab.text = [NSString stringWithFormat:@"%.2f", model.cash.doubleValue];//当前余额
    _totallab.text =[NSString stringWithFormat:@"%.2f", model.total.doubleValue] ;//当前总额
    _incomlab.text =[NSString stringWithFormat:@"%.2f", model.income.doubleValue];//累计收益
    _toplab.text =[NSString stringWithFormat:@"%.2f", model.countRecharge.doubleValue]; //充值
    _withdrawlab.text = [NSString stringWithFormat:@"%.2f", model.countCash.doubleValue];//提现
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
