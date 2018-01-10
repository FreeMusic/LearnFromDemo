//
//  MyOrderModel.h
//  CityJinFu
//
//  Created by mic on 2017/6/21.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyOrderModel : NSObject

@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSNumber *goodsName;//商品名称
@property (nonatomic, strong) NSNumber *goodsNum;//商品数量
@property (nonatomic, strong) NSNumber *payStatus;//支付状态 0待支付，1支付,2失败
@property (nonatomic, strong) NSNumber *orderAmount;//订单金额
@property (nonatomic, strong) NSNumber *lockCycle;//锁定期限(单位是月)
@property (nonatomic, strong) NSNumber *addtime;//下单时间
@property (nonatomic, strong) NSNumber *payTime;//支付时间
@property (nonatomic, strong) NSNumber *orderNo;//订单编号
@property (nonatomic, strong) NSNumber *kindId;//kindId
@property (nonatomic, strong) NSNumber *logisticsType;//物流公司名称
@property (nonatomic, strong) NSNumber *logisticsOrderNo;//物流商品单号

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
