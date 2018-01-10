//
//  OrderDetailsModel.h
//  CityJinFu
//
//  Created by mic on 2017/6/22.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderDetailsModel : NSObject

@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSNumber *goodsName;//商品名称
@property (nonatomic, strong) NSNumber *investRate;//锁定利率
@property (nonatomic, strong) NSNumber *lockCycle;//锁定期限
@property (nonatomic, strong) NSNumber *investInterest;//订单预期收益
@property (nonatomic, strong) NSNumber *orderAmount;//锁定金额
@property (nonatomic, strong) NSNumber *goodsNum;//商品数量
@property (nonatomic, strong) NSNumber *goodsId;//商品ID
@property (nonatomic, strong) NSString *address;//收货地址
@property (nonatomic, strong) NSNumber *addtime;//下单时间
@property (nonatomic, strong) NSString *receiveMobile;//收货人联系方式
@property (nonatomic, strong) NSNumber *orderNo;//订单编号
@property (nonatomic, strong) NSNumber *receiveName;//收货人姓名
@property (nonatomic, strong) NSNumber *logisticsOrderNo;//运单编号
@property (nonatomic, strong) NSNumber *logisticsType;//物流公司名称

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
