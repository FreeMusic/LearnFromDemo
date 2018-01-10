//
//  NewMyBillCell.m
//  CityJinFu
//
//  Created by mic on 2017/10/18.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "NewMyBillCell.h"

@implementation NewMyBillCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = NO;
        
        //图标icon
        [self addSubview:self.iconImgView];
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80*m6Scale, 80*m6Scale));
            make.left.mas_equalTo(20*m6Scale);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        //标题标签
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY).offset(-20*m6Scale);
            make.left.mas_equalTo(self.iconImgView.mas_right).offset(20*m6Scale);
        }];
        
        //时间标签
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY).offset(20*m6Scale);
            make.left.mas_equalTo(self.iconImgView.mas_right).offset(20*m6Scale);
        }];
        
        //金额标签
        [self.accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20*m6Scale);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        //最下边单线
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.3];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
    }
    
    return self;
}
/**
 * 图标icon
 */
- (UIImageView *)iconImgView{
    if(!_iconImgView){
        _iconImgView = [[UIImageView alloc] init];
    }
    return _iconImgView;
}
/**
 *  标题标签
 */
- (UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [Factory CreateLabelWithColor:UIColorFromRGB(0x454545) andTextFont:28 andText:@"APP充值" addSubView:self.contentView];
    }
    return _titleLabel;
}
/**
 *  标题标签
 */
- (UILabel *)timeLabel{
    if(!_timeLabel){
        _timeLabel = [Factory CreateLabelWithColor:UIColorFromRGB(0x8e8e8e) andTextFont:26 andText:@"10月11日 22：22：22" addSubView:self.contentView];
    }
    return _timeLabel;
}
/**
 *  金额标签
 */
- (UILabel *)accountLabel{
    if(!_accountLabel){
        _accountLabel = [Factory CreateLabelWithColor:UIColorFromRGB(0x393939) andTextFont:36 andText:@"1000.00" addSubView:self.contentView];
    }
    return _accountLabel;
}

- (void)cellForModel:(NewMyBillModel *)model{
    
    NSString *imgName;
    NSString *operType = [NSString stringWithFormat:@"%@", model.operType];
    if ([operType containsString:@"invest"]) {
        imgName = @"NewMyBill_投资";
    }else if ([operType containsString:@"repay"]){
        imgName = @"NewMyBill_回款-01";
    }else if ([operType containsString:@"cash"]){
        imgName = @"NewMyBill_提现";
    }else if ([operType containsString:@"recharge"]){
        imgName = @"NewMyBill_充值";
    }else{
        imgName = @"NewMyBill_其他";
    }
    //类型icon
    self.iconImgView.image = [UIImage imageNamed:imgName];
    //类型标题
    self.titleLabel.text = model.remark;
    //时间
    self.timeLabel.text = [Factory stdTimeyyyyMMddFromNumer:model.addtime andtag:3];
    //金额
    self.accountLabel.text = [NSString stringWithFormat:@"%.2f", model.operMoney.doubleValue];
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
