//
//  GoodsRecomondModel.h
//  CityJinFu
//
//  Created by mic on 2017/8/18.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsRecomondModel : NSObject

@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSString *goodsName;//商品名称
@property (nonatomic, strong) NSString *goodsImage;//商品图片url
@property (nonatomic, strong) NSNumber *goodsIntegral;//购买商品所需要的起始积分

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
