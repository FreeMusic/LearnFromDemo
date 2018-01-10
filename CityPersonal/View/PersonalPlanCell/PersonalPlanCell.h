//
//  PersonalPlanCell.h
//  CityJinFu
//
//  Created by mic on 2017/7/14.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyPlanModel.h"

@interface PersonalPlanCell : UITableViewCell

@property (nonatomic, strong) UILabel *amountLabel;//锁定本金标签
@property (nonatomic, strong) UILabel *dateLabel;//锁定期限
@property (nonatomic, strong) UILabel *timeLabel;//锁定日期

- (void)cellForModel:(MyPlanModel *)model;

@end
