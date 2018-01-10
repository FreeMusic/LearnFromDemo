//
//  MoreStrategyCell.h
//  CityJinFu
//
//  Created by mic on 2017/7/11.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreStrategyCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconImgView;//积分图标
@property (nonatomic, strong) UILabel *intergralLabel;//积分标签
@property (nonatomic, strong) UILabel *reasonLabel;//积分加减的原因标签
@property (nonatomic, strong) UILabel *rightLabel;//右标签（可能是时间  或  赚积分 和 已完成任务标签）

- (void)cellForModel:(id)model andType:(NSInteger)type;

@end
