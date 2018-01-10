//
//  ItemDetailsModel.h
//  CityJinFu
//
//  Created by mic on 2017/6/16.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemDetailsModel : NSObject

@property (nonatomic,strong) NSNumber *ID;
@property (nonatomic,strong) NSNumber *itemRate;//利率
@property (nonatomic,strong) NSNumber *itemAddRate;//增加利率
@property (nonatomic,strong) NSString *itemName;//标名
@property (nonatomic, strong) NSString *itemSecondName;//标的副标题
@property (nonatomic,strong) NSNumber *itemAccount;//总额
@property (nonatomic,strong) NSNumber *itemOngoingAccount;//投资中的金额
@property (nonatomic,strong) NSNumber *itemRepayMethod;//'还款方式 1-一次性还款 2-等额本息 3-先息后本 4-每日付息',
@property (nonatomic,strong) NSNumber *itemCycle;//期限
@property (nonatomic,strong) NSNumber *itemCycleUnit;//时间单位
@property (nonatomic,strong) NSString *activityWelfare;//活动福利
@property (nonatomic,strong) NSNumber *itemSingleMinInvestment;//起投金额
@property (nonatomic,strong) NSNumber *prepayment;//提前还款
@property (nonatomic, strong) NSString *password;//定向标的标密码
@property (nonatomic, strong) NSNumber *itemStatus;//标的状态

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
