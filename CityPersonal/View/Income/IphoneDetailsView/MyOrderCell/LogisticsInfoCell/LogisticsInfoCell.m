//
//  LogisticsInfoCell.m
//  CityJinFu
//
//  Created by mic on 2017/6/28.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "LogisticsInfoCell.h"
#import "FormValidator.h"

#define Width [UIScreen mainScreen].bounds.size.width/320.0

@implementation LogisticsInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = NO;
        //标题
        _titleLabel = [Factory CreateLabelWithTextColor:0 andTextFont:24 andText:@"杭州" addSubView:self.contentView];
        _titleLabel.numberOfLines = 0;
        //时间
        _timeLabel = [Factory CreateLabelWithTextColor:0 andTextFont:24 andText:@"时间" addSubView:self.contentView];
        //进度图标
        _progressImg = [[UIImageView alloc] init];
        [self.contentView addSubview:_progressImg];
        //单线
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
        [self.contentView addSubview:_line];
    }
    
    return self;
}

- (void)cellForModel:(LogisticsInfoModel *)mdoel index:(NSInteger)index{
    _titleLabel.text = mdoel.context;//物流消息
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(80*m6Scale);
        make.top.mas_equalTo(20*m6Scale);
        make.width.mas_equalTo(kScreenWidth-100*m6Scale);
    }];
    _timeLabel.text = mdoel.time;//时间
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(80*m6Scale);
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(18*m6Scale);
    }];
    if (index) {
        _titleLabel.textColor = UIColorFromRGB(0x14D369);
        _timeLabel.textColor = UIColorFromRGB(0x14D369);
        //进度图标
        _progressImg.image = [UIImage imageNamed:@"2"];
        [_progressImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(31*m6Scale);
            make.top.mas_equalTo(_titleLabel.mas_top).offset(2*m6Scale);
            make.size.mas_equalTo(CGSizeMake(18*m6Scale, 18*m6Scale));
        }];
        //进度线
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_progressImg.mas_bottom);
            make.left.mas_equalTo(39.3*m6Scale);
            make.width.mas_equalTo(0.5);
            make.bottom.mas_equalTo(0);
        }];
    }else{
        _titleLabel.textColor = UIColorFromRGB(0xA5A5A5);
        _timeLabel.textColor = UIColorFromRGB(0xA5A5A5);
        _progressImg.image = [UIImage imageNamed:@"1"];
        //进度图标
        [_progressImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(35*m6Scale);
            make.top.mas_equalTo(_titleLabel.mas_top).offset(5*m6Scale);
            make.size.mas_equalTo(CGSizeMake(10*m6Scale, 10*m6Scale));
        }];
        //进度线
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(39.3*m6Scale);
            make.width.mas_equalTo(0.5);
            make.bottom.mas_equalTo(0);
        }];
        [self.contentView sendSubviewToBack:_line];
    }
}

@end
