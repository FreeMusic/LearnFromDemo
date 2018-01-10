//
//  MyBillHeaderCell.h
//  CityJinFu
//
//  Created by xxlc on 17/5/25.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BillAcountModel.h"
#import "BillDataModel.h"

@interface MyBillHeaderCell : UITableViewCell
@property (nonatomic, strong) UILabel *invistlab;//累计投资
@property (nonatomic, strong) UILabel *invistMoneyLab;//累计投资金额
@property (nonatomic, strong) UILabel *incomLabe;//累计收益
@property (nonatomic, strong) UILabel *incomMoeyLab;//累计收益元
@property (nonatomic, strong) UILabel *timeLab;//时间
@property (nonatomic,strong) UILabel *dayLabel;//起止时间标签

- (void)cellForModel:(BillAcountModel *)model andDataModel:(BillDataModel *)dataModel Year:(NSString *)year Month:(NSString *)month;

@end
