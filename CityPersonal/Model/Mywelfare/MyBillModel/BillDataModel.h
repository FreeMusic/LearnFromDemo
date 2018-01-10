//
//  BillDataModel.h
//  CityJinFu
//
//  Created by mic on 2017/6/12.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BillDataModel : NSObject

@property (nonatomic,strong) NSString *beginDay;//开始日期
@property (nonatomic,strong) NSString *endDay;//结束日期

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
