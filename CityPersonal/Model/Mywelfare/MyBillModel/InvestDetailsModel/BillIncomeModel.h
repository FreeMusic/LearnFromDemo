//
//  BillIncomeModel.h
//  CityJinFu
//
//  Created by mic on 2017/6/19.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BillIncomeModel : NSObject

@property (nonatomic, strong) NSString *itemName;//项目名称
@property (nonatomic, strong) NSNumber *collectInterest;//回款收益
@property (nonatomic, strong) NSNumber *collectPrincipal;//回款本金
@property (nonatomic, strong) NSNumber *collectTime;//本期回款日期
@property (nonatomic, strong) NSNumber *investType;//投资类型
@property (nonatomic, strong) NSNumber *investTime;//投资日期
@property (nonatomic, strong) NSNumber *investId;//投资id
@property (nonatomic, strong) NSNumber *investOrder;//投资订单号
@property (nonatomic, strong) NSNumber *itemRate;//利率（往期年化收益）
@property (nonatomic, strong) NSNumber *itemAddRate;//加息利率
@property (nonatomic, strong) NSNumber *itemCycle;//项目期限
@property (nonatomic, strong) NSNumber *itemCycleUnit;//周期单位 1-天、2-月、3-季、4-年
@property (nonatomic, strong) NSNumber *itemRepayMethod;//‘还款方式 1-一次性还款 2-等额本息 3-先息后本 4-每日付息’
@property (nonatomic, strong) NSNumber *collectStatus;//交易状态：0-还款中 1-已还款
@property (nonatomic, strong) NSString *contractUrl;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
