//
//  MoreStrategyCell.m
//  CityJinFu
//
//  Created by mic on 2017/7/11.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "MoreStrategyCell.h"
#import "IntergralModel.h"
#import "MoreStrategyModel.h"

@implementation MoreStrategyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = NO;
        self.backgroundColor = UIColorFromRGB(0xffffff);
        //创建布局
        [self CreateUI];
    }
    
    return self;
}
/**
 *布局
 */
- (void)CreateUI{
    //图标
    _iconImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zidongtoubiao"]];
    [self.contentView addSubview:_iconImgView];
    [_iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20*m6Scale);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(95*m6Scale, 95*m6Scale));
    }];
    //加减积分
    _intergralLabel = [Factory CreateLabelWithTextColor:1 andTextFont:32 andText:@"+1000积分" addSubView:self.contentView];
    _intergralLabel.textColor = UIColorFromRGB(0xff5933);
    [_intergralLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView.mas_top).offset(69*m6Scale);
        make.left.mas_equalTo(_iconImgView.mas_right).offset(57*m6Scale);
    }];
    //加减积分的原因标签
    _reasonLabel = [Factory CreateLabelWithTextColor:0.6 andTextFont:26 andText:@"完成实名认证" addSubView:self.contentView];
    [_reasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(75*m6Scale);
        make.left.mas_equalTo(_iconImgView.mas_right).offset(57*m6Scale);
    }];
    //右标签（可能是时间  或  赚积分 和 已完成任务标
    _rightLabel = [Factory CreateLabelWithTextColor:0.6 andTextFont:26 andText:@"" addSubView:self.contentView];
}

- (void)cellForModel:(id)model andType:(NSInteger)type{
    if (type == 0) {
        //积分记录模块
        IntergralModel *object= (IntergralModel *)model;
        //会员积分记录图标
        NSString *imgName = [NSString stringWithFormat:@"%@", object.icon];
        [_iconImgView sd_setImageWithURL:[NSURL URLWithString:imgName] placeholderImage:[UIImage imageNamed:@"zidongtoubiao"]];
        //加减积分标签(首先需要判断操作类型：1收入，-1支出)
        NSString *operationType = [NSString stringWithFormat:@"%@", object.operationType];
        if (operationType.integerValue == 1) {
            //此时的操作类型为收入
            _intergralLabel.text = [NSString stringWithFormat:@"+%@分", object.operationIntegral];
            _intergralLabel.textColor = buttonColor;
        }else{
            //此时的操作类型为支出
            _intergralLabel.text = [NSString stringWithFormat:@"-%@分", object.operationIntegral];
            _intergralLabel.textColor = [UIColor colorWithWhite:0.1 alpha:1];
        }
        //加减积分的原因标签（积分记录描述）
        _reasonLabel.text = [NSString stringWithFormat:@"%@", object.remark];
        //时间标签
        NSString *time = [Factory stdTimeyyyyMMddFromNumer:object.addtime andtag:88];
        _rightLabel.text = time;
        [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20*m6Scale);
            make.top.mas_equalTo(39*m6Scale);
        }];
    }else{
        //赚积分模块
        MoreStrategyModel *object = (MoreStrategyModel *)model;
        //积分图标
        NSString *imgName = [NSString stringWithFormat:@"%@", object.icon];
        _iconImgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgName]]];
        //此时的操作类型为收入
        _intergralLabel.text = [NSString stringWithFormat:@"+%@分", object.rule];
        _intergralLabel.textColor = buttonColor;
        //加减积分的原因标签（积分记录描述）
        _reasonLabel.text = [NSString stringWithFormat:@"%@", object.remark];
        //用户任务完成情况 status 1已完成，未完成
        NSString *status = [NSString stringWithFormat:@"%@", object.status];
        if (status.integerValue) {
            self.userInteractionEnabled = NO;
        }else{
            self.userInteractionEnabled = YES;
        }
        [self setLabelByStatus:status.integerValue];
    }
}
/**
 *根据任务完成情况 确定图标样式
 */
- (void)setLabelByStatus:(NSInteger)status{
    _rightLabel.layer.cornerRadius = 30*m6Scale;
    _rightLabel.layer.masksToBounds = YES;
    _rightLabel.textColor = [UIColor whiteColor];
    _rightLabel.textAlignment = NSTextAlignmentCenter;
    _rightLabel.font = [UIFont systemFontOfSize:30*m6Scale];
    [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20*m6Scale);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(123*m6Scale, 60*m6Scale));
    }];
    if (status) {
        _rightLabel.text = @"已完成";
        _rightLabel.backgroundColor = ButtonColor;
    }else{
        _rightLabel.text = @"赚积分";
        _rightLabel.backgroundColor = UIColorFromRGB(0xFF6935);
    }
}

@end
