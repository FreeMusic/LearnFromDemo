//
//  InvestPayCell.m
//  CityJinFu
//
//  Created by 姜姜敏 on 16/8/25.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "InvestPayCell.h"

@implementation InvestPayCell

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
    //充值金额
    UILabel *modelPayLabel = [[UILabel alloc] init];
    modelPayLabel.text = @"充值金额";
    modelPayLabel.textColor = [UIColor colorWithRed:167 / 255.0 green:164 / 255.0 blue:164 / 255.0 alpha:1];
    modelPayLabel.font = [UIFont systemFontOfSize:31 * m6Scale];
    [self.contentView addSubview:modelPayLabel];
    
    [modelPayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.contentView.mas_top).offset(27 * m6Scale);
        make.left.equalTo(self.contentView.mas_left).offset(23 * m6Scale);
    }];
    //¥
    UILabel *modelRMBLabel = [[UILabel alloc] init];
    modelRMBLabel.font = [UIFont systemFontOfSize:40 * m6Scale];
    modelRMBLabel.text = @"¥";
    [self.contentView addSubview:modelRMBLabel];
    
    [modelRMBLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(modelPayLabel.mas_bottom).offset(25 * m6Scale);
        make.left.equalTo(modelPayLabel.mas_left);
    }];
    //金额显示
    _payLabel = [[UILabel alloc] init];
    _payLabel.textColor = [UIColor colorWithRed:246 / 255.0 green:68 / 255.0 blue:68 / 255.0 alpha:1];
    _payLabel.font = [UIFont systemFontOfSize:40 * m6Scale];
    [self.contentView addSubview:_payLabel];
    
    [_payLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(modelRMBLabel.mas_right).offset(15 * m6Scale);
        make.centerY.mas_equalTo(modelRMBLabel.mas_centerY);
    }];
    //确认投资
    _makeSureButton = [GXJButton buttonWithType:UIButtonTypeCustom];
    [_makeSureButton setTitle:@"确认投资" forState:UIControlStateNormal];
    [_makeSureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _makeSureButton.titleLabel.font = [UIFont systemFontOfSize:31 * m6Scale];
    _makeSureButton.backgroundColor = ButtonColor;
    [self.contentView addSubview:_makeSureButton];
    [_makeSureButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.contentView.mas_top).offset(43 * m6Scale);
        make.right.equalTo(self.contentView.mas_right).offset(- 25 * m6Scale);
        make.size.mas_equalTo(CGSizeMake(256 * m6Scale, 78 * m6Scale));
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
