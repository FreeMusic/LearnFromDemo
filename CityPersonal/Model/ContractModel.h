//
//  ContractModel.h
//  CityJinFu
//
//  Created by 姜姜敏 on 16/12/28.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContractModel : NSObject

@property (nonatomic, copy) NSString *itemName; //项目名称
@property (nonatomic, strong) NSNumber *addtime; //时间
@property (nonatomic, copy) NSString *serialNumber; //编号
@property (nonatomic, copy) NSString *url;//跳转路径
@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSNumber *itemStatus;//是否还款状态

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
