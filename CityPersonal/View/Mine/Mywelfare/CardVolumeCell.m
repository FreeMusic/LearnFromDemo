//
//  CardVolumeCell.m
//  CityJinFu
//
//  Created by xxlc on 16/8/22.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "CardVolumeCell.h"

@interface CardVolumeCell ()
@property (nonatomic, strong) UILabel *moneyLabel;//金额
@property (nonatomic, strong) UILabel *timeLabel;//时间
@property (nonatomic, strong) UILabel *typeLabel;//类型
@property (nonatomic, strong) UILabel *phoneLabel;//手机认证
@property (nonatomic, strong) UILabel *useLabel;//抵用
@property (nonatomic, strong) UILabel *dayLabel;//加息天数
@property (nonatomic, strong) UILabel *statusLab;//加息劵状态展示

@end
@implementation CardVolumeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellAccessoryNone;
        self.backgroundColor = [UIColor clearColor];
        //空白view
        _backView = [[UIView alloc] init];
        _backView.layer.cornerRadius = 10;
        _backView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_backView];
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left);
            make.top.equalTo(self.contentView.mas_top);
            make.right.equalTo(self.contentView.mas_right);
            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
        [self layoutsubviews];
    }
    return self;
}
/**
 *  创建布局
 */
- (void)layoutsubviews{
    [self.contentView addSubview:self.imageview];
    [self.imageview addSubview:self.moneyLabel];
    [self.imageview addSubview:self.useLabel];
    [self.imageview addSubview:self.timeLabel];
    [self.imageview addSubview:self.typeLabel];
    [self.imageview addSubview:self.dayLabel];
    [self.imageview addSubview:self.statusLab];
    [self.imageview addSubview:self.hookImageView];
    //加息利率
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imageview.mas_left).offset(30*m6Scale);
        make.top.equalTo(_imageview.mas_top).offset(20*m6Scale);
    }];
    //抵用
    [_useLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imageview.mas_left).offset(30*m6Scale);
        make.centerY.equalTo(_imageview.mas_centerY).offset(10*m6Scale);
    }];
    //手机认证
    _phoneLabel = [UILabel new];
    _phoneLabel.textColor = RedColor;
    _phoneLabel.adjustsFontSizeToFitWidth = YES;
    _phoneLabel.font = [UIFont systemFontOfSize:34*m6Scale];
    [self.imageview addSubview:self.phoneLabel];
    [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-250*m6Scale);
        make.top.equalTo(_imageview.mas_top).offset(40*m6Scale);
    }];
    //时间
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_imageview.mas_right).offset(-30*m6Scale);
        make.centerY.equalTo(_imageview.mas_centerY);
        make.width.mas_equalTo(@(150*m6Scale));
    }];
    //类型
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imageview.mas_left).offset(30*m6Scale);
        make.top.equalTo(_useLabel.mas_bottom).offset(10*m6Scale);
    }];
    //加息天数
    [_dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imageview.mas_left).offset(30*m6Scale);
        make.top.equalTo(_typeLabel.mas_bottom).offset(10*m6Scale);
    }];
    //状态
    [_statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_imageview.mas_right).offset(-60*m6Scale);
        make.top.equalTo(_timeLabel.mas_bottom).offset(20*m6Scale);
    }];
    //对勾
    [_hookImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_imageview.mas_right).offset(-5*m6Scale);
        make.top.equalTo(_imageview.mas_top).offset(5*m6Scale);
        make.size.mas_equalTo(CGSizeMake(34*m6Scale, 34*m6Scale));
    }];
}
- (UIImageView *)imageview
{
    if (!_imageview) {
        _imageview = [[UIImageView alloc]initWithFrame:CGRectMake(25*m6Scale, 10*m6Scale, kScreenWidth-50*m6Scale, 275*m6Scale)];
    }
    return _imageview;
}
/**
 *  金额
 */
- (UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [UILabel new];
        //        _moneyLabel.text = @"1%";
        _moneyLabel.textColor = RedColor;
        _moneyLabel.textAlignment = NSTextAlignmentCenter;
        _moneyLabel.font = [UIFont systemFontOfSize:80*m6Scale];
    }
    return _moneyLabel;
}
/**
 *  抵用
 */
- (UILabel *)useLabel{
    if (!_useLabel) {
        _useLabel = [UILabel new];
        _useLabel.textAlignment = NSTextAlignmentCenter;
        _useLabel.font = [UIFont systemFontOfSize:30*m6Scale];
        _useLabel.textColor = RedColor;
    }
    return _useLabel;
}
/**
 *  时间
 */
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.font = [UIFont systemFontOfSize:28*m6Scale];
        _timeLabel.numberOfLines = 0;
        _timeLabel.textColor = BlackColor;
    }
    return _timeLabel;
}
/**
 *  使用类型
 */
- (UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel = [UILabel new];
        _typeLabel.font = [UIFont systemFontOfSize:28*m6Scale];
        _typeLabel.textColor = RedColor;
        _typeLabel.numberOfLines = 0;
    }
    return _typeLabel;
}
/**
 *  加息天数
 */
- (UILabel *)dayLabel{
    if (!_dayLabel) {
        _dayLabel = [UILabel new];
        _dayLabel.font = [UIFont systemFontOfSize:30*m6Scale];
        _dayLabel.textColor = RedColor;
    }
    return _dayLabel;
}
/**
 状态
 */
- (UILabel *)statusLab{
    if (!_statusLab) {
        _statusLab = [UILabel new];
        _statusLab.textColor = RedColor;
        _statusLab.backgroundColor = [UIColor lightGrayColor];
        _statusLab.font = [UIFont systemFontOfSize:30*m6Scale];
    }
    return _statusLab;
}
/**
 对勾
 */
- (UIImageView *)hookImageView{
    if (!_hookImageView) {
        _hookImageView = [UIImageView new];
        _hookImageView.image = [UIImage imageNamed:@""];
    }
    return _hookImageView;
}
/**
 * 加息劵
 */
- (void)updateCellWithTicketModel:(TicketModel *)model andIndexPath:(NSIndexPath *)indexPath{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *ticketId = [user objectForKey:@"zyyTicketId"];
    
    NSLog(@"%@-----%@",model.scope,model.usefulLife);
    if (model.scope == nil) {
        _typeLabel.text = [NSString stringWithFormat:@"该加息劵不限使用"];
    }else{
        _typeLabel.text = [NSString stringWithFormat:@"该加息劵仅限:超过%@天的标使用",model.scope];
    }
    if ([[NSString stringWithFormat:@"%@",model.ID] isEqualToString:ticketId]) {
        
        _imageview.image = [UIImage imageNamed:@"福利正常背景"];
        _hookImageView.image = [UIImage imageNamed:@"福利对勾"];
    }else {
        _imageview.image = [UIImage imageNamed:@"福利正常背景"];
    }
    if (model.canUse.integerValue == 2) {
        //不可以使用的加息券
        _imageview.image = [UIImage imageNamed:@"福利灰色背景"];
        _hookImageView.image = [UIImage imageNamed:@""];
        _phoneLabel.backgroundColor = UIColorFromRGB(0x8d8d8d);
    }else{
        _imageview.image = [UIImage imageNamed:@"福利正常背景"];
        _phoneLabel.backgroundColor = buttonColor;
    }
    _phoneLabel.text = model.ticketName;//加息劵名称
    _moneyLabel.text = [NSString stringWithFormat:@"%.1f%%",model.rate.doubleValue];//加息利率
    _useLabel.text = [NSString stringWithFormat:@"满%@可用", model.requireAmount];//抵用
    _timeLabel.text = [NSString stringWithFormat:@"有效期至 %@",[Factory stdTimeyyyyMMddFromNumer:model.expiredTime andtag:53]];//有效时间
    if (model.usefulLife.intValue == 0) {
        _dayLabel.text = @"加息天数:不限";//加息天数
    }else{
        _dayLabel.text = [NSString stringWithFormat:@"加息天数:%@天",model.usefulLife];//加息天数
    }
}
/**
 * 加息劵-福利
 */
- (void)updateCellWithMyTicketModel:(TicketModel *)model andIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",model.scope);
    if (model.scope == nil) {
        _typeLabel.text = [NSString stringWithFormat:@"该加息劵不限使用"];
    }else{
        _typeLabel.text = [NSString stringWithFormat:@"加息%@天，仅用于%@天及以上标的",model.usefulLife, model.scope];
    }
    if (model.status.intValue == 1) {
        _imageview.image = [UIImage imageNamed:@"福利灰色背景"];
        _statusLab.text = @"已使用";
        _phoneLabel.backgroundColor = UIColorFromRGB(0x8d8d8d);
    }else if (model.status.intValue == 2){
        _imageview.image = [UIImage imageNamed:@"福利正常背景"];
        _statusLab.text = @"";
        _phoneLabel.backgroundColor = buttonColor;
    }else if(model.status.intValue == 3){
        _imageview.image = [UIImage imageNamed:@"福利灰色背景"];
        _statusLab.text = @"已过期";
        _phoneLabel.backgroundColor = UIColorFromRGB(0x8d8d8d);
    }else{
        _imageview.image = [UIImage imageNamed:@"福利正常背景"];
        _statusLab.text = @"";
        _phoneLabel.backgroundColor = buttonColor;
    }
    _phoneLabel.text = model.ticketName;//加息劵名称
    _moneyLabel.text = [NSString stringWithFormat:@"%.1f%%",model.rate.doubleValue];//加息利率
    _useLabel.text = [NSString stringWithFormat:@"满%@可用", model.requireAmount];//抵用
    //抵用
    [_useLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imageview.mas_left).offset(20*m6Scale);
        make.centerY.equalTo(_imageview.mas_centerY).offset(40*m6Scale);
    }];
    //类型
    [_typeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imageview.mas_left).offset(20*m6Scale);
        make.top.equalTo(_useLabel.mas_bottom).offset(10*m6Scale);
    }];
    _timeLabel.text = [NSString stringWithFormat:@"有效期至 %@",[Factory stdTimeyyyyMMddFromNumer:model.expiredTime andtag:53]];//有效时间
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
