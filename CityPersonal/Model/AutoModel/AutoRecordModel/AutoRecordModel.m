//
//  AutoRecordModel.m
//  CityJinFu
//
//  Created by mic on 2017/8/9.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "AutoRecordModel.h"

@implementation AutoRecordModel
- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dictionary];
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
