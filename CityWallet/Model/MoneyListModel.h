//
//  MoneyListModel.h
//  CityJinFu
//
//  Created by mic on 2017/6/16.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoneyListModel : NSObject

@property (nonatomic,strong) NSNumber *ID;
@property (nonatomic,strong) NSString *itemName;//标题
@property (nonatomic,strong) NSNumber *itemStatus;//标状态
@property (nonatomic,strong) NSNumber *itemType;//项目类型
@property (nonatomic,strong) NSNumber *itemRate;//利率
@property (nonatomic,strong) NSNumber *itemAddRate;//增加利率
@property (nonatomic,strong) NSNumber *itemCycle;//期限
@property (nonatomic,strong) NSNumber *itemCycleUnit;//时间单位
@property (nonatomic,strong) NSNumber *itemScale;//水波纹进度
@property (nonatomic,strong) NSNumber *itemIsrecommend;//是否推荐：0-否 1-推荐表（优先）
@property (nonatomic,strong) NSNumber *moveVip;//是否移动专享0-否1-是'(优先)
@property (nonatomic,strong) NSString *password;//如果是null 或者 ''则不是定向标 反之是定向标（优先1）
@property (nonatomic,strong) NSNumber *itemIsnew;//是否新手：0-否 1-推荐表（优先1）
@property (nonatomic, strong) NSNumber *isExclusive;//会员标
@property (nonatomic, strong) NSNumber *releaseTime;//预约标到期时间
@property (nonatomic,strong) NSNumber *appointId;//是否预约：有值代表预约，null未预约
@property (nonatomic, strong) NSNumber *endTime;//结束时间

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
