//
//  TopUpModel.m
//  CityJinFu
//
//  Created by mic on 2017/10/19.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "TopUpModel.h"

@implementation TopUpModel


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
    }else if([key isEqualToString:@"description"]){
        _descriptionType = value;
    }
}
- (id)valueForUndefinedKey:(NSString *)key
{
    return nil;
}

@end
