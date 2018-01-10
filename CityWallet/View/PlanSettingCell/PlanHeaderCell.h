//
//  PlanHeaderCell.h
//  CityJinFu
//
//  Created by mic on 2017/7/13.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlanSetModel.h"

@interface PlanHeaderCell : UITableViewCell

@property (nonatomic, strong) UILabel *rateLabel;//利率标签
@property (nonatomic, strong) UILabel *yearLabel;//往期年化
@property (nonatomic, strong) UILabel *cycleLabel;//期限标签
@property (nonatomic, strong) UILabel *addLabel;//加息标签
@property (nonatomic, strong) PlanSetModel *model;

@end
