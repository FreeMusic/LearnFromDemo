//
//  RecordCell.m
//  CityJinFu
//
//  Created by xxlc on 16/8/25.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "RecordCell.h"

@interface RecordCell ()
@property (nonatomic, strong) UILabel *phoneLabel;//电话号码
@property (nonatomic, strong) UILabel *timeLabel;//时间
@property (nonatomic, strong) UILabel *moneyLabel;//投资金额
@property (nonatomic, strong) UIImageView *iconImageView;//图片

@end
@implementation RecordCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellAccessoryNone;
        //最前面的图片
        _iconImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:_iconImageView];
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(30*m6Scale);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        //电话号码
        _phoneLabel = [[UILabel alloc]init];
        _phoneLabel.textColor = [UIColor colorWithRed:80/255.0 green:81/255.0 blue:81/255.0 alpha:1.0];
        _phoneLabel.font = [UIFont systemFontOfSize:28*m6Scale];
        [self.contentView addSubview:_phoneLabel];
        [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_iconImageView.mas_right).offset(10*m6Scale);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        //时间
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textColor = [UIColor colorWithRed:80/255.0 green:81/255.0 blue:81/255.0 alpha:1.0];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = [UIFont systemFontOfSize:28*m6Scale];
        [self.contentView addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-30*m6Scale);
            make.width.mas_equalTo(@(220*m6Scale));
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        //投资金额
        _moneyLabel = [[UILabel alloc]init];
        _moneyLabel.textColor = [UIColor colorWithRed:80/255.0 green:81/255.0 blue:81/255.0 alpha:1.0];
        _moneyLabel.font = [UIFont systemFontOfSize:28*m6Scale];
        [self.contentView addSubview:_moneyLabel];
        [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
    }
    return self;
}
/**
 * 投资记录
 */
- (void)updateCellWithRecordModel:(RecordModel *)model andIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"56445646---%@",model.investType);
    if ([model.investType isEqualToNumber:@1]) {
        _iconImageView.image = [UIImage imageNamed:@"ItemType_PC"];
    }else if (model.investType.intValue == 3){
        _iconImageView.image = [UIImage imageNamed:@"ItemType_微信"];
    }
    else if (model.investType.intValue == 7){
        _iconImageView.image = [UIImage imageNamed:@"ItemType_苹果"];
    }else if (model.investType.intValue == 8){
        _iconImageView.image = [UIImage imageNamed:@"ItemType_安卓"];
    }else if (model.investType.intValue == 9){
        _iconImageView.image = [UIImage imageNamed:@"ItemType_suotou"];
    }else if (model.investType.intValue == 10){
        _iconImageView.image = [UIImage imageNamed:@"ItemType_自动投标"];
    }else if (model.investType.intValue == 11){
        _iconImageView.image = [UIImage imageNamed:@"ItemType_魔库"];
    }
    _phoneLabel.text = model.mobile;//投资人
    _moneyLabel.text = [NSString stringWithFormat:@"%@元",[Factory exchangeStrWithNumber:model.investDealAmount]];//投资金额
    _timeLabel.text = [Factory stdTimeyyyyMMddFromNumer:model.addtime andtag:3];//投资时间
    
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
