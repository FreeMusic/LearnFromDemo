//
//  BillIndexModel.h
//  CityJinFu
//
//  Created by mic on 2017/6/10.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BillIndexModel : NSObject

@property (nonatomic,strong) NSString *cash;//当前可提现
@property (nonatomic,strong) NSString *income;//月收益
@property (nonatomic,strong) NSString *total;//当前总额
@property (nonatomic,strong) NSNumber *countCash;//月提现总额
@property (nonatomic,strong) NSNumber *countRecharge;//月充值总额

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
