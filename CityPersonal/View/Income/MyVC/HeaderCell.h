//
//  HeaderCell.h
//  CityJinFu
//
//  Created by xxlc on 17/5/23.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderCell : UITableViewCell
@property (nonatomic, strong) UILabel *sumLabel;//总资产
@property (nonatomic, strong) UILabel *titleClipLabel;//总资产字体
@property (nonatomic, strong) UILabel *collectedLabel;//待收金额
@property (nonatomic, strong) UILabel *collectedtitle;//待收金额
@property (nonatomic, strong) UILabel *totalIncomeLabel;//累计收益
@property (nonatomic, strong) UILabel *totaltitlelab;//累计收益字体

@end
