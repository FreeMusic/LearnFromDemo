//
//  RedModel.h
//  CityJinFu
//
//  Created by xxlc on 16/9/10.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RedModel : NSObject
@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSNumber *amount;//金额
@property (nonatomic, strong) NSNumber *requireAmount;//满足条件
@property (nonatomic, strong) NSNumber *status;//状态
@property (nonatomic, strong) NSNumber *expiredTime;//时间
@property (nonatomic, copy) NSString *couponName;//限制使用条件
@property (nonatomic, strong) NSNumber *scope;//红包限制的使用期限
@property (nonatomic, copy) NSString *goldName;
@property (nonatomic, copy) NSString *jumpPage;//跳转到如何领取
@property (nonatomic, strong) NSNumber *canUse;//红包是否能用
@property (nonatomic, strong) NSNumber *usefulLife;//投资期限
@property (nonatomic, strong) NSNumber *rate;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
