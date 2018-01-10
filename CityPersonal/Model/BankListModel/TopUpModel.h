//
//  TopUpModel.h
//  CityJinFu
//
//  Created by mic on 2017/10/19.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopUpModel : NSObject

@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSString *bankIcon;//支付公司图标
@property (nonatomic, strong) NSString *alias;//支付公司名称
@property (nonatomic, strong) NSString *descriptionType;//单笔限额描述
@property (nonatomic, strong) NSNumber *isDefault;//是否是默认
@property (nonatomic, strong) NSNumber *paymentId;//支付公司ID
@property (nonatomic, strong) NSString *logoUrl;//支付公司icon
@property (nonatomic, strong) NSNumber *singleLimitAmount;//银行单笔限额

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
