//
//  TopUpCell.m
//  CityJinFu
//
//  Created by mic on 2017/10/18.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "TopUpCell.h"

@implementation TopUpCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = NO;
        
        //iocon
        _imgView = [[UIImageView alloc] init];
        _imgView.backgroundColor = backGroundColor;
        [self.contentView addSubview:_imgView];
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(70*m6Scale, 70*m6Scale));
            make.left.mas_equalTo(20*m6Scale);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        //支付公司名称
        _typeLabel = [Factory CreateLabelWithColor:UIColorFromRGB(0x393939) andTextFont:28 andText:@"发动机" addSubView:self.contentView];
        [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_imgView.mas_right).offset(20*m6Scale);
            make.centerY.mas_equalTo(self.contentView.mas_centerY).offset(-15*m6Scale);
        }];
        
        //银行限额
        _accountLabel = [Factory CreateLabelWithColor:UIColorFromRGB(0x848484) andTextFont:26 andText:@"覆盖层v" addSubView:self.contentView];
        [_accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_imgView.mas_right).offset(20*m6Scale);
            make.centerY.mas_equalTo(self.contentView.mas_centerY).offset(15*m6Scale);
        }];
        
        //选中按钮
        _slectedBtn = [UIButton buttonWithType:0];
        _slectedBtn.userInteractionEnabled = NO;
        [_slectedBtn setImage:[UIImage imageNamed:@"TopUp_椭圆-3"] forState:0];
        [_slectedBtn setImage:[UIImage imageNamed:@"TopUp_选中"] forState:UIControlStateSelected];
        [self.contentView addSubview:_slectedBtn];
        [_slectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(44*m6Scale, 44*m6Scale));
            make.right.mas_equalTo(-20*m6Scale);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
    }
    
    return self;
}

- (void)cellForModel:(TopUpModel *)model andSelected:(NSInteger)index andIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"%@     %@", model.bankIcon, model);
    
    [_imgView sd_setImageWithURL:[NSURL URLWithString:model.logoUrl]];
    
    _typeLabel.text = model.alias;
    
    _accountLabel.text = model.descriptionType;

    if ((indexPath.row-2)%2) {
        self.line.hidden = NO;
        [self addSubview:self.line];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20*m6Scale);
            make.right.mas_equalTo(-20*m6Scale);
            make.height.mas_equalTo(1);
            make.top.mas_equalTo(0);
        }];
    }else{
        self.line.hidden = YES;
    }
    
    if (index-100 == indexPath.row - 2) {
        
        _slectedBtn.selected = YES;
        
    }else{
        
        _slectedBtn.selected = NO;
    }
    
}
- (UIView *)line{
    if(!_line){
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.3];
    }
    return _line;
}
- (void)cellForModel:(TopUpModel *)model{
    
    [_imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50*m6Scale, 50*m6Scale));
        make.left.mas_equalTo(20*m6Scale);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    [_typeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_imgView.mas_right).offset(20*m6Scale);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    [self addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30*m6Scale);
        make.right.mas_equalTo(-20*m6Scale);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(0);
    }];
    
    _accountLabel.hidden = YES;
    
    [_imgView sd_setImageWithURL:[NSURL URLWithString:model.logoUrl]];
    
    _typeLabel.text = model.alias;
    
    _accountLabel.text = model.descriptionType;
    
    _slectedBtn.hidden = YES;
}

- (void)didSelectRowAtIndexPath:(NSInteger)index andCurrentIndex:(NSInteger)currentIndex{
    
    if (index == currentIndex) {
        
        _slectedBtn.selected = YES;
        
    }else{
        
        _slectedBtn.selected = NO;
    }
    
}

- (void)cellForModel:(TopUpModel *)model andSelected:(NSInteger)index andOtherIndex:(NSInteger)OtherIndex{
    NSLog(@"%@     %@", model.bankIcon, model);
    
    [_imgView sd_setImageWithURL:[NSURL URLWithString:model.logoUrl]];
    
    _typeLabel.text = model.alias;
    
    _accountLabel.text = model.descriptionType;
    
    if (index == OtherIndex) {
        
        _slectedBtn.selected = YES;
        
    }else{
        
        _slectedBtn.selected = NO;
    }
}

- (void)cellRefreshData:(TopUpModel *)model{
    
    NSLog(@"%@", model.alias);
    
    [_imgView sd_setImageWithURL:[NSURL URLWithString:model.logoUrl]];
    
    _typeLabel.text = model.alias;
    
    _accountLabel.text = model.descriptionType;
    
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
