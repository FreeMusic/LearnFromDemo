//
//  AwardDetailsModel.h
//  CityJinFu
//
//  Created by mic on 2017/6/12.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AwardDetailsModel : NSObject

@property (nonatomic,strong) NSString *name;//姓名
@property (nonatomic,strong) NSString *amount;//奖励金额
@property (nonatomic, strong) NSString *type;//类型
@property (nonatomic, strong) NSNumber *addtime;//时间
@property (nonatomic, strong) NSString *isSend;//奖励是否发放

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
