//
//  PartInvestModel.h
//  CityJinFu
//
//  Created by mic on 2017/6/12.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PartInvestModel : NSObject

@property (nonatomic,strong) NSString *itemName;//标名称
@property (nonatomic,strong) NSNumber *investPrincipal;//本金
@property (nonatomic,strong) NSString *investInterest;//利息
@property (nonatomic,strong) NSNumber *investId;//ID

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
