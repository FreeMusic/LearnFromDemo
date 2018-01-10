//
//  ContractTCell.m
//  CityJinFu
//
//  Created by xxlc on 16/8/20.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "ContractTCell.h"

@interface ContractTCell ()

@property (nonatomic, strong) UILabel *itemNameLabel;
@property (nonatomic, strong) UILabel *addtimeLabel;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UIImageView *imageview;//印章

@end
@implementation ContractTCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createView];
    }
    return self;
}

- (UILabel *)itemNameLabel {
    
    if (!_itemNameLabel) {
        
        _itemNameLabel = [[UILabel alloc] init];
        _itemNameLabel.textColor = [UIColor grayColor];
    }
    
    return _itemNameLabel;
}

- (UILabel *)addtimeLabel {
    
    if (!_addtimeLabel) {
        _addtimeLabel = [[UILabel alloc] init];
        _addtimeLabel.textColor = [UIColor grayColor];
    }
    
    return _addtimeLabel;
    
}

- (UILabel *)numLabel {
    
    if (!_numLabel) {
        
        _numLabel = [[UILabel alloc] init];
        _numLabel.textColor = [UIColor grayColor];
    }
    
    return _numLabel;
}

- (void)createView {
    //中间的分割线
    for (int i = 0; i < 2; i++) {
        CALayer *clip = [[CALayer alloc] init];
        clip.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:241 / 255.0 blue:242 / 255.0 alpha:1].CGColor;
        clip.frame = CGRectMake(30*m6Scale, 100 * m6Scale + i *100*m6Scale, kScreenWidth, 1 * m6Scale);
        [self.contentView.layer addSublayer:clip];
    }
    //投资项目
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"投资项目";
    [self.contentView addSubview:nameLabel];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.contentView.mas_top).offset(32 * m6Scale);
        make.left.equalTo(self.contentView.mas_left).offset(32 * m6Scale);
    }];
    
    [self.contentView addSubview:self.itemNameLabel];
    [self.itemNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(nameLabel.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(- 32 * m6Scale);
    }];
    //签订时间
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.text = @"签订时间";
    [self.contentView addSubview:timeLabel];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(32 * m6Scale);
    }];
    
    [self.contentView addSubview:self.addtimeLabel];
    [self.addtimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(timeLabel.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(- 32 * m6Scale);
    }];
    //合同编号
    UILabel *numLabel = [[UILabel alloc] init];
    numLabel.text = @"合同编号";
    [self.contentView addSubview:numLabel];
    
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.contentView.mas_left).offset(32 * m6Scale);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(- 32 * m6Scale);
    }];
    
    [self.contentView addSubview:self.numLabel];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(numLabel.mas_centerY);

        make.right.equalTo(self.contentView.mas_right).offset(- 32 * m6Scale);
    }];
    _imageview = [UIImageView new];
    [self.contentView addSubview:_imageview];
    [_imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-30*m6Scale);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(159*m6Scale, 160*m6Scale));
    }];
}

- (void)setModel:(ContractModel *)model {
    _model = model;
    self.itemNameLabel.text = _model.itemName;
    self.addtimeLabel.text = [NSString stringWithFormat:@"%@",[Factory stdTimeyyyyMMddFromNumer:_model.addtime andtag:0]];
    self.numLabel.text = _model.serialNumber;
    if (_model.itemStatus.intValue == 32) {
        _imageview.image = [UIImage imageNamed:@"已还款"];
    }else{
        _imageview.image = [UIImage imageNamed:@"还款中"];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
