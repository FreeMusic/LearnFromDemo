//
//  MyiPhoneCell.m
//  CityJinFu
//
//  Created by mic on 2017/5/31.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "MyiPhoneCell.h"

@interface MyiPhoneCell ()

@property (nonatomic, strong) UIView *centerLine;//中间分隔线（分奇偶性）

@end

@implementation MyiPhoneCell

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        //大图
        _backImgView = [[UIImageView alloc] init];
        _backImgView.image = [UIImage imageNamed:@"帐篷"];
        [self.contentView addSubview:_backImgView];
        [_backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_offset(20*m6Scale);
            make.size.mas_equalTo(CGSizeMake(210*m6Scale, 210*m6Scale));
        }];
        //产品标签
        _goodsLabel = [[UILabel alloc] init];
        _goodsLabel.text = @"iphone7";
        _goodsLabel.textColor = UIColorFromRGB(0x393939);
        _goodsLabel.font = [UIFont systemFontOfSize:26*m6Scale];
        _goodsLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_goodsLabel];
        [_goodsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(249*m6Scale);
            make.left.mas_equalTo(0*m6Scale);
            make.width.mas_equalTo(kScreenWidth/2);
        }];
        //价格标签
        _priceLabel = [Factory CreateLabelWithTextColor:0 andTextFont:24 andText:@"￥7,188.00" addSubView:self.contentView];
        _priceLabel.textColor = UIColorFromRGB(0x9f9e9e);
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_goodsLabel.mas_bottom).offset(16*m6Scale);
            make.right.left.mas_equalTo(0*m6Scale);
        }];
        //起投金额
        _accountLabel = [[UILabel alloc] init];
        _accountLabel.text = @"投资87，000元起";
        _accountLabel.font = [UIFont systemFontOfSize:26*m6Scale];
        _accountLabel.textColor = [UIColor colorWithRed:236 / 255.0 green:67 / 255.0 blue:6/255.0 alpha:1.0];
        _accountLabel.textColor = UIColorFromRGB(0x9f9e9e);
        _accountLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_accountLabel];
        [_accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-16*m6Scale);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(kScreenWidth/2);
        }];
        //为Cell下方添加分割线
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.3];
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        //中间分隔线（分奇偶性）
        _centerLine = [[UIView alloc] init];
        _centerLine.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.3];
        [self.contentView addSubview:_centerLine];
        [_centerLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(1);
        }];
    }
    return self;
}
- (void)cellForModel:(IphoneModel *)model andIndex:(NSInteger)index{
    if (index/2 == 0) {
        _centerLine.hidden = NO;
    }else{
        //_centerLine.hidden = YES;
    }
    NSString *imgName = [NSString stringWithFormat:@"%@", model.imageId];
    if ([imgName isEqual:[NSNull null]]) {
        
    }else{
        //通过逗号将字符串截成数组
        NSArray *array = [imgName componentsSeparatedByString:@","];
        if (array.count>1) {
           UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:array[1]]]];
            _backImgView.image = img;//背景图
        }
    }
    _goodsLabel.text = [NSString stringWithFormat:@"%@", model.goodsName];//商品名称
    _accountLabel.text = [NSString stringWithFormat:@"投资%@元起", model.minAmount];//起投金额
    [Factory ChangeColorString:[NSString stringWithFormat:@"%@", model.minAmount] andLabel:_accountLabel andColor:UIColorFromRGB(0xff5933)];
    _priceLabel.text = [NSString stringWithFormat:@"￥%d", model.originalPrice.intValue];//价格
//    NSAttributedString *tejiaStr = [[NSAttributedString alloc]initWithString:_priceLabel.text attributes:@{NSStrikethroughStyleAttributeName :[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSBaselineOffsetAttributeName : @(NSUnderlineStyleSingle)}];
//    _priceLabel.attributedText = tejiaStr;
}

@end
