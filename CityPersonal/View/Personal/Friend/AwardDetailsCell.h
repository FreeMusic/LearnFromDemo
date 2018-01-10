//
//  AwardDetailsCell.h
//  CityJinFu
//
//  Created by mic on 2017/6/12.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AwardDetailsModel.h"

@interface AwardDetailsCell : UITableViewCell

@property (nonatomic,strong) UILabel *nameLabel;//姓名标签
@property (nonatomic,strong) UILabel *amountLabel;//奖励金额标签
@property (nonatomic, strong) UILabel *typeLabel;//类型标签
@property (nonatomic, strong) UILabel *provideLabel;//是否发放标签

- (void)cellForModel:(AwardDetailsModel *)model;

@end
