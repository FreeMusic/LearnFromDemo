//
//  WaresCell.m
//  CityJinFu
//
//  Created by mic on 2017/7/25.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "WaresCell.h"

@interface WaresCell ()

@property(nonatomic, strong) UIView *backView;

@end

@implementation WaresCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //白色空白View
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20*m6Scale);
            make.top.bottom.right.mas_equalTo(0);
        }];
        //商品图片
        _imgView = [[UIImageView alloc] init];
        [self.backView addSubview:_imgView];
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(10*m6Scale);
            make.height.mas_equalTo(155*m6Scale);
        }];
        //投资
        UILabel *investLabel = [Factory CreateLabelWithTextColor:0 andTextFont:26 andText:@"投资" addSubView:self.backView];
        investLabel.textColor = UIColorFromRGB(0x9f9e9e);
        [investLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        //起投金额
        _amountLabel = [Factory CreateLabelWithTextColor:0 andTextFont:26 andText:@"8700元起" addSubView:self.backView];
        _amountLabel.textColor = UIColorFromRGB(0xff5933);
        [_amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-50*m6Scale);
            make.bottom.mas_equalTo(0);
        }];
        //商品名称
        _goodsLabel = [Factory CreateLabelWithTextColor:1 andTextFont:28 andText:@"iPhone 7" addSubView:self.backView];
        _goodsLabel.textColor = UIColorFromRGB(0x505050);
        [_goodsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(181*m6Scale);
        }];
    }
    
    return self;
}
/**
 *白色空白View
 */
- (UIView *)backView{
    if(!_backView){
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_backView];
    }
    return _backView;
}

- (void)cellForModel:(RecommendModel *)model{
    //商品图片
    NSString *str = [NSString stringWithFormat:@"%@", model.imageId];
    NSArray *array = [str componentsSeparatedByString:@","];
    NSString *imgName = array[0];
    [_imgView  sd_setImageWithURL:[NSURL URLWithString:imgName]];
    //商品名称
    _goodsLabel.text = [NSString stringWithFormat:@"%@", model.goodsName];
    //起投金额
    _amountLabel.text = [NSString stringWithFormat:@"%@元起", model.minAmount];
    UIColor *color = [UIColor colorWithWhite:0.5 alpha:1];
    //改变字体颜色
    [Factory ChangeColorString:@"起" andLabel:_amountLabel andColor:color];
    
}

@end
