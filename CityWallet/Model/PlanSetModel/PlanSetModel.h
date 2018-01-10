//
//  PlanSetModel.h
//  CityJinFu
//
//  Created by mic on 2017/7/17.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlanSetModel : NSObject

@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSString *planRate;//利率
@property (nonatomic, strong) NSNumber *planAddRate;//加息利率
@property (nonatomic, strong) NSNumber *planCycle;//锁投期限
@property (nonatomic, strong) NSNumber *planAmount;//开放额度
@property (nonatomic, strong) NSNumber *planBlance;//开放剩余额度
@property (nonatomic, strong) NSNumber *planMinLimit;//起投金额

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
