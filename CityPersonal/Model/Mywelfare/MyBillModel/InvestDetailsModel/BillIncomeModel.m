//
//  BillIncomeModel.m
//  CityJinFu
//
//  Created by mic on 2017/6/19.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "BillIncomeModel.h"

@implementation BillIncomeModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (id)valueForUndefinedKey:(NSString *)key
{
    return nil;
}

@end
