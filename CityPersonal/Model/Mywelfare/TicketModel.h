//
//  TicketModel.h
//  CityJinFu
//
//  Created by xxlc on 16/9/10.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TicketModel : NSObject
@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSNumber *rate;//加息利率
@property (nonatomic, strong) NSNumber *requireAmount;//满足条件
@property (nonatomic, strong) NSNumber *status;//状态
@property (nonatomic, strong) NSNumber *expiredTime;//时间
@property (nonatomic, copy) NSString *couponName;//限制使用条件
@property (nonatomic, copy) NSNumber *scope;//加息劵限制的使用期限
@property (nonatomic, copy) NSString *jumpPage;//跳转到如何领取
@property (nonatomic, copy) NSString *ticketName;//加息劵名字
@property (nonatomic, strong) NSNumber *usefulLife;//加息天数
@property (nonatomic, strong) NSNumber *canUse;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
