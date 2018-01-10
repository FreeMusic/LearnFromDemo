//
//  BillInvestModel.h
//  CityJinFu
//
//  Created by mic on 2017/6/19.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BillInvestModel : NSObject

@property (nonatomic, strong) NSNumber *ID;//ID
@property (nonatomic, strong) NSString *itemName;//标名称
@property (nonatomic, strong) NSNumber *investStatus;//状态(投资状态 -1审核中 0-投资成功 1投资成功 2投资失败 3-投资成功)
@property (nonatomic, strong) NSNumber *investDealAmount;//投资金额
@property (nonatomic, strong) NSNumber *collectInterest;//预期收益
@property (nonatomic, strong) NSNumber *addtime;//投资日期
@property (nonatomic, strong) NSNumber *itemRate;//利率(往期年化收益)
@property (nonatomic, strong) NSNumber *itemCycle;//项目期限
@property (nonatomic, strong) NSNumber *itemCycleUnit;//期限单位
@property (nonatomic, strong) NSNumber *investType;//投资类型（1-PC 2-APP端3-WAP端 4-微信端-5-自动投标 6-体验金使用 7.iOS端 8.安卓端 9-锁定自动投标 10-非锁定自动投标） 如果类型为6则查看合同无效，点击无效
@property (nonatomic, strong) NSNumber *couponAmount;//红包金额
@property (nonatomic, strong) NSNumber *itemRepayMethod;//还款方式 1-一次性还款 2-等额本息 3-先息后本 4-每日付息
@property (nonatomic, strong) NSNumber *fullTime;//起息时间（如果为null 则显示未起息）
@property (nonatomic, strong) NSString *contractUrl;//查看合同地址
@property (nonatomic, strong) NSNumber *itemAddRate;//加息

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
