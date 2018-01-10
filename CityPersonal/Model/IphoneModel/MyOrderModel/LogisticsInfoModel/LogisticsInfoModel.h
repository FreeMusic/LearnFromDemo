//
//  LogisticsInfoModel.h
//  CityJinFu
//
//  Created by mic on 2017/6/28.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogisticsInfoModel : NSObject

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *context;//快件物流信息
@property (nonatomic, strong) NSString *time;//时间
@property (nonatomic, strong) NSNumber *status;//物流状态

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
