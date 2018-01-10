//
//  MyBillModel.h
//  CityJinFu
//
//  Created by 姜姜敏 on 16/8/30.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyBillModel : NSObject

@property (nonatomic, strong) NSNumber *addtime; //时间戳

@property (nonatomic, strong) NSNumber *budgetType; //投资正负

@property (nonatomic, strong) NSNumber *operMoney; //投资金额

@property (nonatomic, copy) NSString *remark; //投资类型

@property (nonatomic, copy) NSString *operType; //投资类型

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
