//
//  MyPlanModel.h
//  CityJinFu
//
//  Created by mic on 2017/7/14.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyPlanModel : NSObject

@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSNumber *itemAmount;//规则锁定金额
@property (nonatomic, strong) NSNumber *itemLockCycle;//规则锁定期限
@property (nonatomic, strong) NSNumber *addtime;//规则添加时间

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
