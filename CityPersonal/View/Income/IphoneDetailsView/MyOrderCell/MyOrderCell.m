//
//  MyOrderCell.m
//  CityJinFu
//
//  Created by mic on 2017/6/5.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "MyOrderCell.h"

@interface MyOrderCell ()

@property (nonatomic, strong) UIView *backView;//白色背景View

@end

@implementation MyOrderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = backGroundColor;
        self.selectionStyle = NO;
        //物品名称
        _nameLabel = [Factory CreateLabelWithTextColor:0.5 andTextFont:28 andText:@"小苹果" addSubView:self.backView];
        _nameLabel.textColor = UIColorFromRGB(0x525050);
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20*m6Scale);
            make.top.mas_equalTo(16*m6Scale);
        }];
        //物品数量
        _numLabel = [Factory CreateLabelWithTextColor:0.6 andTextFont:20 andText:@"数量：1" addSubView:self.backView];
        _numLabel.textColor = UIColorFromRGB(0x888889);
        _numLabel.textAlignment = NSTextAlignmentCenter;
        _numLabel.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:1].CGColor;
        _numLabel.layer.borderWidth = 1;
        _numLabel.layer.cornerRadius = 13.5*m6Scale;
        [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_nameLabel.mas_right).offset(6*m6Scale);
            make.top.mas_equalTo(16*m6Scale);
            make.height.mas_equalTo(32*m6Scale);
            make.width.mas_equalTo(104*m6Scale);
        }];
        //付款状态
        _statusLabel = [Factory CreateLabelWithTextRedColor:234 GreenColor:133 BlueColor:114 andTextFont:26 andText:@"" addSubView:self.backView];
        _statusLabel.textColor = UIColorFromRGB(0xff5151);
        [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20*m6Scale);
            make.top.mas_equalTo(14*m6Scale);
        }];
        CGFloat width = kScreenWidth/3;
        //中间单线
        for (int i = 0; i < 2; i++) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(25*m6Scale, 64*m6Scale+161*m6Scale*i, kScreenWidth-25*m6Scale, 1)];
            line.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.3];
            [self.backView addSubview:line];
            if (i) {
                NSArray *arr = @[@"投资金额", @"锁定期限", @""];
                //投资金额、锁定期限、下单时间
                for (int i = 0; i < 3; i++) {
                    _label = [Factory CreateLabelWithTextColor:0.4 andTextFont:28 andText:arr[i] addSubView:self.backView];
                    _label.textColor = UIColorFromRGB(0x4c4a4a);
                    _label.tag = 200+i;
                    _label.textAlignment = NSTextAlignmentCenter;
                    _label.frame = CGRectMake(width*i, 104*m6Scale, width, 28*m6Scale);
                }
                //投资金额
                _accountLabel = [Factory CreateLabelWithTextColor:0.5 andTextFont:26 andText:@"200.000.00" addSubView:self.backView];
                _accountLabel.textColor = UIColorFromRGB(0x4c4a4a);
                _accountLabel.textAlignment = NSTextAlignmentCenter;
                [_accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(width);
                    make.top.mas_equalTo(_label.mas_bottom).offset(30*m6Scale);
                    make.left.mas_equalTo(0);
                }];
                //锁定期限
                _dataLabel = [Factory CreateLabelWithTextColor:0.5 andTextFont:26 andText:@"一年" addSubView:self.backView];
                _dataLabel.textColor = UIColorFromRGB(0x4c4a4a);
                _dataLabel.textAlignment = NSTextAlignmentCenter;
                [_dataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(width);
                    make.top.mas_equalTo(_label.mas_bottom).offset(25*m6Scale);
                    make.left.mas_equalTo(width);
                }];
                //下但时间
                _timeLabel = [Factory CreateLabelWithTextColor:0.5 andTextFont:26 andText:@"2017-01-05" addSubView:self.backView];
                _dataLabel.textColor = UIColorFromRGB(0x4c4a4a);
                _timeLabel.textAlignment = NSTextAlignmentCenter;
                [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(width);
                    make.top.mas_equalTo(_label.mas_bottom).offset(25*m6Scale);
                    make.left.mas_equalTo(width*2);
                }];
            }
        }
        //立即支付
        _btn = [UIButton buttonWithType:0];
        _btn.layer.cornerRadius = 25*m6Scale;
        _btn.layer.borderWidth = 1;
        _btn.titleLabel.font = [UIFont systemFontOfSize:24*m6Scale];
        [self.backView addSubview:_btn];
        [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20*m6Scale);
            make.bottom.mas_equalTo(-15*m6Scale);
            make.size.mas_equalTo(CGSizeMake(150*m6Scale, 50*m6Scale));
        }];
        
    }
    return self;
}
/**
 *白色背景图
 */
- (UIView *)backView{
    if(!_backView){
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 20*m6Scale, kScreenWidth, 310*m6Scale)];
        _backView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.backView];
    }
    return _backView;
}
/**
 *取消订单按钮
 */
- (UIButton *)cancleBtn{
    if(!_cancleBtn){
        _cancleBtn = [UIButton buttonWithType:0];
        _cancleBtn.layer.cornerRadius = 25*m6Scale;
        [_cancleBtn setTitle:@"取消订单" forState:0];
        _cancleBtn.layer.borderWidth = 1;
        _cancleBtn.titleLabel.font = [UIFont systemFontOfSize:26*m6Scale];
        [_cancleBtn setTitleColor:UIColorFromRGB(0xa2a2a2) forState:0];
        _cancleBtn.layer.borderColor = UIColorFromRGB(0xa2a2a2).CGColor;
        [self.backView addSubview:_cancleBtn];
        [_cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-180*m6Scale);
            make.bottom.mas_equalTo(-15*m6Scale);
            make.size.mas_equalTo(CGSizeMake(160*m6Scale, 50*m6Scale));
        }];
    }
    return _cancleBtn;
}
- (void)changeButtonTextColorRed:(CGFloat)red Green:(CGFloat)green Blue:(CGFloat)blue andTitle:(NSString *)title{
    [_btn setTitle:title forState:0];
    [_btn setTitleColor:Colorful(red, green, blue) forState:0];
    _btn.layer.borderColor = Colorful(red, green, blue).CGColor;
}
- (void)cellForModel:(MyOrderModel*)model{
    _nameLabel.text = [NSString stringWithFormat:@"%@", model.goodsName];//物品名称
    _numLabel.text = [NSString stringWithFormat:@"数量：%@", model.goodsNum];//物品数量
    _accountLabel.text = [NSString stringWithFormat:@"%.2f", model.orderAmount.floatValue];//投资金额
    _dataLabel.text = [NSString stringWithFormat:@"%@个月", model.lockCycle];//锁定期限
    _timeLabel.text = [Factory stdTimeyyyyMMddFromNumer:model.addtime andtag:53];//下单时间
    //用来判断是下单时间还是锁投时间
    UILabel *label = (UILabel *)[self viewWithTag:202];
    switch (model.payStatus.integerValue) {
        case 0:
            //待支付
            _statusLabel.text = @"待授权";
            label.text = @"下单时间";
            [_btn setTitle:@"立即授权" forState:0];
            [_btn setTitleColor:UIColorFromRGB(0xff5933) forState:0];
            _btn.layer.borderColor = UIColorFromRGB(0xff5933).CGColor;
            //添加取消订单按钮
            self.cancleBtn.hidden = NO;
            
            break;
        case 1:
            //支付成功
            _statusLabel.text = @"授权成功";
            label.text = @"锁投时间";
            [_btn setTitle:@"物流信息" forState:0];
            [_btn setTitleColor:Colorful(236, 133, 6) forState:0];
            _btn.layer.borderColor = Colorful(236, 133, 6).CGColor;
            break;
        case 2:
            //支付失败
            _statusLabel.text = @"授权失败";
            break;
            
        default:
            break;
    }
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
