//
//  TopUpCell.h
//  CityJinFu
//
//  Created by mic on 2017/10/18.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopUpModel.h"

@interface TopUpCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imgView;//icon

@property (nonatomic, strong) UILabel *typeLabel;//支付公司名称

@property (nonatomic, strong) UILabel *accountLabel;//银行限额

@property (nonatomic, strong) UIButton *slectedBtn;//选中按钮

@property (nonatomic, strong) UIView *line;//单线

- (void)cellForModel:(TopUpModel *)model andSelected:(NSInteger)index andIndexPath:(NSIndexPath *)indexPath;

- (void)didSelectRowAtIndexPath:(NSInteger)index andCurrentIndex:(NSInteger)currentIndex;

- (void)cellForModel:(TopUpModel *)model;

- (void)cellForModel:(TopUpModel *)model andSelected:(NSInteger)index andOtherIndex:(NSInteger)OtherIndex;

- (void)cellRefreshData:(TopUpModel *)model;

@end
