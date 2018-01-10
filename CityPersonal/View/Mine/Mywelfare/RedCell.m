
//
//  RedCell.m
//  CityJinFu
//
//  Created by xxlc on 16/8/22.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "RedCell.h"

@interface RedCell ()

@property (nonatomic, strong) UILabel *moneyLabel;//金额
@property (nonatomic, strong) UILabel *useLabel;//抵用
@property (nonatomic, strong) UILabel *phoneLabel;//手机认证
@property (nonatomic, strong) UILabel *timeLabel;//时间
@property (nonatomic, strong) UILabel *typeLabel;//类型
@property (nonatomic, strong) UILabel *statusLab;//红包状态展示
@property (nonatomic, strong) UILabel *moKuLabel;//魔库现金红包文字描述
@property (nonatomic, strong) UILabel *atOnceLabel;//立即使用标签

@end
@implementation RedCell

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
    [self.backView addSubview:self.imageview];
    [self.imageview addSubview:self.moneyLabel];
    [self.imageview addSubview:self.useLabel];
    [self.imageview addSubview:self.timeLabel];
    [self.imageview addSubview:self.typeLabel];
    [self.imageview addSubview:self.statusLab];
    [self.imageview addSubview:self.hookImageView];
    
    //金额
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imageview.mas_left).offset(40*m6Scale);
        make.top.equalTo(_imageview.mas_top).offset(20*m6Scale);
    }];
    //抵用
    [_useLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imageview.mas_left).offset(50*m6Scale);
        make.centerY.equalTo(_imageview.mas_centerY).offset(40*m6Scale);
    }];
    //类型
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imageview.mas_left).offset(50*m6Scale);
        make.top.equalTo(_useLabel.mas_bottom).offset(10*m6Scale);
    }];
    //手机认证
    _phoneLabel = [UILabel new];
    _phoneLabel.textColor = RedColor;
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
        _imageview.image = [UIImage imageNamed:@"redNormal"];
    }
    return _imageview;
}
/**
 *  金额
 */
- (UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [UILabel new];
        _moneyLabel.textColor = RedColor;
        _moneyLabel.font = [UIFont systemFontOfSize:60*m6Scale];
    }
    return _moneyLabel;
}
/**
 *  抵用
 */
- (UILabel *)useLabel{
    if (!_useLabel) {
        _useLabel = [UILabel new];
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
        _timeLabel.textColor = BlackColor;
        _timeLabel.numberOfLines = 2;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}
/**
 *  使用类型
 */
- (UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel = [UILabel new];
//        _typeLabel.text = @"该红包仅限:车贷宝、车商宝使用";
        _typeLabel.font = [UIFont systemFontOfSize:30*m6Scale];
        _typeLabel.textColor = RedColor;
        _typeLabel.numberOfLines = 0;
    }
    return _typeLabel;
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
 *  魔库红包描述文字
 */
- (UILabel *)moKuLabel{
    if(!_moKuLabel){
        _moKuLabel = [Factory CreateLabelWithColor:[UIColor whiteColor] andTextFont:28 andText:@"实名绑卡后自动发放至账户余额" addSubView:self.contentView];
    }
    return _moKuLabel;
}
/**
 *  立即使用标签
 */
- (UILabel *)atOnceLabel{
    if(!_atOnceLabel){
        _atOnceLabel = [Factory CreateLabelWithColor:UIColorFromRGB(0xff5933) andTextFont:28 andText:@"立即使用" addSubView:self.contentView];
    }
    return _atOnceLabel;
}
/**
 * 红包
 */
- (void)updateCellWithRedModel:(RedModel *)model andIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",model.scope);
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    NSString *redId = [user objectForKey:@"zyyRedId"];
    
    NSLog(@"%@,%@",redId,model.ID);
    
    if ([[NSString stringWithFormat:@"%@",model.ID] isEqualToString:redId]) {
        _imageview.image = [UIImage imageNamed:@"福利正常背景"];
        _hookImageView.image = [UIImage imageNamed:@"福利对勾"];
    }else {
        _hookImageView.image = [UIImage imageNamed:@""];
        _imageview.image = [UIImage imageNamed:@"福利正常背景"];
    }
    if (model.canUse.integerValue == 2) {
        //不可以使用的红包
        _imageview.image = [UIImage imageNamed:@"福利灰色背景"];
        _hookImageView.image = [UIImage imageNamed:@""];
        _phoneLabel.backgroundColor = UIColorFromRGB(0x8d8d8d);
    }else{
        _imageview.image = [UIImage imageNamed:@"福利正常背景"];
        _phoneLabel.backgroundColor = buttonColor;
    }
    _moneyLabel.text = [NSString stringWithFormat:@"%@元",model.amount];//红包金额
    _useLabel.text = [NSString stringWithFormat:@"满%@可用", model.requireAmount];//抵用
    _timeLabel.text = [NSString stringWithFormat:@"有效期至\n%@",[Factory stdTimeyyyyMMddFromNumer:model.expiredTime andtag:53]];//有效时间
    if (model.scope == nil) {
        _typeLabel.text = @"使用权限不限";
    }else{
        _typeLabel.text = [NSString stringWithFormat:@"该红包仅限:超过%@天的标使用",model.scope];//使用时间限制
    }
    _phoneLabel.text = model.couponName;//红包获得的来源
}
/**
 * 红包-福利
 */
- (void)updateCellWithMyRedModel:(RedModel *)model andIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"1111++++%@",model.status);
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
    _moneyLabel.text = [NSString stringWithFormat:@"￥%@",model.amount];//红包金额
    if ([model.couponName isEqualToString:@"现金红包"]) {
        _useLabel.hidden = YES;
        _timeLabel.hidden = YES;
        _typeLabel.hidden = YES;
        _statusLab.hidden = YES;
        [self.moKuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_imageview.mas_left).offset(20*m6Scale);
            make.centerY.equalTo(_imageview.mas_centerY).offset(40*m6Scale);
        }];
        [self.atOnceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_imageview.mas_right).offset(-50*m6Scale);
            make.centerY.equalTo(_imageview.mas_centerY);
        }];
        if (model.status.intValue == 1) {
            self.atOnceLabel.text = @"已使用";
            self.atOnceLabel.textColor = [UIColor grayColor];
        }else{
            self.atOnceLabel.text = @"立即使用";
            self.atOnceLabel.textColor = UIColorFromRGB(0xff5933);
        }
    }else{
        _useLabel.hidden = NO;
        _timeLabel.hidden = NO;
        _typeLabel.hidden = NO;
        _statusLab.hidden = NO;
        _useLabel.text = [NSString stringWithFormat:@"满%@可用", model.requireAmount];//抵用
        _timeLabel.text = [NSString stringWithFormat:@"有效期至\n%@",[Factory stdTimeyyyyMMddFromNumer:model.expiredTime andtag:53]];//有效时间
        if (model.scope == nil) {
            _typeLabel.text = @"使用权限不限";
        }else{
            _typeLabel.text = [NSString stringWithFormat:@"仅用于%@天以上标的",model.scope];//使用时间限制
        }
    }
    NSLog(@"%@", model.couponName);
    _phoneLabel.text = model.couponName;//红包获得的来源
}
/**
 *  体验金
 */
- (void)updateCellWithGoldModel:(RedModel *)model andIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"%@",model.status);
  
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
    }else if(model.status.intValue == 4){
        _imageview.image = [UIImage imageNamed:@"福利灰色背景"];
        _statusLab.text = @"使用中";
        _phoneLabel.backgroundColor = UIColorFromRGB(0x8d8d8d);
    }else{
        _imageview.image = [UIImage imageNamed:@"福利灰色背景"];
        _statusLab.text = @"";
        _phoneLabel.backgroundColor = UIColorFromRGB(0x8d8d8d);
    }
    _moneyLabel.text = [NSString stringWithFormat:@"%@元",model.amount];//体验金金额
    _timeLabel.text = [NSString stringWithFormat:@"有效期至\n%@",[Factory stdTimeyyyyMMddFromNumer:model.expiredTime andtag:53]];//有效时间
    //类型
    [_typeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imageview.mas_left).offset(20*m6Scale);
        make.top.equalTo(_moneyLabel.mas_bottom).offset(50*m6Scale);
    }];
    _typeLabel.text = [NSString stringWithFormat:@"单笔投资满100元可激活\n投资期限：%ld天 年化利率：%ld%@", (long)model.usefulLife.integerValue, (long)model.rate.integerValue, @"%"];//使用时间限制
    [Factory changeLineSpaceForLabel:_typeLabel WithSpace:5];
    _phoneLabel.text = model.goldName;//体验金获得的来源

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
