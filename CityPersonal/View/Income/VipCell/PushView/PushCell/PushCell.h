//
//  PushCell.h
//  CityJinFu
//
//  Created by mic on 2017/7/15.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PushCell : UITableViewCell

@property (nonatomic, strong) UILabel *gradeLabel;//会员等级
@property (nonatomic, strong) UILabel *birthLabel;//生日奖励标签
@property (nonatomic, strong) UILabel *useLabel;//使用标签

- (void)setCellByEquity:(NSString *)equity andIndex:(NSInteger)index;

@end
