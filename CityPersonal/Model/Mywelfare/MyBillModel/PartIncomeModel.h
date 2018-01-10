//
//  PartIncomeModel.h
//  CityJinFu
//
//  Created by mic on 2017/6/12.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PartIncomeModel : NSObject

@property (nonatomic,strong) NSString *itemName;//标名称
@property (nonatomic,strong) NSNumber *collectPrincipal;//本金
@property (nonatomic,strong) NSString *collectInterest;//利息
@property (nonatomic,strong) NSNumber *collectId;//ID

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
