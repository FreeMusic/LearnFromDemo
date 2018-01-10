//
//  BankListModel.h
//  CityJinFu
//
//  Created by mic on 2017/7/20.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BankListModel : NSObject

@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSString *bankName;//银行卡名称
@property (nonatomic, strong) NSString *cardNo;//银行卡号
@property (nonatomic, strong) NSNumber *isCashDefault;//是否提现默认卡(1是 0 否
@property (nonatomic, strong) NSNumber *isRechargeDefault;//是否充值默认卡(1是 0 否）
@property (nonatomic, strong) NSString *bankIcon;//银行卡小图标
@property (nonatomic, strong) NSString *bankBackgroud;//银行卡背景图
@property (nonatomic, strong) NSString *remark;//限额描述
@property (nonatomic, strong) NSNumber *singleLimitAmount;//单笔限额
@property (nonatomic, strong) NSNumber *dayLimitAmount;//日限额


- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
