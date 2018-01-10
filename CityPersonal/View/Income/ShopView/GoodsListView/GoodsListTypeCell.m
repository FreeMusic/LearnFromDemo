//
//  GoodsListTypeCell.m
//  CityJinFu
//
//  Created by mic on 2017/7/25.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "GoodsListTypeCell.h"
#import "IphoneModel.h"
#import "GoodsListVC.h"
#import "IphoneDetailsVC.h"

@interface GoodsListTypeCell ()

@property (nonatomic, strong) UILabel *goodsLabel;//商品名称
@property (nonatomic, strong) UILabel *priceLabel;//价格标签
@property (nonatomic, strong) UIImageView *iconImgView;//商品图标
@property (nonatomic, strong) UILabel *amountLabel;//起投金额
@property (nonatomic, strong) UIButton *backBtn;//默认展示商品Btn
@property (nonatomic, strong) NSArray *goodsArr;

@end

@implementation GoodsListTypeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = NO;
        self.backgroundColor = backGroundColor;
        //默认展示三条的商品View
        for (int i = 0; i < 3; i++) {
            _backBtn = [UIButton buttonWithType:0];
            _backBtn.frame = CGRectMake(kScreenWidth/3*i, 0*m6Scale, kScreenWidth/3, 316*m6Scale);
            _backBtn.tag = 100+i;
            [_backBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            _backBtn.backgroundColor = [UIColor whiteColor];
            [self.contentView addSubview:_backBtn];
            //商品名称
            _goodsLabel = [Factory CreateLabelWithTextColor:1 andTextFont:28 andText:@"苹果7" addSubView:_backBtn];
            _goodsLabel.tag = 500+i;
            _goodsLabel.textColor = UIColorFromRGB(0x505050);
            _goodsLabel.textAlignment = NSTextAlignmentCenter;
            [_goodsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(42*m6Scale);
                make.width.mas_equalTo(kScreenWidth/3);
                make.left.mas_equalTo(0);
            }];
            //商品价格
            _priceLabel = [Factory CreateLabelWithTextColor:0 andTextFont:22 andText:@"官方原价7,188" addSubView:_backBtn];
            _priceLabel.tag = 200+i;
            _priceLabel.textColor = UIColorFromRGB(0x505050);
            _priceLabel.textAlignment = NSTextAlignmentCenter;
            [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_goodsLabel.mas_bottom).offset(10*m6Scale);
                make.width.mas_equalTo(kScreenWidth/3);
                make.left.mas_equalTo(0);
            }];
            //商品图标
            _iconImgView = [[UIImageView alloc] init];
            _iconImgView.tag = 300+i;
            [_backBtn addSubview:_iconImgView];
            [_iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(210*m6Scale, 130*m6Scale));
                make.centerX.mas_equalTo(_backBtn.mas_centerX);
                make.top.mas_equalTo(_priceLabel.mas_bottom).offset(20*m6Scale);
            }];
            //投资
            UILabel *investLabel = [Factory CreateLabelWithTextColor:0 andTextFont:22 andText:@"投资" addSubView:_backBtn];
            investLabel.textColor = UIColorFromRGB(0x9f9e9e);
            [investLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(20*m6Scale);
                make.bottom.mas_equalTo(-12*m6Scale);
            }];
            //起投金额
            _amountLabel = [Factory CreateLabelWithTextColor:0 andTextFont:22 andText:@"10,000元起" addSubView:_backBtn];
            _amountLabel.tag = 400+i;
            _amountLabel.textColor = UIColorFromRGB(0xff5933);
            [_amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-40*m6Scale);
                make.bottom.mas_equalTo(-12*m6Scale);
            }];
        }
    }
    return self;
}

- (void)cellForGoodsArr:(NSArray *)goodsArr TypeName:(NSString *)typeName{
    //每种类型展示的商品数量 （最多三个）
    [self showNumberOfGoodsByArray:goodsArr];
    
    self.goodsArr = goodsArr;
}
/**
 *每种类型展示的商品数量 （最多三个）
 */
- (void)showNumberOfGoodsByArray:(NSArray *)array{
    if (array.count > 2) {
        for (int i = 0; i < 3; i++) {
            [self makeSureDataByIndex:i andArray:array];
            UIButton *backBtn = (UIButton *)[self.contentView viewWithTag:100+i];
            backBtn.hidden = NO;
        }
    }else{
        for (int i = 0; i < 3; i++) {
            UIButton *backBtn = (UIButton *)[self.contentView viewWithTag:100+i];
            if (i < array.count) {
                [self makeSureDataByIndex:i andArray:array];
                backBtn.hidden = NO;
            }else{
                backBtn.hidden = YES;
            }
        }
    }
}
/**
 *
 */
- (void)makeSureDataByIndex:(NSInteger)index andArray:(NSArray *)array{
    IphoneModel *model = array[index];
    //商品名称
    UILabel *goodsLabel = (UILabel *)[self.contentView viewWithTag:500+index];
    goodsLabel.text = [NSString stringWithFormat:@"%@", model.goodsName];
    //商品价格
    UILabel *priceLabel = (UILabel *)[self.contentView viewWithTag:200+index];
    priceLabel.text = [NSString stringWithFormat:@"￥%d", model.originalPrice.intValue];
    //商品icon
    UIImageView *iconImgView = (UIImageView *)[self.contentView viewWithTag:300+index];
    //将商品分割成数组
    NSArray *picArr = [model.imageId componentsSeparatedByString:@","];
    if (picArr.count) {
        NSString *iconName = picArr[0];//展示第一张
        [iconImgView sd_setImageWithURL:[NSURL URLWithString:iconName]];
    }
    //起投金额
    UILabel *amountLabel = (UILabel *)[self.contentView viewWithTag:400+index];
    amountLabel.text = [NSString stringWithFormat:@"%ld元起", model.minAmount.integerValue];
    UIColor *color = [UIColor colorWithWhite:0.5 alpha:1];
    [Factory ChangeColorString:@"起" andLabel:amountLabel andColor:color];
}
/**
 *按钮的点击事件
 */
- (void)buttonClick:(UIButton *)sender{
    if ([HCJFNSUser stringForKey:@"userId"]) {
        GoodsListVC *strVC = (GoodsListVC *)[self.contentView ViewController];
        IphoneDetailsVC *tempVC = [IphoneDetailsVC new];
        IphoneModel *model = self.goodsArr[sender.tag-100];
        tempVC.goodsID = [NSString stringWithFormat:@"%@", model.ID];
        [strVC.navigationController pushViewController:tempVC animated:YES];
    }else{
        [Factory alertMes:@"请您先登录"];
    }
}

@end
