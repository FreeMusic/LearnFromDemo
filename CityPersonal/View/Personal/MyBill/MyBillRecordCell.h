//
//  MyBillRecordCell.h
//  CityJinFu
//
//  Created by mic on 2017/6/7.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectListModel.h"

@interface MyBillRecordCell : UITableViewCell

@property (nonatomic,strong) UILabel *dataLabel;//期数标签
@property (nonatomic,strong) UILabel *timeLabel;//时间标签
@property (nonatomic,strong) UILabel *capitalLabel;//本金标签
@property (nonatomic,strong) UILabel *rateLabel;//利息标签

- (void)cellForModel:(CollectListModel *)model IndexPath:(NSIndexPath *)indexPath;

@end
