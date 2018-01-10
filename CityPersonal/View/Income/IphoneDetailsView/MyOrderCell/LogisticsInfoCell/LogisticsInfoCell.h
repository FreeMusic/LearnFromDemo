//
//  LogisticsInfoCell.h
//  CityJinFu
//
//  Created by mic on 2017/6/28.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogisticsInfoModel.h"

@interface LogisticsInfoCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;//标题
@property (nonatomic, strong) UILabel *timeLabel;//时间
@property (nonatomic, strong) LogisticsInfoModel *model;
@property (nonatomic, strong) UIImageView *progressImg;//进度图标
@property (nonatomic, strong) UIView *line;//单线

- (void)cellForModel:(LogisticsInfoModel *)mdoel index:(NSInteger)index;

@end
