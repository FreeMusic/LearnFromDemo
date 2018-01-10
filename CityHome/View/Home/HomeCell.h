//
//  HomeCell.h
//  CityJinFu
//
//  Created by 姜姜敏 on 16/9/12.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewItemModel.h"

@interface HomeCell : UITableViewCell
@property (nonatomic, strong) UILabel *titlelab;//项目名称
@property (nonatomic, strong) UILabel *itemTitle;//项目副标题
@property (nonatomic, strong) UILabel *ratelab; //利率
@property (nonatomic, strong) UILabel *extraLabel;//额外加息
@property (nonatomic, strong) UILabel *rateTitle;//利率标题
@property (nonatomic, strong) UILabel *cycleLabel; //期限
@property (nonatomic, strong) UILabel *accountLabel;//项目总额
@property (nonatomic, strong) UILabel *moneyLabel; //起投金额
@property (nonatomic, strong) UIImageView *hotImageView; //图标
@property (nonatomic, strong) UIImageView *backImageView;//背景
@property (nonatomic, strong) UIButton *invistBtn; //投资按钮

- (void)cellForModel:(NewItemModel *)model;

@end
