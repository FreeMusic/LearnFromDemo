//
//  PlanCell.h
//  CityJinFu
//
//  Created by mic on 2017/7/12.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYWaveProgressView.h"
#import "PlanModel.h"

@interface PlanCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLabel;//标题标签
@property (nonatomic,strong) UILabel *typeLabel;//类型的标签
@property (nonatomic,strong) UILabel *rateLabel;//年化利率标签
@property (nonatomic,strong) UILabel *addRateLabel;//增加利率标签
@property (nonatomic,strong) UILabel *dataLabel;//期限标签
@property (nonatomic, strong) UILabel *amountLabel;//起头金额标签
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UIView *backView;//加息利率背景图
@property (nonatomic,strong) UIView *line;
@property (nonatomic,strong) UILabel *buyLabel;//等待开抢标签
@property (nonatomic, strong) TYWaveProgressView *waveProgressView;//波浪图
@property (nonatomic, strong) UIButton *btn;//加在波浪图上的点击按钮

- (void)cellForModel:(PlanModel *)model;

@end
