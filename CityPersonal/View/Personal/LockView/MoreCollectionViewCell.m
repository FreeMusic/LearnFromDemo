//
//  MoreCollectionViewCell.m
//  CityJinFu
//
//  Created by xxlc on 16/8/19.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "MoreCollectionViewCell.h"

@implementation MoreCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //设置contentView为白色
        self.contentView.backgroundColor = [UIColor whiteColor];
        //图片
        _imageView = [[UIImageView alloc]init];
        [self.contentView addSubview:self.imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.bottomMargin.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(60*m6Scale, 60*m6Scale));
        }];
        //文字
        _textLabel = [[UILabel alloc]init];
        _textLabel.textColor = [UIColor colorWithRed:54/255.0 green:54/255.0 blue:54/255.0 alpha:0.8];
        _textLabel.font = [UIFont systemFontOfSize:28*m6Scale];
        [self.contentView addSubview:self.textLabel];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.top.mas_equalTo(self.contentView.mas_centerY).mas_equalTo(40*m6Scale);
        }];

    }
    return self;
}

@end
