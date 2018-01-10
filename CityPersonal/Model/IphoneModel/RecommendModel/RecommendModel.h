//
//  RecommendModel.h
//  CityJinFu
//
//  Created by mic on 2017/7/25.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecommendModel : NSObject

@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSString *goodsName;//商品名称
@property (nonatomic, strong) NSString *imageId;//图片数组
@property (nonatomic, strong) NSNumber *minAmount;//最小起投金额

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
