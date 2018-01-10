//
//  VipBottomCell.h
//  CityJinFu
//
//  Created by mic on 2017/7/4.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsRecomondModel.h"

@interface VipBottomCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imgView;//图标
@property (nonatomic, strong) UIImageView *iconImgView;//倒计时图标
@property (nonatomic, strong) UILabel *timeLabel;//上标签
@property (nonatomic, strong) UILabel *welfLabel;//福利标签
//商品的赋值
- (void)cellForArray:(NSMutableArray *)array;

@end
