//
//  LogisticsInfoModel.m
//  CityJinFu
//
//  Created by mic on 2017/6/28.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "LogisticsInfoModel.h"

@implementation LogisticsInfoModel

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        _ID = value;
    }
}
- (id)valueForUndefinedKey:(NSString *)key
{
    return nil;
}

@end
