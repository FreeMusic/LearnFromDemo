//
//  ScanIDCell.m
//  CityJinFu
//
//  Created by mic on 2017/7/27.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "ScanIDCell.h"

@interface ScanIDCell ()

@end

@implementation ScanIDCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = NO;
        //身份证照片
        _idCardImg = [[UIImageView alloc] init];
        _idCardImg.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:0.3].CGColor;
        _idCardImg.layer.borderWidth = 1;
        _idCardImg.layer.cornerRadius = 5*m6Scale;
        [self.contentView addSubview:_idCardImg];
        [_idCardImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(588*m6Scale, 588.0/708.0*438*m6Scale));
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.top.mas_equalTo(10*m6Scale);
        }];
        //空白View
        [_idCardImg addSubview:self.backView];
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(1);
            make.bottom.right.mas_equalTo(-1);
        }];
        //扫描身份证二维码图标
        _iconImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"扫描"]];
        [self.backView addSubview:_iconImgView];
        [_iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(90*m6Scale, 90*m6Scale));
            make.centerX.mas_equalTo(self.backView.mas_centerX);
            make.top.mas_equalTo(58*m6Scale);
        }];
        //扫描身份证标签
        _scanLabel = [Factory CreateLabelWithTextColor:0 andTextFont:24 andText:@"" addSubView:self.backView];
        _scanLabel.textColor = UIColorFromRGB(0x767676);
        [_scanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_iconImgView.mas_bottom).offset(20*m6Scale);
            make.centerX.mas_equalTo(self.backView.mas_centerX);
        }];
        //必填标签
        UILabel *mustLabel = [Factory CreateLabelWithTextColor:0 andTextFont:24 andText:@"必填" addSubView:self.backView];
        mustLabel.textColor = UIColorFromRGB(0xFFB514);
        [mustLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_scanLabel.mas_bottom).offset(20*m6Scale);
            make.centerX.mas_equalTo(self.backView.mas_centerX);
        }];
    }
    return self;
}
/**
 *空白View
 */
- (UIView *)backView{
    if(!_backView){
        _backView = [[UIView alloc] init];
    }
    return _backView;
}
@end
