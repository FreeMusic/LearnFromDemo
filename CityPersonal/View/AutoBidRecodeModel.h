//
//  AutoBidRecodeModel.h
//  CityJinFu
//
//  Created by mic on 16/9/27.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AutoBidRecodeModel : NSObject
@property (nonatomic, strong) NSNumber *investDealAmount;//金额
@property (nonatomic, strong) NSNumber *addtime;//时间
@property (nonatomic, strong) NSNumber *collectInterest;//收益
@property (nonatomic, strong) NSString *itemName;//项目标题

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
