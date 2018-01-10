//
//  OrderModel.h
//  CityJinFu
//
//  Created by mic on 2017/6/15.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderModel : NSObject

@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSNumber *goodsName;//商品名称
@property (nonatomic, strong) NSNumber *goodsNum;//商品数量
@property (nonatomic, strong) NSNumber *investRate;//锁定利率
@property (nonatomic, strong) NSNumber *lockCycle;//锁定期限
@property (nonatomic, strong) NSNumber *investInterest;//锁定预期收益
@property (nonatomic, strong) NSNumber *orderAmount;//锁定金额
@property (nonatomic, strong) NSNumber *orderNo;//订单编号
@property (nonatomic, strong) NSNumber *receiveMobile;//收货联系人手机号
@property (nonatomic, strong) NSNumber *receiveName;//收货联系人
@property (nonatomic, strong) NSNumber *address;//收货地址
@property (nonatomic, strong) NSNumber *addtime;//下单时间

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
