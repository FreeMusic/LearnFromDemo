//
//  TopScrollPicture.m
//  xiaoxiaolicai
//
//  Created by mic on 16/4/12.
//  Copyright © 2016年 mic. All rights reserved.
//

#import "TopScrollPicture.h"

@implementation TopScrollPicture
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
