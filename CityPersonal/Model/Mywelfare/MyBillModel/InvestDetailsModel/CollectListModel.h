//
//  CollectListModel.h
//  CityJinFu
//
//  Created by mic on 2017/6/19.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectListModel : NSObject

@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSNumber *collectCurrentPeriod;//期数
@property (nonatomic, strong) NSNumber *collectPrincipal;//本金
@property (nonatomic, strong) NSNumber *collectInterest;//利息
@property (nonatomic, strong) NSNumber *collectTime;//时间
@property (nonatomic, strong) NSString *collectStatus;//交易状态：0-还款中 1-已还款

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
