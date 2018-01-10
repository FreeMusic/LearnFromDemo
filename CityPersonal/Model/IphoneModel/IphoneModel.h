//
//  IphoneModel.h
//  CityJinFu
//
//  Created by mic on 2017/6/13.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IphoneModel : NSObject

@property (nonatomic,strong) NSNumber *ID;//ID
@property (nonatomic,strong) NSNumber *goodsName;//商品名称
@property (nonatomic,strong) NSNumber *minAmount;//起投金额
@property (nonatomic,strong) NSString *imageId;//商品图片名称
@property (nonatomic,strong) NSNumber *isLimit;//是否限购
@property (nonatomic,strong) NSString *limitNum;//限购数量
@property (nonatomic,strong) NSNumber *count;//库存
@property (nonatomic, strong) NSNumber *originalPrice;//标价

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
