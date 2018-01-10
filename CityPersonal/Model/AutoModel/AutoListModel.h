//
//  AutoListModel.h
//  CityJinFu
//
//  Created by xxlc on 16/9/28.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AutoListModel : NSObject
@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSNumber *itemAmount;//投资金额
@property (nonatomic, strong) NSNumber *itemAmountType;//投资金额类型
@property (nonatomic, strong) NSNumber *itemLockStatus;//锁定的状态
@property (nonatomic, strong) NSNumber *itemLockCycle;//锁定的天数
@property (nonatomic, strong) NSNumber *itemAddRate;//加息利率
@property (nonatomic, strong) NSNumber *itemDayMax;//最大期限
@property (nonatomic, strong) NSNumber *itemDayMin;//最小期限
@property (nonatomic, strong) NSNumber *itemRateMax;//最大利率
@property (nonatomic, strong) NSNumber *itemRateMin;//最小利率
@property (nonatomic, strong) NSNumber *itemStatus;//开关状态
@property (nonatomic, strong) NSNumber *addtime;//添加时间
@property (nonatomic, strong) NSNumber *investingAmount;//投资中的金额
@property (nonatomic, strong) NSNumber *itemType;// 标的类型 0 不限  1.学车宝 2.车商宝 3.车贷宝 4.车易保

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
