//
//  ContractModel.m
//  CityJinFu
//
//  Created by 姜姜敏 on 16/12/28.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "ContractModel.h"

@implementation ContractModel

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
