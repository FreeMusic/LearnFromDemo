//
//  ActivityModel.m
//  CityJinFu
//
//  Created by 姜姜敏 on 16/10/27.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "ActivityModel.h"

@implementation ActivityModel

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
