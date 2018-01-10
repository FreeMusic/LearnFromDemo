//
//  PlanModel.h
//  CityJinFu
//
//  Created by mic on 2017/7/12.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlanModel : NSObject

@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSString *planName;//理财计划名称
@property (nonatomic, strong) NSString *planRate;//计划利率
@property (nonatomic, strong) NSNumber *planAddRate;//计划加息
@property (nonatomic, strong) NSNumber *planCycle;//锁定期限（90--3个月  180--6个月  360-- 12个月）
@property (nonatomic, strong) NSNumber *planMinLimit;//计划起投金额
@property (nonatomic, strong) NSNumber *planAmount;//计划额度
@property (nonatomic, strong) NSNumber *planBlance;//计划剩余额度


- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
