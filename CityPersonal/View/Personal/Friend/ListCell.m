//
//  ListCell.m
//  CityJinFu
//
//  Created by 姜姜敏 on 16/9/30.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "ListCell.h"

@implementation ListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatView];
    }
    
    return self;
    
}
- (void)creatView{
    //姓名
    self.realNameLabel = [[UILabel alloc] init];
    self.realNameLabel.text = @"张三";
    self.realNameLabel.font = [UIFont systemFontOfSize:30 * m6Scale];
    self.realNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.realNameLabel];
    [self.realNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(5 * m6Scale);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(kScreenWidth/3);
    }];
    //手机号
    self.mobileLabel = [[UILabel alloc] init];
    self.mobileLabel.font = [UIFont systemFontOfSize:30 * m6Scale];
    self.mobileLabel.text = @"135****4562";
    self.mobileLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.mobileLabel];
    [self.mobileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(kScreenWidth/3);
    }];
    //时间
    self.registerLabel = [[UILabel alloc] init];
    self.registerLabel.font = [UIFont systemFontOfSize:30 * m6Scale];
    self.registerLabel.text = @"2016-07-03";
    self.registerLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.registerLabel];
    [self.registerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(kScreenWidth/3);
    }];
    
}
@end
