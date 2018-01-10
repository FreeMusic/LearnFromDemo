//
//  AutoBidRecodeTableViewCell.m
//  CityJinFu
//
//  Created by mic on 16/9/27.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "AutoBidRecodeTableViewCell.h"

@interface AutoBidRecodeTableViewCell ()
@property (nonatomic, strong) UILabel *itemName;//借款标题
@property (nonatomic, strong) UILabel *timeLabel;//时间
@property (nonatomic, strong) UILabel *moneyLabel;//投资金额
@property (nonatomic, strong) UILabel *incomLabel;//预期收益


@end

@implementation AutoBidRecodeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellAccessoryNone;
        self.backgroundColor = [UIColor whiteColor];
        [self creatView];
//        //电话号码
//        _itemName = [[UILabel alloc]init];
//        _itemName.textColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];
//        _itemName.font = [UIFont systemFontOfSize:34*m6Scale];
//                _itemName.text = @"tyuiobnm";
//        _itemName.textAlignment = NSTextAlignmentCenter;
//        [self.contentView addSubview:_itemName];
//        [_itemName mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.contentView.mas_left).offset(30*m6Scale);
//            make.centerY.equalTo(self.contentView.mas_centerY);
//        }];
//        //时间
//        _timeLabel = [[UILabel alloc]init];
//        _timeLabel.textColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];
//        _timeLabel.font = [UIFont systemFontOfSize:28*m6Scale];
//                _timeLabel.text = @"29:346789";
//        _timeLabel.textAlignment = NSTextAlignmentCenter;
//        [self.contentView addSubview:_timeLabel];
//        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.contentView.mas_right).offset(-10*m6Scale);
//            make.centerY.equalTo(self.contentView.mas_centerY);
//            make.width.mas_equalTo(@(200*m6Scale));
//        }];
//        //投资金额
//        _moneyLabel = [[UILabel alloc]init];
//        _moneyLabel.textColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];
//        _moneyLabel.font = [UIFont systemFontOfSize:34*m6Scale];
//                _moneyLabel.text = @"3456\n7890";
//        _moneyLabel.numberOfLines = 0;
//        _moneyLabel.textAlignment = NSTextAlignmentCenter;
//        [self.contentView addSubview:_moneyLabel];
//        [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self.contentView.mas_centerX);
//            make.centerY.mas_equalTo(self.contentView.mas_centerY);
//        }];
    }
    return self;
}
/**
 布局
 */
- (void)creatView{
    [self.contentView addSubview:self.itemName];
    [self.contentView addSubview:self.moneyLabel];
    [self.contentView addSubview:self.incomLabel];
    [self.contentView addSubview:self.timeLabel];
    //灰线
    CALayer *shouwLayer = [[CALayer alloc] init];
    shouwLayer.frame = CGRectMake(30*m6Scale, 20*m6Scale, 3, 40*m6Scale);
    shouwLayer.backgroundColor = ButtonColor.CGColor;
    [self.contentView.layer addSublayer:shouwLayer];
    //横线
    CALayer *verLayer = [[CALayer alloc] init];
    verLayer.frame = CGRectMake(30*m6Scale, 70*m6Scale, kScreenWidth - 60*m6Scale, 0.5);
    verLayer.backgroundColor = backGroundColor.CGColor;
    [self.contentView.layer addSublayer:verLayer];
    //标题
    [_itemName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(40*m6Scale);
        make.top.equalTo(self.contentView.mas_top).offset(20*m6Scale);
    }];
    //本金
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.top.mas_equalTo(self.contentView.mas_top).offset(80*m6Scale);
        make.width.mas_equalTo(kScreenWidth / 3);
    }];
    //收益
    [_incomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.moneyLabel.mas_right);
        make.top.mas_equalTo(self.contentView.mas_top).offset(80*m6Scale);
        make.width.mas_equalTo(kScreenWidth / 3);
    }];
    //时间
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.incomLabel.mas_right);
        make.top.mas_equalTo(self.contentView.mas_top).offset(80*m6Scale);
        make.width.mas_equalTo(kScreenWidth / 3);
    }];
    NSArray *array = @[@"投资本金(元)",@"预期收益(元)",@"投资时间"];
    for (int i = 0; i < 3; i++) {
        UILabel *label = [self commitLab:array[i]];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset((kScreenWidth / 3)*i);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-20*m6Scale);
            make.width.mas_equalTo(kScreenWidth / 3);
        }];
    }
}
/**
 项目标题
 */
- (UILabel *)itemName{
    if (!_itemName) {
        _itemName = [UILabel new];
        _itemName.text = @"车贷宝-2558期";
        _itemName.textColor = BlackColor;
        _itemName.font = [UIFont systemFontOfSize:36*m6Scale];
    }
    return _itemName;
}
/**
 投资本金
 */
- (UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [self commitLab:@"6000.00"];
    }
    return _moneyLabel;
}
/**
 预期收益
 */
- (UILabel *)incomLabel{
    if (!_incomLabel) {
        _incomLabel = [self commitLab:@"600.00"];
    }
    return _incomLabel;
}
/**
 时间
 */
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [self commitLab:@"2017-6-10"];
    }
    return _timeLabel;
}
/**
 公共label
 */
- (UILabel *)commitLab:(NSString *)text{
    UILabel *label = [UILabel new];
    label.text = text;
    label.font = [UIFont systemFontOfSize:30*m6Scale];
    label.textColor = titleColor;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}
- (void)updateCellWithRecordModel:(AutoBidRecodeModel *)model andIndexPath:(NSIndexPath *)indexPath
{
    _itemName.text = model.itemName;//借款标题
    _moneyLabel.text = model.investDealAmount.stringValue;//金额
    _timeLabel.text = [Factory stdTimeyyyyMMddFromNumer:model.addtime andtag:2];//时间
    _incomLabel.text = [NSString stringWithFormat:@"%.2f", model.collectInterest.doubleValue];//收益
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
