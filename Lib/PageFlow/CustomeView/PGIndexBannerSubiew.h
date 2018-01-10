//
//  PGIndexBannerSubiew.h
//  NewPagedFlowViewDemo
//
//  Created by Mars on 16/6/18.
//  Copyright © 2016年 Mars. All rights reserved.
//  Designed By PageGuo,
//  QQ:799573715
//  github:https://github.com/PageGuo/NewPagedFlowView

/******************************
 
 可以根据自己的需要再次重写view
 
 ******************************/

#import <UIKit/UIKit.h>
#import "ItemListModel.h"

@interface PGIndexBannerSubiew : UIView

/**
 *  主图
 */
@property (nonatomic, strong) UIImageView *mainImageView;

/**
 *  用来变色的view
 */
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIImageView *iconImageView;//区分不同的标
@property (nonatomic, strong) UILabel *itemName;//标名
@property (nonatomic, strong) UILabel *rateLab;//利率
@property (nonatomic, strong) UILabel *rateTitle;//利率标题
@property (nonatomic, strong) UILabel *cycleTime;//期限
@property (nonatomic, strong) UILabel *cycleTitle;//投资期限
@property (nonatomic, strong) UILabel *invistBtn;//立即投资

- (void)viewForModel:(ItemListModel *)model;

@end
