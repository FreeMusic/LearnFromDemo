//
//  NoticeLIstModel.h
//  CityJinFu
//
//  Created by mic on 2017/6/19.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoticeLIstModel : NSObject

@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSString *name;//名称

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
