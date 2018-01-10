//
//  AutoRecordModel.h
//  CityJinFu
//
//  Created by mic on 2017/8/9.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AutoRecordModel : NSObject

@property (nonatomic, strong) NSNumber *ID;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
