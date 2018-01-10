//
//  IphoneDetailsModel.m
//  CityJinFu
//
//  Created by mic on 2017/6/14.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "IphoneDetailsModel.h"

@implementation IphoneDetailsModel

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
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
