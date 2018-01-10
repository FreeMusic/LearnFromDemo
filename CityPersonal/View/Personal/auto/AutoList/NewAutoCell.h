//
//  NewAutoCell.h
//  CityJinFu
//
//  Created by hanling on 16/9/27.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AutoListModel.h"

@interface NewAutoCell : UITableViewCell
@property (nonatomic, strong) UILabel * moneyType;
@property (nonatomic, strong) UILabel *dueTime;
@property (nonatomic, strong) UIImageView *signImg;
@property (nonatomic, strong) UILabel *moneyLab;
@property (nonatomic, strong) UILabel *dueTimeLab;
@property (nonatomic, strong) UILabel *describeLab;
@property (nonatomic, strong) UISwitch *mySwitch;
@property (nonatomic, strong) UILabel *timeLabel;//锁定时间

/**
 *  自动投标记录
 */
- (void)newAutoListModel:(AutoListModel *)model andIndexPath:(NSIndexPath *)indexPath;

@end
