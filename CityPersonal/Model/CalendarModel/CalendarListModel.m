//
//  CalendarListModel.m
//  CityJinFu
//
//  Created by mic on 2017/9/28.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "CalendarListModel.h"

@implementation CalendarListModel

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init]) {
        NSLog(@"%@", dic);
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
