//
//  ShopBannerModel.m
//  CityJinFu
//
//  Created by mic on 2017/7/25.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "ShopBannerModel.h"

@implementation ShopBannerModel

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
