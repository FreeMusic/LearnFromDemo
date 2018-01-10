//
//  NewMyBillModel.h
//  CityJinFu
//
//  Created by mic on 2017/10/19.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewMyBillModel : NSObject

@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSNumber *addtime;//交易时间
@property (nonatomic, strong) NSNumber *budgetType;//交易类型
@property (nonatomic, strong) NSString *remark;//交易标题
@property (nonatomic, strong) NSNumber *operMoney;//交易金额
@property (nonatomic, strong) NSNumber *operType;//oper_type 包含invest是投资，包含repay是回款，包含cash是提现，包含recharge是充值

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
