//
//  NSMutableArray+clip.m
//  JustDemon
//
//  Created by 姜姜敏 on 17/2/7.
//  Copyright © 2017年 clip. All rights reserved.
//

#import "NSMutableArray+clip.h"
#import <objc/runtime.h>

@implementation NSMutableArray (clip)

+ (void)load {
    //数组防错措施
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Method systemMethod = class_getInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(addObject:));
        Method currentMethod = class_getInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(add_clipObject:));
        
        method_exchangeImplementations(systemMethod, currentMethod);
        
    });
}

- (void)add_clipObject:(id)object {

    if (object) {
        
        [self add_clipObject:object];
    }
}

@end
