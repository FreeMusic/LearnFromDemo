//
//  BillStatisticsCell.m
//  CityJinFu
//
//  Created by 姜姜敏 on 16/8/22.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "BillStatisticsCell.h"

@implementation BillStatisticsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        [self createView];
    }
    
    return self;
}

- (void)createView {
    
    _typeImageView = [[UIImageView alloc] init];
//    _typeImageView.image = [UIImage imageNamed:@"车商宝1"];
    _typeImageView.clipsToBounds = YES;
    [self.contentView addSubview:_typeImageView];
    [_typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(35 * m6Scale);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(67 * m6Scale, 67 * m6Scale));
    }];
    
    _weekLabel = [[UILabel alloc] init];
//    _weekLabel.text = @"周四";
    _weekLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_weekLabel];
    [_weekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(20 * m6Scale);
        make.left.equalTo(self.typeImageView.mas_right).offset(90 * m6Scale);
    }];
    
    _dateLabel = [[UILabel alloc] init];
    _dateLabel.textColor = [UIColor lightGrayColor];
    _dateLabel.font = [UIFont systemFontOfSize:30*m6Scale];
//    _dateLabel.text = @"07-02";
    [self.contentView addSubview:_dateLabel];
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.weekLabel.mas_centerX);
        make.top.equalTo(_weekLabel.mas_bottom).offset(20 * m6Scale);
    }];
    
    _billCountLabel = [[UILabel alloc] init];
//    _billCountLabel.text = @"-1300.00";
    [self.contentView addSubview:_billCountLabel];
    [_billCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.weekLabel.mas_right).offset(100 * m6Scale);
        make.top.equalTo(self.contentView.mas_top).offset(25 * m6Scale);
    }];
    
    _projectTypeLabel = [[UILabel alloc] init];
//    _projectTypeLabel.text = @"投资车贷宝项目第1209期";
    _projectTypeLabel.textColor = [UIColor grayColor];
    _projectTypeLabel.font = [UIFont systemFontOfSize:24*m6Scale];
    [self.contentView addSubview:_projectTypeLabel];
    [_projectTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_billCountLabel.mas_bottom).offset(20 * m6Scale);
        make.left.equalTo(_billCountLabel.mas_left);
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
