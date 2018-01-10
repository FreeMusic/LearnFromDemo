//
//  NewMyBillCell.h
//  CityJinFu
//
//  Created by mic on 2017/10/18.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewMyBillModel.h"

@interface NewMyBillCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconImgView;//图标icon

@property (nonatomic, strong) UILabel *titleLabel;//标题标签

@property (nonatomic, strong) UILabel *timeLabel;//时间标签

@property (nonatomic, strong) UILabel *accountLabel;//金额标签

- (void)cellForModel:(NewMyBillModel *)model;

@end
