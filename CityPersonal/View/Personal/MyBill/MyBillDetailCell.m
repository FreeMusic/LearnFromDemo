//
//  MyBillDetailCell.m
//  CityJinFu
//
//  Created by xxlc on 17/5/25.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "MyBillDetailCell.h"
#import "PartInvestModel.h"
#import "PartIncomeModel.h"

@implementation MyBillDetailCell

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
    [self.contentView addSubview:self.titlelab];
    [self.contentView addSubview:self.moneylab];
    [self.contentView addSubview:self.incomlab];
    //标题
    [_titlelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20*m6Scale);
        make.width.mas_equalTo(kScreenWidth/3+100*m6Scale);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    //利息
    [_incomlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenWidth/3);
        make.right.mas_equalTo(40*m6Scale);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    //本金
    [_moneylab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenWidth/3);
        make.left.mas_equalTo(kScreenWidth/3+60*m6Scale);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    //暂无数据
    _backImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zanwu"]];
    [self.contentView addSubview:_backImgView];
}
/**
 标名
 */
- (UILabel *)titlelab{
    if (!_titlelab) {
        _titlelab = [self commitLab:@"学车包2017期"];
    }
    return _titlelab;
}
/**
 本金
 */
- (UILabel *)moneylab{
    if (!_moneylab) {
        _moneylab = [self commitLab:@"本金:1000.00"];
    }
    return _moneylab;
}
/**
 利息
 */
- (UILabel *)incomlab{
    if (!_incomlab) {
        _incomlab = [self commitLab:@"利息:1000.00"];
    }
    return _incomlab;
}
/**
 公共label
 */
- (UILabel *)commitLab:(NSString *)text{
    UILabel *titleLab = [UILabel new];
    titleLab.text = text;
    titleLab.font = [UIFont systemFontOfSize:30*m6Scale];
    titleLab.textColor = [UIColor lightGrayColor];
    titleLab.textAlignment = NSTextAlignmentLeft;
    return titleLab;
}
- (void)cellForModel:(id)model withtype:(NSInteger)type{
    if (model) {
        _backImgView.hidden = YES;
        _titlelab.hidden = NO;
        _moneylab.hidden = NO;
        _incomlab.hidden = NO;
        if (type == 2) {
            //本月投资记录
            PartInvestModel *partInvestModel = (PartInvestModel *)model;
            _titlelab.text = partInvestModel.itemName;//名称
            _moneylab.text = [NSString stringWithFormat:@"本金：%@", partInvestModel.investPrincipal];//本金
            _incomlab.text = [NSString stringWithFormat:@"利息：%.2f", [partInvestModel.investInterest doubleValue]];//利息
            
        }else{
            //本月回款记录
            PartIncomeModel *partIncomeModel = (PartIncomeModel *)model;
            _titlelab.text = partIncomeModel.itemName;//名称
            _moneylab.text = [NSString stringWithFormat:@"本金：%@", partIncomeModel.collectPrincipal];//本金
            _incomlab.text = [NSString stringWithFormat:@"利息：%.2f", [partIncomeModel.collectInterest doubleValue]];//利息
        }
    }else{
        _backImgView.hidden = NO;
        _titlelab.hidden = YES;
        _moneylab.hidden = YES;
        _incomlab.hidden = YES;
        [_backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(130*m6Scale, 130*m6Scale));
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
    }
}

@end
