//
//  MyBillSecondCell.h
//  CityJinFu
//
//  Created by xxlc on 17/5/25.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BillIndexModel.h"

@interface MyBillSecondCell : UITableViewCell
@property (nonatomic, strong) UILabel *leftlab;//本月总览
@property (nonatomic, strong) UILabel *rightlab;//本月提现
@property (nonatomic, strong) UILabel *balancelab;//当前余额
@property (nonatomic, strong) UILabel *totallab;//当前总资产
@property (nonatomic, strong) UILabel *incomlab;//收益总额
@property (nonatomic, strong) UILabel *toplab;//充值
@property (nonatomic, strong) UILabel *withdrawlab;//提现

- (void)cellForModel:(BillIndexModel *)model;

@end
