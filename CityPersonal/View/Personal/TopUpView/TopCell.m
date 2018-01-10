//
//  TopCell.m
//  CityJinFu
//
//  Created by mic on 2017/7/20.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "TopCell.h"
#import "FormValidator.h"

@implementation TopCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = NO;
        //银行卡图标
        _iconImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"工商"]];
        [self.contentView addSubview:_iconImgView];
        [_iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20*m6Scale);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(50*m6Scale, 50*m6Scale));
        }];
        //银行卡名称标签
        _bankLabel = [Factory CreateLabelWithTextColor:1 andTextFont:28 andText:@"工商银行" addSubView:self.contentView];
        _bankLabel.textColor = UIColorFromRGB(0x555555);
        [self.contentView addSubview:_bankLabel];
        [_bankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_iconImgView.mas_right).offset(20*m6Scale);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        //银行卡信息描述
        _contentLabel = [Factory CreateLabelWithTextColor:1 andTextFont:26 andText:@"" addSubView:self.contentView];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = UIColorFromRGB(0x848484);
        //银行卡选中图标
        _imgView = [[UIImageView alloc] init];
        [self.contentView addSubview:_imgView];
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20*m6Scale);
            make.top.mas_equalTo(37*m6Scale);
            make.size.mas_equalTo(CGSizeMake(30*m6Scale, 30*m6Scale));
        }];
    }
    return self;
}

- (void)cellForModel:(BankListModel *)model andIndex:(NSInteger)index andIndexPath:(NSIndexPath *)indexPath{
    //银行卡icon
    NSString *bankImg = [NSString stringWithFormat:@"%@", model.bankIcon];
    _iconImgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:bankImg]]];
    
    //银行卡尾号
    NSArray *array = [model.cardNo componentsSeparatedByString:@"*"];
    NSString *numStr = [array lastObject];
    //银行卡信息描述
    //银行卡名称
    _bankLabel.text = [NSString stringWithFormat:@"%@(尾号%ld)", model.bankName, numStr.integerValue];
    //_contentLabel.text = [NSString stringWithFormat:@"%@", model.remark];
    //CGRect rect =[FormValidator rectWidthAndHeightWithStr:_contentLabel.text AndFont:24*m6Scale WithStrWidth:300];
    //_contentLabel.frame =CGRectMake(90*m6Scale, 53*m6Scale, kScreenWidth-160*m6Scale, rect.size.height);
    
    if (indexPath.row == index) {
        //银行卡选中图标
        _imgView.image = [UIImage imageNamed:@"xuanzhe"];
    }else{
        _imgView.image = [UIImage imageNamed:@""];
    }
}
//更换选中银行卡的下标
- (void)cellForIndex:(NSInteger)index andAllIndex:(NSInteger)all{
    if (all == index-100) {
        //银行卡选中图标
        _imgView.image = [UIImage imageNamed:@"xuanzhe"];
    }else{
        _imgView.image = [UIImage imageNamed:@""];
    }
}
//提现
- (void)cellForWithDrawalModel:(BankListModel *)model andIndex:(NSInteger)index andIndexPath:(NSIndexPath *)indexPath{
    //银行卡icon
    NSString *bankImg = [NSString stringWithFormat:@"%@", model.bankIcon];
    _iconImgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:bankImg]]];
    [_iconImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60*m6Scale, 60*m6Scale));
    }];
    //银行卡尾号
    NSArray *array = [model.cardNo componentsSeparatedByString:@"*"];
    NSString *numStr = [array lastObject];
    //银行卡名称
    _bankLabel.text = [NSString stringWithFormat:@"%@(尾号%ld储蓄卡)", model.bankName, numStr.integerValue];
    
//    //银行卡号
//    _contentLabel.text = [NSString stringWithFormat:@"尾号%ld储蓄卡",  numStr.integerValue];
//    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(_iconImgView.mas_right).offset(20*m6Scale);
//        make.bottom.mas_equalTo(-17*m6Scale);
//    }];
    NSLog(@"%ld    %ld", index, indexPath.row);
    if (indexPath.row == index) {
        //银行卡选中图标
        _imgView.image = [UIImage imageNamed:@"xuanzhe"];
    }else{
        //银行卡选中图标
        _imgView.image = [UIImage imageNamed:@""];
    }
}
@end
