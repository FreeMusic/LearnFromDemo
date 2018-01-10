//
//  VipClubModel.h
//  CityJinFu
//
//  Created by xxlc on 17/6/28.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VipClubModel : NSObject

@property (nonatomic, strong) NSNumber *memberGrade;//会员等级
@property (nonatomic, strong) NSNumber *nextYearAmount;//下一等级年化额
@property (nonatomic, strong) NSNumber *usable;//可用积分
@property (nonatomic, strong) NSString *userName;//用户名称
@property (nonatomic, strong) NSNumber *yearAmount;//当前年化额

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
