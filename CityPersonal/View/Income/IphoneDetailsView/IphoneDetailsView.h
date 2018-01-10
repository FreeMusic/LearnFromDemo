//
//  IphoneDetailsView.h
//  CityJinFu
//
//  Created by mic on 2017/6/1.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IphoneDetailsModel.h"
#import "GoodsKindsModel.h"

@interface IphoneDetailsView : UIView

@property (nonatomic,strong) UIImageView *topImgView;//顶部背景图
@property (nonatomic,strong) UILabel *titleLabel;//标题标签
@property (nonatomic,strong) UILabel *nowLabel;//现有标配标签
@property (nonatomic,strong) UILabel *stockLaabel;//库存、是否限购
@property (nonatomic,strong) UIButton *serviceBtn;//客服按钮
@property (nonatomic,strong) UILabel *priceLabel;//售价
@property (nonatomic,strong) UILabel *referLabel;//参考价
@property (nonatomic,strong) UILabel *expressLabel;//快递
@property (nonatomic,strong) UILabel *dataLabel;//期限标签
@property (nonatomic,strong) UIButton *dataBtn;//期限按钮
@property (nonatomic,strong) UILabel *label;//（投资金额、利率、收益标签）
@property (nonatomic,strong) UILabel *accountLabel;//投资金额
@property (nonatomic,strong) UILabel *rateLabel;//投资利率
@property (nonatomic,strong) UILabel *incomeLabel;//预期收益
@property(nonatomic, strong) UIView *line;//四条横线
@property (nonatomic, assign) NSInteger account;

- (void)viewForModel:(IphoneDetailsModel *)model;

- (void)viewForDataArray:(NSArray *)array;

@end
