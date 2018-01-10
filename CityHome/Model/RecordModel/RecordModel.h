//
//  RecordModel.h
//  CityJinFu
//
//  Created by xxlc on 16/9/11.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordModel : NSObject
@property (nonatomic, strong) NSNumber *investDealAmount;//投资金额
@property (nonatomic, strong) NSNumber *investType;//投资类型
@property (nonatomic, strong) NSString *username;//投资人
@property (nonatomic, strong) NSNumber *addtime;//投资时间
@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSString *mobile;//手机号

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
