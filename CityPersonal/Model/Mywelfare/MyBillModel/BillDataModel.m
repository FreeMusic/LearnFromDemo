//
//  BillDataModel.m
//  CityJinFu
//
//  Created by mic on 2017/6/12.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "BillDataModel.h"

@implementation BillDataModel

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    //NSLog(@"没有定义的key");
}

- (id)valueForUndefinedKey:(NSString *)key
{
    return nil;
}

@end
