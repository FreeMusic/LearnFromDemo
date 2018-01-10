//
//  MoreStrategyModel.h
//  CityJinFu
//
//  Created by mic on 2017/7/11.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoreStrategyModel : NSObject

@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSNumber *isDelete;//isDelete：1任务生效，0不生效
@property (nonatomic, strong) NSString *icon;//图标地址rul
@property (nonatomic, strong) NSNumber *status;//1已完成，未完成
@property (nonatomic, strong) NSNumber *rule;//任务加积分
@property (nonatomic, strong) NSString *remark;//该条任务具体描述
@property (nonatomic, strong) NSNumber *integralType;//1实名；2邀请好友，3首次开启自动投标；4设置锁投；5-投资；6-积分商城消费；7-签到；8-活动福利

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
