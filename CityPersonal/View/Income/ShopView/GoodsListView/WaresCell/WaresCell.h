//
//  WaresCell.h
//  CityJinFu
//
//  Created by mic on 2017/7/25.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendModel.h"

@interface WaresCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imgView;//商品图片
@property (nonatomic, strong) UILabel *goodsLabel;//商品名称
@property (nonatomic, strong) UILabel *amountLabel;//起投金额

- (void)cellForModel:(RecommendModel *)model;

@end
