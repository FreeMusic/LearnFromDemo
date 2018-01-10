//
//  AutoListModel.m
//  CityJinFu
//
//  Created by xxlc on 16/9/28.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "AutoListModel.h"

@implementation AutoListModel

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
