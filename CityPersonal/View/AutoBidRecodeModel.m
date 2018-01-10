//
//  AutoBidRecodeModel.m
//  CityJinFu
//
//  Created by mic on 16/9/27.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "AutoBidRecodeModel.h"

@implementation AutoBidRecodeModel

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

@end
