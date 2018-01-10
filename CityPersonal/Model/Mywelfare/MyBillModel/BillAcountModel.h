//
//  BillAcountModel.h
//  CityJinFu
//
//  Created by mic on 2017/6/10.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BillAcountModel : NSObject

@property (nonatomic,strong) NSNumber *countInvest;//累计投资
@property (nonatomic,strong) NSString *countIncome;//累计收益

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
