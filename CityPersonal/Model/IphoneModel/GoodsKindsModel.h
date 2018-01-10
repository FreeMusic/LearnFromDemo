//
//  GoodsKindsModel.h
//  CityJinFu
//
//  Created by mic on 2017/6/14.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsKindsModel : NSObject

@property (nonatomic,strong) NSNumber *ID;//ID
@property (nonatomic,strong) NSNumber *lockCycle;//锁定期限，单位为月
@property (nonatomic,strong) NSNumber *investAmount;//锁投金额
@property (nonatomic,strong) NSNumber *investRate;//锁投利率
@property (nonatomic,strong) NSNumber *investInterest;//预期收益

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
