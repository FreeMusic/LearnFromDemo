//
//  MyiPhoneCell.h
//  CityJinFu
//
//  Created by mic on 2017/5/31.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IphoneModel.h"

@interface MyiPhoneCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *backImgView;//大图片
@property (nonatomic,strong) UILabel *goodsLabel;//产品标签
@property (nonatomic,strong) UILabel *priceLabel;//价格
@property (nonatomic,strong) UILabel *accountLabel;//起投金额数字

- (void)cellForModel:(IphoneModel *)model andIndex:(NSInteger)index;

@end
