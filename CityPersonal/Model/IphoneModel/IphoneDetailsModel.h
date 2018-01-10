//
//  IphoneDetailsModel.h
//  CityJinFu
//
//  Created by mic on 2017/6/14.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IphoneDetailsModel : NSObject

@property (nonatomic,strong) NSNumber *goodsId;//商品ID
@property (nonatomic,strong) NSNumber *originalPrice;//原价
@property (nonatomic,strong) NSNumber *nowPrice;//现价
@property (nonatomic,strong) NSNumber *freightPrice;//运费
@property (nonatomic,strong) NSString *imageId;//详情图片滚动图url集合，多个逗号分隔
@property (nonatomic,strong) NSNumber *goodsName;//商品名称
@property (nonatomic,strong) NSNumber *isLimit;//是否限制购买数量,0为限制，1为不限制
@property (nonatomic,strong) NSNumber *limitNum;//单个用户限制购买数量
@property (nonatomic,strong) NSNumber *count;//库存余数

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
